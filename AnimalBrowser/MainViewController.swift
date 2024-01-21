//
//  ViewController.swift
//  AnimalBrowser
//
//  Created by Samuel Napitupulu on 17/01/24.
//

import UIKit
import FSPagerView

enum AnimalInfoViewState: Int {
    case isExpanded
    case isCollapsed
}

class MainViewController: UIViewController, FSPagerViewDataSource, FSPagerViewDelegate {
    
    let imageNames = ["ELEPHANT", "LION", "FOX", "DOG", "SHARK", "TURTLE", "WHALE", "PENGUIN"]
    let iconNames = ["ic_elephant", "ic_lion", "ic_fox", "ic_dog", "ic_shark", "ic_turtle", "ic_whale", "ic_penguin"]
    
    var animalResults: [Animal] = []
    var animalAreas = Set<String>()
    var vwAnimalInfoViewState = AnimalInfoViewState.isCollapsed
    
    lazy var photosViewController : PhotosViewController? =
    {
        let photosViewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotosViewController") as? PhotosViewController
        return photosViewController
    }()
    
    lazy var favoritesViewController : FavoritesViewController? =
    {
        let favoritesViewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavoritesViewController") as? FavoritesViewController
        return favoritesViewController
    }()
    
    @IBOutlet weak var vwAnimalLeadingOrigin:NSLayoutConstraint!
    @IBOutlet weak var vwAnimalLeadingExpanded:NSLayoutConstraint!
    @IBOutlet weak var vwAnimalTrailingOrigin:NSLayoutConstraint!
    @IBOutlet weak var vwAnimalTrailingExpanded:NSLayoutConstraint!
    @IBOutlet weak var vwAnimalTopOrigin:NSLayoutConstraint!
    @IBOutlet weak var vwAnimalTopExpanded:NSLayoutConstraint!
    @IBOutlet weak var vwShowMoreBottomOrigin:NSLayoutConstraint!
    @IBOutlet weak var vwShowMoreBottomExpanded:NSLayoutConstraint!
    
    @IBOutlet weak var lblAnimalNameTopOrigin:NSLayoutConstraint!
    @IBOutlet weak var lblAnimalNameTopExpanded:NSLayoutConstraint!
    
    @IBOutlet weak var imgAnimalTopOrigin:NSLayoutConstraint!
    @IBOutlet weak var imgAnimalTopExpanded:NSLayoutConstraint!
    @IBOutlet weak var imgAnimalHeightOrigin:NSLayoutConstraint!
    @IBOutlet weak var imgAnimalHeightExpanded:NSLayoutConstraint!
    
    
    @IBOutlet weak var vwAnimal: UIView! {
        didSet {
            vwAnimal.layer.shadowOffset = CGSize(width: 100, height: 100)
            vwAnimal.layer.shadowRadius = 10.0
        }
    }
    @IBOutlet weak var vwShowMore: UIView!
    
    @IBOutlet weak var lblAnimalName: UILabel! {
        didSet {
            lblAnimalName.text = imageNames[0]
        }
    }
    @IBOutlet weak var lblAnimalLocations: UILabel?{
        didSet {
            lblAnimalLocations?.text = self.animalAreas.map { String($0) }.joined(separator: ",")
        }
    }
    
    @IBOutlet weak var imgShowMore: UIImageView!{
        didSet {
            imgShowMore.image = UIImage(named: iconNames[0])
        }
    }
    @IBOutlet weak var imgAnimal: UIImageView! {
        didSet {
            self.imgAnimal.image = UIImage(named: imageNames[0])
            self.imgAnimal.alpha = 0.0
        }
    }
    
    @IBOutlet weak var btnFavorite: UIButton!{
        didSet{
            btnFavorite.addTarget(self, action: #selector(goToFavorite), for: .touchUpInside)
        }
    }
    @IBOutlet weak var btnCloseInfo: UIButton!{
        didSet{
            btnCloseInfo.tag = 101
            btnCloseInfo.alpha = 0
            btnCloseInfo.isEnabled = false
            btnCloseInfo.addTarget(self, action: #selector(showMoreInfo), for: .touchUpInside)
        }
    }
    @IBOutlet weak var btnShowMore: UIButton!{
        didSet{
            btnShowMore.tag = 102
            btnShowMore.addTarget(self, action: #selector(showMoreInfo), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            pagerView.isInfinite = true
            pagerView.itemSize = CGSize(width: 330, height: 375)
            pagerView.transformer = FSPagerViewTransformer(type: .overlap)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @objc func goToFavorite(_ sender: UIButton) {
        guard let favoritesViewController = self.favoritesViewController else
        {
            return
        }
        favoritesViewController.animalName = "My Favorites"
        favoritesViewController.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(favoritesViewController, animated: true)
    }
    
    @objc func showMoreInfo(_ sender: UIButton) {
        switch sender.tag {
        case 101:
            changeAnimalInfoView(state: .isCollapsed)
        default:
            changeAnimalInfoView(state: .isExpanded)
        }
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        
        if sender.direction == UISwipeGestureRecognizer.Direction.up {
            changeAnimalInfoView(state: .isExpanded)
        } else if sender.direction == UISwipeGestureRecognizer.Direction.down {
            changeAnimalInfoView(state: .isCollapsed)
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        switch vwAnimalInfoViewState {
        case .isExpanded:
            changeAnimalInfoView(state: .isCollapsed)
        case .isCollapsed:
            changeAnimalInfoView(state: .isExpanded)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblAnimalLocations?.text = self.animalAreas.map { String($0) }.joined(separator: ",")
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellReuseIdentifier")
        tableView.backgroundColor = UIColor(hexString: "#EBEDCF")
        tableView.sectionHeaderTopPadding = 0.0
        tableView.bounces = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadAnimalData(index: 0)
        self.lblAnimalLocations?.text = self.animalAreas.map { String($0) }.joined(separator: ",")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK:- FSPagerViewDataSource
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return imageNames.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named: self.imageNames[index])
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        
        self.imgAnimal.image = UIImage(named: self.imageNames[index])
        self.imgShowMore.image = UIImage(named: iconNames[index])
        self.lblAnimalName.text = self.imageNames[index]
        
        if index != pagerView.currentIndex {
            loadAnimalData(index: index)
        }
        else {
            guard let photosViewController = self.photosViewController else
            {
                return
            }
            photosViewController.animalName = self.imageNames[index]
            photosViewController.navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(photosViewController, animated: true)
        }
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.imgAnimal.image = UIImage(named: self.imageNames[targetIndex])
        self.imgShowMore.image = UIImage(named: iconNames[targetIndex])
        self.lblAnimalName.text = self.imageNames[targetIndex]
        
        loadAnimalData(index: targetIndex)
    }
    
    func pagerView(_ pagerView: FSPagerView, didHighlightItemAt index: Int) {
        if let cell = pagerView.cellForItem(at: index) {
            cell.backgroundColor = UIColor.clear
        }
    }
    
    
    private func loadAnimalData(index: Int) {
        self.animalAreas.removeAll()
        
        APIHelper.fetchAnimalData(animalName: imageNames[index]) { (animals) in
            self.animalResults = animals
            
            for animal in self.animalResults {
                for area in animal.areas {
                    self.animalAreas.insert(area)
                }
            }
            print(self.animalAreas.map { String($0) }.joined(separator: ","))
            
            DispatchQueue.main.async{
                self.lblAnimalLocations?.text = self.animalAreas.map { String($0) }.joined(separator: ", ")
                self.tableView.reloadData()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func changeAnimalInfoView(state: AnimalInfoViewState) {
        self.vwAnimal.setNeedsUpdateConstraints()
        self.imgAnimal.setNeedsUpdateConstraints()
        self.lblAnimalName.setNeedsUpdateConstraints()
        
        switch state {
        case .isExpanded:
            vwAnimalInfoViewState = .isExpanded
            self.imgAnimal.alpha = 1.0
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                self.pagerView.alpha = 0.0
            }, completion: { (finished: Bool) in
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                    self.vwAnimalLeadingExpanded.priority = UILayoutPriority(rawValue: 1000)
                    self.vwAnimalTrailingExpanded.priority = UILayoutPriority(rawValue: 1000)
                    self.vwAnimalTopExpanded.priority = UILayoutPriority(rawValue: 1000)
                    self.vwShowMoreBottomExpanded.priority = UILayoutPriority(rawValue: 1000)
                    self.imgAnimalTopExpanded.priority = UILayoutPriority(rawValue: 1000)
                    self.imgAnimalHeightExpanded.priority = UILayoutPriority(rawValue: 1000)
                    self.lblAnimalNameTopExpanded.priority = UILayoutPriority(rawValue: 1000)
                    
                    self.vwAnimalLeadingOrigin.priority = UILayoutPriority(rawValue: 1)
                    self.vwAnimalTopOrigin.priority = UILayoutPriority(rawValue: 1)
                    self.vwAnimalTrailingOrigin.priority = UILayoutPriority(rawValue: 1)
                    self.vwShowMoreBottomOrigin.priority = UILayoutPriority(rawValue: 1)
                    self.imgAnimalTopOrigin.priority = UILayoutPriority(rawValue: 1)
                    self.imgAnimalHeightOrigin.priority = UILayoutPriority(rawValue: 1)
                    self.lblAnimalNameTopOrigin.priority = UILayoutPriority(rawValue: 1)
                    
                    self.vwAnimal.layoutIfNeeded()
                    self.imgAnimal.layoutIfNeeded()
                    self.lblAnimalName.layoutIfNeeded()
                    self.view.layoutIfNeeded()
                    
                    self.btnCloseInfo.alpha = 1.0
                    self.btnCloseInfo.isEnabled = true
                }, completion: { (finished: Bool) in
                    UIView.animate(withDuration: 0.3) {
                        self.tableView.alpha = 1.0
                    }
                })
            })
        case .isCollapsed:
            vwAnimalInfoViewState = .isCollapsed
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                
                self.vwAnimalLeadingExpanded.priority = UILayoutPriority(rawValue: 1)
                self.vwAnimalTrailingExpanded.priority = UILayoutPriority(rawValue: 1)
                self.vwAnimalTopExpanded.priority = UILayoutPriority(rawValue: 1)
                self.vwShowMoreBottomExpanded.priority = UILayoutPriority(rawValue: 1)
                self.imgAnimalTopExpanded.priority = UILayoutPriority(rawValue: 1)
                self.imgAnimalHeightExpanded.priority = UILayoutPriority(rawValue: 1)
                self.lblAnimalNameTopExpanded.priority = UILayoutPriority(rawValue: 1)
                
                
                self.vwAnimalLeadingOrigin.priority = UILayoutPriority(rawValue: 1000)
                self.vwAnimalTopOrigin.priority = UILayoutPriority(rawValue: 1000)
                self.vwAnimalTrailingOrigin.priority = UILayoutPriority(rawValue: 1000)
                self.vwShowMoreBottomOrigin.priority = UILayoutPriority(rawValue: 1000)
                self.imgAnimalTopOrigin.priority = UILayoutPriority(rawValue: 1000)
                self.imgAnimalHeightOrigin.priority = UILayoutPriority(rawValue: 1000)
                self.lblAnimalNameTopOrigin.priority = UILayoutPriority(rawValue: 1000)
                
                self.vwAnimal.layoutIfNeeded()
                self.imgAnimal.layoutIfNeeded()
                self.lblAnimalName.layoutIfNeeded()
                self.view.layoutIfNeeded()
                
                self.btnCloseInfo.alpha = 0.0
                self.tableView.alpha = 0.0
                self.btnCloseInfo.isEnabled = false
            }, completion: { (finished: Bool) in
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                    self.pagerView.alpha = 1.0
                }, completion: { (finished: Bool) in
                    UIView.animate(withDuration: 0.3) {
                        self.imgAnimal.alpha = 0.0
                    }
                })
            })
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let emptyStateView = UIView()
        emptyStateView.frame = CGRect(x: 0,
                                      y: 0,
                                      width: tableView.bounds.width,
                                      height: 0)
        emptyStateView.backgroundColor = UIColor(hexString: "#EBEDCF")

        let messageLabel = UILabel()
        messageLabel.text = "Known Species: "
        messageLabel.font = UIFont.init(name: "Futura-Medium", size: 15)
        messageLabel.textColor = .gray
        messageLabel.textColor = UIColor(hexString: "#D46438")
        messageLabel.textAlignment = .left
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        emptyStateView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: emptyStateView.topAnchor, constant: 5),
            messageLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor, constant: -5),
            messageLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: 0)
        ])
        
        return emptyStateView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animalResults.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellReuseIdentifier")
        
        cell.separatorInset = UIEdgeInsets.init(top: 1, left: 1, bottom: 1, right: 1)
        cell.backgroundColor = UIColor(hexString: "#EBEDCF")

        // Configure the cell with data
        cell.textLabel?.text = animalResults[indexPath.row].name
        cell.textLabel?.font = UIFont.init(name: "Futura-Medium", size: 14)
        cell.textLabel?.textColor = UIColor(hexString: "#173D1C")
        
        return cell
    }
}

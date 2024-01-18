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

class MainViewController: UIViewController,FSPagerViewDataSource,FSPagerViewDelegate {
    
    let imageNames = ["ELEPHANT", "LION", "FOX", "DOG", "SHARK", "TURTLE", "WHALE", "PENGUIN"]
    
    var animalResults: [Animal] = []
    var vwAnimalInfoViewState = AnimalInfoViewState.isCollapsed
    
    @IBOutlet weak var vwAnimalLeadingOrigin:NSLayoutConstraint!
    @IBOutlet weak var vwAnimalLeadingExpanded:NSLayoutConstraint!
    @IBOutlet weak var vwAnimalTrailingOrigin:NSLayoutConstraint!
    @IBOutlet weak var vwAnimalTrailingExpanded:NSLayoutConstraint!
    @IBOutlet weak var vwAnimalTopOrigin:NSLayoutConstraint!
    @IBOutlet weak var vwAnimalTopExpanded:NSLayoutConstraint!
    
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
            
            let tapView = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            swipeUp.direction = UISwipeGestureRecognizer.Direction.up
            swipeDown.direction = UISwipeGestureRecognizer.Direction.down
            vwAnimal.addGestureRecognizer(swipeUp)
            vwAnimal.addGestureRecognizer(swipeDown)
            vwAnimal.addGestureRecognizer(tapView)
        }
    }
    
    @IBOutlet weak var lblAnimalName: UILabel! {didSet {
        lblAnimalName.text = imageNames[0]
    }}
    @IBOutlet weak var imgAnimal: UIImageView! {
        didSet {
            self.imgAnimal.image = UIImage(named: imageNames[0])
            self.imgAnimal.alpha = 0.0
        }
    }
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            pagerView.isInfinite = true
            pagerView.itemSize = CGSize(width: 330, height: 375)
            pagerView.transformer = FSPagerViewTransformer(type: .overlap)
//            pagerView.interitemSpacing = -500
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
    
    override func viewDidLoad() {
        loadAnimalData(index: 0)
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
//        cell.backgroundColor = UIColor.init(hexString: "#033E55")
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        
        self.imgAnimal.image = UIImage(named: self.imageNames[index])
        self.lblAnimalName.text = self.imageNames[index]
        
        loadAnimalData(index: index)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.imgAnimal.image = UIImage(named: self.imageNames[targetIndex])
        self.lblAnimalName.text = self.imageNames[targetIndex]
        
        loadAnimalData(index: targetIndex)
    }
    
    private func loadAnimalData(index: Int) {
        APIHelper.fetchAnimalData(animalName: imageNames[index]) { (animals) in
            self.animalResults = animals
            print(self.animalResults[0])
        }
    }
    
    private func changeAnimalInfoView(state: AnimalInfoViewState) {
        self.vwAnimal.setNeedsUpdateConstraints()
        self.imgAnimal.setNeedsUpdateConstraints()
        self.lblAnimalName.setNeedsUpdateConstraints()
        
        switch state {
        case .isExpanded:
            vwAnimalInfoViewState = .isExpanded
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                
                
                self.imgAnimal.alpha = 1.0
                self.pagerView.alpha = 0.0
            }, completion: { (finished: Bool) in
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                    self.vwAnimalLeadingExpanded.priority = UILayoutPriority(rawValue: 1000)
                    self.vwAnimalTrailingExpanded.priority = UILayoutPriority(rawValue: 1000)
                    self.vwAnimalTopExpanded.priority = UILayoutPriority(rawValue: 1000)
                    self.imgAnimalTopExpanded.priority = UILayoutPriority(rawValue: 1000)
                    self.imgAnimalHeightExpanded.priority = UILayoutPriority(rawValue: 1000)
                    self.lblAnimalNameTopExpanded.priority = UILayoutPriority(rawValue: 1000)
                    
                    self.vwAnimalLeadingOrigin.priority = UILayoutPriority(rawValue: 1)
                    self.vwAnimalTopOrigin.priority = UILayoutPriority(rawValue: 1)
                    self.vwAnimalTrailingOrigin.priority = UILayoutPriority(rawValue: 1)
                    self.imgAnimalTopOrigin.priority = UILayoutPriority(rawValue: 1)
                    self.imgAnimalHeightOrigin.priority = UILayoutPriority(rawValue: 1)
                    self.lblAnimalNameTopOrigin.priority = UILayoutPriority(rawValue: 1)
                    
                    self.vwAnimal.layoutIfNeeded()
                    self.imgAnimal.layoutIfNeeded()
                    self.lblAnimalName.layoutIfNeeded()
                    self.view.layoutIfNeeded()
                })
            })
        case .isCollapsed:
            vwAnimalInfoViewState = .isCollapsed
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                
                self.vwAnimalLeadingExpanded.priority = UILayoutPriority(rawValue: 1)
                self.vwAnimalTrailingExpanded.priority = UILayoutPriority(rawValue: 1)
                self.vwAnimalTopExpanded.priority = UILayoutPriority(rawValue: 1)
                self.imgAnimalTopExpanded.priority = UILayoutPriority(rawValue: 1)
                self.imgAnimalHeightExpanded.priority = UILayoutPriority(rawValue: 1)
                self.lblAnimalNameTopExpanded.priority = UILayoutPriority(rawValue: 1)
                
                
                self.vwAnimalLeadingOrigin.priority = UILayoutPriority(rawValue: 1000)
                self.vwAnimalTopOrigin.priority = UILayoutPriority(rawValue: 1000)
                self.vwAnimalTrailingOrigin.priority = UILayoutPriority(rawValue: 1000)
                self.imgAnimalTopOrigin.priority = UILayoutPriority(rawValue: 1000)
                self.imgAnimalHeightOrigin.priority = UILayoutPriority(rawValue: 1000)
                self.lblAnimalNameTopOrigin.priority = UILayoutPriority(rawValue: 1000)
                
                self.vwAnimal.layoutIfNeeded()
                self.imgAnimal.layoutIfNeeded()
                self.lblAnimalName.layoutIfNeeded()
                self.view.layoutIfNeeded()
                
            }, completion: { (finished: Bool) in
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                    self.pagerView.alpha = 1.0
//                    self.imgAnimal.alpha = 0.0
                }, completion: { (finished: Bool) in
                    UIView.animate(withDuration: 0.3) {
                    }
                })
            })
        }
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

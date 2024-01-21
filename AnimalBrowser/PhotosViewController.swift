//
//  PhotosViewController.swift
//  AnimalBrowser
//
//  Created by Samuel Napitupulu on 19/01/24.
//

import Foundation
import UIKit
import SkeletonView
import SDWebImage
import SquareFlowLayout

class PhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let titleFontAttrs = [ NSAttributedString.Key.font: UIFont(name: "MantraRimba", size: 20)!, 
                           NSAttributedString.Key.foregroundColor: UIColor.white ]
    
    var flowLayout = SquareFlowLayout()
            
    
    var animalName: String = ""
    var nextPage: String = ""
    var photos: [AnimalPhoto] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var favoritesViewController : FavoritesViewController? =
    {
        let favoritesViewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavoritesViewController") as? FavoritesViewController
        return favoritesViewController
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationItem.setHidesBackButton(true, animated: false)
        
        self.title = self.animalName
        
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.photos.removeAll()
        self.collectionView.reloadData()
        self.view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.animalName
        flowLayout.flowDelegate = self
        
        let appearance = UINavigationBarAppearance()
        
        appearance.titleTextAttributes = titleFontAttrs
        appearance.largeTitleTextAttributes = titleFontAttrs
        
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.register(UINib(nibName:"PhotosCell", bundle: nil),
                                     forCellWithReuseIdentifier: "PhotosCell")
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("DATA IN SECTION \(self.photos.count)")
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell",
                                                      for: indexPath) as! PhotosCell
        cell.lblCount.text = "\(indexPath.row)"
        let cellPhoto = self.photos[indexPath.row].src
        
        let gradient = SkeletonGradient(baseColor: UIColor(hexString: "#EBEDCF"))
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .topLeftBottomRight)
        
        cell.imageView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.showSkeleton(transition: .crossDissolve(0.25))
        cell.imageView.sd_setImage(with: URL(string: cellPhoto.tiny)!,
                                   placeholderImage: UIImage(named: "ImageBroken"),
                                   completed: { [weak self] (image, error, cacheType, url) in
            guard self != nil else { return }
            if error != nil {
                // Set the image broken placeholder when error(s) occurs
                cell.imageView.image = UIImage(named: "ImageBroken")
                return
            }
            guard image != nil else {
                // Set the image broken placeholder when the download is failed
                cell.imageView.image = UIImage(named: "ImageBroken")
                return
            }
            
            cell.imageView.hideSkeleton(transition: .crossDissolve(0.5))
        })
        
        return cell
    }
    
    @objc func goToFavorite(_ sender: UIButton) {
        guard let favoritesViewController = self.favoritesViewController else
        {
            return
        }
        favoritesViewController.animalName = "My Favorites"
        favoritesViewController.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(favoritesViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedPhoto = self.photos[indexPath.row]
//        var customActionSheet : ToastView = {
//            
//        }()
//        customActionSheet.modalPresentationStyle = .overCurrentContext
//        present(customActionSheet, animated: true, completion: nil)
//        ToastView.shared.show(controller: self, message: "Photo added in Favorites", duration: 5.0)
        
//        if CoreDataHandler.shared.addFavorite(animal: self.animalName, withPhoto: selectedPhoto) {
//            let alertController = UIAlertController(title: "Translation Language", 
//                                                    message: nil,
//                                                    preferredStyle: .actionSheet)
//            
//            let toastLabel: UILabel = {
//                let label = UILabel()
//                label.text = "Photo added in Favorites"
//                label.textColor = UIColor(hexString: "#173D1C")
//                label.textAlignment = .center
//                label.font = UIFont.init(name: "Futura-Medium", size: 17)
//                label.numberOfLines = 0
//                return label
//            }()
//
//            let favoriteIcon: UIImageView = {
//                let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
//                imageView.tintColor = UIColor(hexString: "#D46438")
//                return imageView
//            }()
//
//            let showFavoritesButton: UIButton = {
//                let button = UIButton(type: .system)
//                button.setTitle("Show My Favorites", for: .normal)
//                button.setTitleColor(.white, for: .normal)
//                button.titleLabel?.font = UIFont.init(name: "Futura-Medium", size: 17)
//                button.backgroundColor = UIColor(hexString: "#173D1C")
//                button.layer.cornerRadius = 15.0
//        //        button.addTarget(ToastView.self, action: #selector(showFavoritesButtonTapped), for: .touchUpInside)
//                return button
//            }()
//            
//            alertController.view.addSubview(favoriteIcon)
//            alertController.view.addSubview(toastLabel)
//            alertController.view.addSubview(showFavoritesButton)
//            
//            favoriteIcon.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                favoriteIcon.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 20),
//                favoriteIcon.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor),
//                favoriteIcon.widthAnchor.constraint(equalToConstant: 44),
//                favoriteIcon.heightAnchor.constraint(equalToConstant: 40)
//            ])
//
//            toastLabel.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                toastLabel.topAnchor.constraint(equalTo: favoriteIcon.bottomAnchor, constant: 10),
//                toastLabel.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 15),
//                toastLabel.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor, constant: -15)
//            ])
//
//            showFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                showFavoritesButton.heightAnchor.constraint(equalToConstant: 40),
//                showFavoritesButton.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 20),
//                showFavoritesButton.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor, constant: -20),
//                showFavoritesButton.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -20)
//            ])

            
//            let customView = ToastView.shared.getView()
//            alertController.view.addSubview(customView)
//            
//            customView.translatesAutoresizingMaskIntoConstraints = false
//            alertController.view.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                alertController.view.heightAnchor.constraint(equalToConstant: 360),
//                
////                customView.widthAnchor.constraint(equalTo: alertController.view.widthAnchor),
////                customView.heightAnchor.constraint(equalToConstant: 180),
////                customView.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor),
//                customView.topAnchor.constraint(equalTo: alertController.view.topAnchor),
//                customView.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -790),
//                customView.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor),
//                customView.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor)
//            ])
//            
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            alertController.addAction(cancelAction)
//            
//            self.present(alertController, animated: true, completion: nil)
            
//            ToastView.shared.show(controller: self, message: "Photo added in Favorites", duration: 5.0)
        showCustomActionSheet()
        
//        }
//        else {
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.photos.count - 1 {
            loadData()
        }
    }
    
    func loadData() {
        if self.photos.isEmpty {
            APIHelper.fetchAnimalPhotos(animalName: self.animalName) { (queryResult) in
                self.nextPage = queryResult.next_page
                self.photos.append(contentsOf: queryResult.photos)
                
                DispatchQueue.main.async{
                    self.collectionView.reloadData()
                }
            }
        }
        else {
            APIHelper.fetchNextPage(nextPage: self.nextPage) { (queryResult) in
                self.photos.append(contentsOf: queryResult.photos)
                self.nextPage = queryResult.next_page
                
                DispatchQueue.main.async{
                    self.collectionView.reloadData()
                }
            }
        }
    }
    func showCustomActionSheet() {
            let customActionSheet = CustomActionSheetViewController()
        customActionSheet.modalPresentationStyle = .automatic
            present(customActionSheet, animated: true, completion: nil)
        }
}

extension PhotosViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, 
                                cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "PhotosCell"
    }
}

extension PhotosViewController: SquareFlowLayoutDelegate {
    func shouldExpandItem(at indexPath: IndexPath) -> Bool {
        return (indexPath.row % 6) == 0
    }
}

class CustomActionSheetViewController: UIViewController {

    private let toastFrame: UIView = {
       let toastFrame = UIView()
        
        toastFrame.layer.cornerRadius = 25
        toastFrame.backgroundColor = UIColor(hexString: "#EBEDCF")
        
        toastFrame.layer.borderWidth = 0.5
        toastFrame.layer.borderColor = UIColor(hexString: "#FFE8D6").cgColor
        
        toastFrame.layer.shadowColor = UIColor.black.cgColor
        toastFrame.layer.shadowOffset = CGSize(width: 0, height: 0)
        toastFrame.layer.shadowOpacity = 0.4
        toastFrame.layer.shadowRadius = 8
        return toastFrame
    }()
    
    private let toastLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#173D1C")
        label.textAlignment = .center
        label.font = UIFont.init(name: "Futura-Medium", size: 17)
        label.numberOfLines = 0
        return label
    }()

    private let favoriteIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = UIColor(hexString: "#D46438")
        return imageView
    }()

    var showFavoritesButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Show My Favorites", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Futura-Medium", size: 17)
        button.backgroundColor = UIColor(hexString: "#173D1C")
        button.layer.cornerRadius = 15.0
        button.addTarget(self, action: #selector(showFavoritesButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureActionSheetView()
    }

    private func configureActionSheetView() {
        view.addSubview(toastFrame)
        toastFrame.addSubview(favoriteIcon)
        toastFrame.addSubview(toastLabel)
        toastFrame.addSubview(showFavoritesButton)
        
        toastFrame.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastFrame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            toastFrame.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            toastFrame.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            toastFrame.heightAnchor.constraint(equalToConstant: 180),
        ])

        favoriteIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoriteIcon.topAnchor.constraint(equalTo: toastFrame.topAnchor, constant: 20),
            favoriteIcon.centerXAnchor.constraint(equalTo: toastFrame.centerXAnchor),
            favoriteIcon.widthAnchor.constraint(equalToConstant: 44),
            favoriteIcon.heightAnchor.constraint(equalToConstant: 40)
        ])

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastLabel.topAnchor.constraint(equalTo: favoriteIcon.bottomAnchor, constant: 10),
            toastLabel.leadingAnchor.constraint(equalTo: toastFrame.leadingAnchor, constant: 15),
            toastLabel.trailingAnchor.constraint(equalTo: toastFrame.trailingAnchor, constant: -15)
        ])

        showFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showFavoritesButton.heightAnchor.constraint(equalToConstant: 40),
            showFavoritesButton.leadingAnchor.constraint(equalTo: toastFrame.leadingAnchor, constant: 20),
            showFavoritesButton.trailingAnchor.constraint(equalTo: toastFrame.trailingAnchor, constant: -20),
            showFavoritesButton.bottomAnchor.constraint(equalTo: toastFrame.bottomAnchor, constant: -20)
        ])

//        self.isUserInteractionEnabled = true
//        showFavoritesButton.isUserInteractionEnabled = true
        view.clipsToBounds = true
//        view.alpha = 0
    }

    @objc func showFavoritesButtonTapped() {
        // Handle button tap as needed
        print("Show My Favorites button tapped!")
        dismiss(animated: true, completion: nil)
    }
}

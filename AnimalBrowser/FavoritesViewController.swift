//
//  FavoritesViewController.swift
//  AnimalBrowser
//
//  Created by Samuel Napitupulu on 19/01/24.
//

import Foundation
import UIKit
import SkeletonView
import SDWebImage

class FavoritesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let iconNames = ["ic_elephant", "ic_lion", "ic_fox", "ic_dog", "ic_shark", "ic_turtle", "ic_whale", "ic_penguin"]
    let imageNames = ["ELEPHANT", "LION", "FOX", "DOG", "SHARK", "TURTLE", "WHALE", "PENGUIN"]
    
    let titleFontAttrs = [ NSAttributedString.Key.font: UIFont(name: "MantraRimba", size: 20)!,
                           NSAttributedString.Key.foregroundColor: UIColor.white ]
    
    var toastActionSheet: ToastView = {
        var toastActionSheet = ToastView()
        toastActionSheet.toastViewStyle = .favorite
        return toastActionSheet
    }()
    
    var emptyStateView: UIView = {
        var emptyStateView = UIView()
        emptyStateView.frame = CGRect(x: 0,
                                      y: 0,
                                      width: UIScreen.main.bounds.width,
                                      height: UIScreen.main.bounds.height)
        emptyStateView.backgroundColor = UIColor(hexString: "#EBEDCF")

        let messageLabel = UILabel()
        messageLabel.text = "No items to display"
        messageLabel.font = UIFont.init(name: "Futura-Medium", size: 17)
        messageLabel.textColor = .gray
        messageLabel.textColor = UIColor(hexString: "#D46438")
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        emptyStateView.addSubview(messageLabel)

        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor)
        ])
        
        return emptyStateView
    }()
    
    var animalName: String = ""
    var nextPage: String = ""
    var photos: [LikedPhotos] = []
    var selectedPhotoIndex: Int = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationItem.setHidesBackButton(true, animated: false)
        
        self.title = self.animalName
        
        self.collectionView.collectionViewLayout = SavedCollectionViewLayout()
        self.collectionView.register(UINib(nibName:"PhotosCell", bundle: nil),
                                     forCellWithReuseIdentifier: "PhotosCell")
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.photos = CoreDataHandler.shared.retrieve()
        
        if !self.photos.isEmpty {
            self.collectionView.reloadData()
            self.collectionView.setNeedsLayout()
            self.collectionView.layoutIfNeeded()
                
            showEmptyStateView(isVisible: false)
        }
        else {
            showEmptyStateView(isVisible: true)
        }
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
        
        let appearance = UINavigationBarAppearance()
        
        appearance.titleTextAttributes = titleFontAttrs
        appearance.largeTitleTextAttributes = titleFontAttrs
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
                                          style: .plain,
                                          target: self,
                                          action: nil)
        
        var idx = -1
        filterButton.menu = UIMenu(children: imageNames.map({ image in
            idx = idx + 1
            var actionBtn = UIAction(title: image,
                                     image: UIImage(named: iconNames[idx]),
                                     handler: { [weak self] _ in
                print(image)
                self!.filterPhotosByName(animalName: image)
            })
            return actionBtn
        }))

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = filterButton;
        
        self.view.addSubview(emptyStateView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("DATA IN SECTION \(self.photos.count)")
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell",
                                                      for: indexPath) as! PhotosCell
        
        let cellPhoto = self.photos[indexPath.row].thumbnail
        
        let gradient = SkeletonGradient(baseColor: UIColor(hexString: "#EBEDCF"))
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .topLeftBottomRight)
        
        cell.imageView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.showSkeleton(transition: .crossDissolve(0.25))
        cell.imageView.sd_setImage(with: URL(string: cellPhoto!)!,
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPhotoIndex = indexPath.row
        let selectedPhoto = self.photos[selectedPhotoIndex]
        let iconName =  "ic_\((selectedPhoto.animal_name ?? "").lowercased())"
        
        toastActionSheet.toastTitle.text = "\(selectedPhoto.animal_name ?? "")\n\(selectedPhoto.alt ?? "")"
        toastActionSheet.toastTitle.textAlignment = .center
        toastActionSheet.favoriteIcon.image = UIImage(named: iconName)
        toastActionSheet.favoriteIcon.contentMode = .scaleAspectFit
        toastActionSheet.toastImage.sd_setImage(with: URL(string: selectedPhoto.original_photo!)!,
                                                placeholderImage: UIImage(named: "ImageBroken"))
        toastActionSheet.toastImage.tag = 102
        if selectedPhoto.height > selectedPhoto.width {
            toastActionSheet.toastImage.tag = 101
        }
        let photographerName = "Photo by: \(selectedPhoto.photographer ?? "")"
        let attributedString = NSMutableAttributedString(string: photographerName)
        attributedString.addAttribute(.font,
                                      value: UIFont.init(name: "Futura-Medium", size: 12)!,
                                      range: NSRange(location: 0,
                                                     length: photographerName.count))
        attributedString.addAttribute(.foregroundColor, value: UIColor.white,
                                      range: NSRange(location: 0,
                                                     length: photographerName.count))
        toastActionSheet.photographerLabel.setAttributedTitle(attributedString, for: .normal)
        
        toastActionSheet.changeAddFavoriteButtonState(state: .favorited)
        toastActionSheet.addFavoritesButton.addTarget(self,
                                                      action: #selector(addToFavorite(_:)),
                                                      for: .touchUpInside)
        toastActionSheet.urlButton.addTarget(self,
                                             action: #selector(openOriginalPhoto(_:)),
                                             for: .touchUpInside)
        
        toastActionSheet.modalPresentationStyle = .automatic
        present(toastActionSheet, animated: true, completion: nil)
    }
    
    @objc func addToFavorite(_ sender: UIButton) {
        let selectedPhoto = self.photos[selectedPhotoIndex]
        
        switch sender.tag {
            // Remove Photo from Favorite List
        case FavoriteButtonState.favorited.rawValue:
            if CoreDataHandler.shared.deleteFavorite(photo: selectedPhoto) {
                toastActionSheet.changeAddFavoriteButtonState(state: .unfavorited)
                self.photos.remove(at: selectedPhotoIndex)
            }
            break
            
        default: break
        }
        
        self.collectionView.reloadData()
        toastActionSheet.dismiss(animated: true)
    }
    
    @objc func openOriginalPhoto(_ sender: UIButton) {
        let selectedPhoto = self.photos[selectedPhotoIndex]
        if let url = URL(string: selectedPhoto.url!) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func filterPhotosByName(animalName: String) {
        self.photos.removeAll()
        self.photos = CoreDataHandler.shared.retrieve(filterByName: animalName)
        self.collectionView.reloadData()
        
        if !self.photos.isEmpty {
            self.collectionView.reloadData()
            self.collectionView.setNeedsLayout()
            self.collectionView.layoutIfNeeded()
            
            showEmptyStateView(isVisible: false)
        }
        else {
            showEmptyStateView(isVisible: true)
        }
    }
    
    // Function to show the empty state view
    func showEmptyStateView(isVisible: Bool) {
        emptyStateView.isHidden = !isVisible
        emptyStateView.isUserInteractionEnabled = false
        if isVisible { emptyStateView.alpha = 1.0 }
        else {emptyStateView.alpha = 0.0}
    }
}

extension FavoritesViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "PhotosCell"
    }
}

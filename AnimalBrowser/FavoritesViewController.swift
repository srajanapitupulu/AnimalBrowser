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
    
    let titleFontAttrs = [ NSAttributedString.Key.font: UIFont(name: "MantraRimba", size: 20)!,
                           NSAttributedString.Key.foregroundColor: UIColor.white ]
        
    var animalName: String = ""
    var nextPage: String = ""
    var photos: [LikedPhotos] = []
    
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
        
        self.collectionView.reloadData()
        self.collectionView.setNeedsLayout()
        self.collectionView.layoutIfNeeded()
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
        
        self.navigationController!.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("DATA IN SECTION \(self.photos.count)")
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell",
                                                      for: indexPath) as! PhotosCell
        cell.lblCount.text = "\(indexPath.row)"
        
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
        let selectedPhoto = self.photos[indexPath.row]
    }
}

extension FavoritesViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "PhotosCell"
    }
}

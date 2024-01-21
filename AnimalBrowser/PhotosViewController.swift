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

class PhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let titleFontAttrs = [ NSAttributedString.Key.font: UIFont(name: "MantraRimba", size: 20)!, 
                           NSAttributedString.Key.foregroundColor: UIColor.white ]
        
    var animalName: String = ""
    var nextPage: String = ""
    var photos: [AnimalPhoto] = []
    
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
//        self.collectionView.prefetchDataSource = self
        
        APIHelper.fetchAnimalPhotos(animalName: self.animalName) { (queryResult) in
            self.nextPage = queryResult.next_page
            self.photos.append(contentsOf: queryResult.photos)
            
            DispatchQueue.main.async{
                self.collectionView.reloadData()
//                self.collectionView.collectionViewLayout.invalidateLayout()
//                self.collectionView.collectionViewLayout = SavedCollectionViewLayout()
//                self.collectionView.layoutSubviews()
                self.collectionView.setNeedsLayout()
                self.collectionView.layoutIfNeeded()
//                self.view.layoutIfNeeded()
            }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = self.photos[indexPath.row]
        
        if CoreDataHandler.shared.addFavorite(animal: self.animalName, withPhoto: selectedPhoto) {
            let alert = UIAlertController(title: "Alert Title", message: "Alert Message", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
                print(CoreDataHandler.shared.retrieveAll())
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Alert Title", message: "Alert Message", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row > (self.photos.count - 6) {
            APIHelper.fetchNextPage(nextPage: self.nextPage) { (queryResult) in
                self.photos.append(contentsOf: queryResult.photos)
                
//                DispatchQueue.main.async{
//                    print("PHOTO COUNT \(self.photos.count)")
//                    self.collectionView.reloadData()
//                    self.collectionView.reloadSections(IndexSet(integer: indexPath.section))
////                    self.collectionView.collectionViewLayout.invalidateLayout()
////                    self.collectionView.collectionViewLayout = SavedCollectionViewLayout()
////                    self.collectionView.layoutSubviews()
////                    self.view.layoutIfNeeded()
//                    
//                    self.collectionView.setNeedsLayout()
//                    self.collectionView.layoutIfNeeded()
//                }
            }
        }
    }
}

extension PhotosViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, 
                                cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "PhotosCell"
    }
}

//extension PhotosViewController: UICollectionViewDataSourcePrefetching {
//  func collectionView(_ collectionView: UICollectionView,
//                      prefetchItemsAt indexPaths: [IndexPath]) {
//    print("Prefetch: \(indexPaths)")
//  }
//}

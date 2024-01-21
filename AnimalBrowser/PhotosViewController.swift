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
    
    var toastActionSheet = ToastView()
    
    var goingForward: Bool = false
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
        goingForward = false
        
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !goingForward {
            self.animalName = ""
            self.nextPage = ""
            self.photos.removeAll()
            self.collectionView.reloadData()
            self.view.layoutIfNeeded()
        }
        
        navigationController?.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.animalName
        flowLayout.flowDelegate = self
        
        let appearance = UINavigationBarAppearance()
        
        appearance.titleTextAttributes = titleFontAttrs
        appearance.largeTitleTextAttributes = titleFontAttrs
        
        self.navigationController!.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.register(UINib(nibName:"PhotosCell", bundle: nil),
                                     forCellWithReuseIdentifier: "PhotosCell")
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell",
                                                      for: indexPath) as! PhotosCell

        let cellData = self.photos[indexPath.row]
        let cellPhoto = cellData.src
        
        cell.imageFavorite.isHidden = !cellData.liked
        
        cell.imageView.contentMode = .scaleAspectFill
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
        toastActionSheet.dismiss(animated: true, completion: nil)
        guard let favoritesViewController = self.favoritesViewController else
        {
            return
        }
        favoritesViewController.animalName = "My Favorites"
        favoritesViewController.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(favoritesViewController, animated: true)
        self.title = ""
        self.goingForward = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = self.photos[indexPath.row]
        
        if CoreDataHandler.shared.addFavorite(animal: self.animalName, withPhoto: selectedPhoto) {
            
            toastActionSheet.toastImage.sd_setImage(with: URL(string: selectedPhoto.src.original)!,
                                                    placeholderImage: UIImage(named: "ImageBroken"))
            toastActionSheet.toastImage.tag = 102
            if selectedPhoto.height > selectedPhoto.width {
                toastActionSheet.toastImage.tag = 101
            }
            
            toastActionSheet.toastLabel.text = selectedPhoto.alt
            toastActionSheet.showFavoritesButton.addTarget(self,
                                                           action: #selector(goToFavorite(_:)),
                                                           for: .touchUpInside)
            toastActionSheet.modalPresentationStyle = .automatic
            present(toastActionSheet, animated: true, completion: nil)
        }
        else {
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.photos.count - 1 {
            loadData()
        }
    }
    
    func loadData() {
        APIHelper.fetchAnimalPhotos(animalName: self.animalName, nextPage: self.nextPage) { (queryResult) in
            self.photos.append(contentsOf: queryResult.photos)
            self.nextPage = queryResult.next_page
            
            DispatchQueue.main.async{
                self.collectionView.reloadData()
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

extension PhotosViewController: SquareFlowLayoutDelegate {
    func shouldExpandItem(at indexPath: IndexPath) -> Bool {
        return (indexPath.row % 6) == 0
    }
}

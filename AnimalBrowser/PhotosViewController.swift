//
//  PhotosViewController.swift
//  AnimalBrowser
//
//  Created by Samuel Napitupulu on 19/01/24.
//

import Foundation
import UIKit

class PhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let titleFontAttrs = [ NSAttributedString.Key.font: UIFont(name: "MantraRimba", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.white ]
        
    var animalName: String = ""
    var photos: [AnimalPhoto] = []
    
    @IBOutlet weak var collectionView: UICollectionView! 
    {
        didSet {
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationItem.setHidesBackButton(true, animated: false)
        
        self.title = self.animalName
        
        self.collectionView.collectionViewLayout = SavedCollectionViewLayout()
        self.collectionView.register(UINib(nibName:"PhotosCell", bundle: nil),
                                     forCellWithReuseIdentifier: "PhotosCell")
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        APIHelper.fetchAnimalPhotos(animalName: self.animalName) { (queryResult) in
            self.photos.append(contentsOf: queryResult.photos)
            
            DispatchQueue.main.async{
                self.collectionView.reloadData()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.animalName
        
        let appearance = UINavigationBarAppearance()
        
        appearance.titleTextAttributes = titleFontAttrs
        appearance.largeTitleTextAttributes = titleFontAttrs
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellPhoto = self.photos[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as! PhotosCell
        
        return cell
    }
    
}

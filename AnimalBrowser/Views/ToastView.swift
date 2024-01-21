//
//  ToastView.swift
//  AnimalBrowser
//
//  Created by Samuel Napitupulu on 21/01/24.
//

import UIKit

enum ViewStyle {
    case error
    case success
    case popup
}

class ToastView: UIViewController {
    
    private var imageHeight = 0.0
    
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
    
    private let favoriteIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = UIColor(hexString: "#D46438")
        return imageView
    }()
    
    var toastTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#173D1C")
        label.textAlignment = .center
        label.font = UIFont.init(name: "Futura-Medium", size: 17)
        label.numberOfLines = 0
        return label
    }()
    
    var toastImage: UIImageView = {
       let toastImage = UIImageView()
        toastImage.contentMode = .scaleAspectFit
        return toastImage
    }()
    
    var toastLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#173D1C")
        label.textAlignment = .center
        label.font = UIFont.init(name: "Futura-Medium", size: 17)
        label.numberOfLines = 0
        return label
    }()


    var showFavoritesButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Show My Favorites", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Futura-Medium", size: 17)
        button.backgroundColor = UIColor(hexString: "#173D1C")
        button.layer.cornerRadius = 15.0
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureActionSheetView()
    }

    private func configureActionSheetView() {
        view.addSubview(toastFrame)
        toastFrame.addSubview(favoriteIcon)
        toastFrame.addSubview(toastImage)
        toastFrame.addSubview(toastLabel)
        toastFrame.addSubview(showFavoritesButton)
        
        if toastImage.tag == 101 {
            print("PORTRAIT")
            imageHeight = 350
        }
        else {
            print("LANDSCAPE")
            imageHeight = 250
        }
        
        toastFrame.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastFrame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            toastFrame.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            toastFrame.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            toastFrame.heightAnchor.constraint(equalToConstant: 180 + imageHeight),
        ])

        favoriteIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoriteIcon.topAnchor.constraint(equalTo: toastFrame.topAnchor, constant: 20),
            favoriteIcon.centerXAnchor.constraint(equalTo: toastFrame.centerXAnchor),
            favoriteIcon.widthAnchor.constraint(equalToConstant: 44),
            favoriteIcon.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        toastImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastImage.topAnchor.constraint(equalTo: favoriteIcon.bottomAnchor, constant: 10),
            toastImage.leadingAnchor.constraint(equalTo: toastFrame.leadingAnchor, constant: 15),
            toastImage.trailingAnchor.constraint(equalTo: toastFrame.trailingAnchor, constant: -15),
            toastImage.heightAnchor.constraint(equalToConstant: imageHeight)
        ])

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastLabel.topAnchor.constraint(equalTo: toastImage.bottomAnchor, constant: 10),
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

        let tapView = UITapGestureRecognizer(target: self, action: #selector(showFavoritesButtonTapped(_:)))
        view.addGestureRecognizer(tapView)
        view.clipsToBounds = true
    }

    @objc func showFavoritesButtonTapped(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

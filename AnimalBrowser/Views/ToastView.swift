//
//  ToastView.swift
//  AnimalBrowser
//
//  Created by Samuel Napitupulu on 21/01/24.
//

import UIKit

enum ViewStyle: Int {
    case browser
    case favorite
}

enum FavoriteButtonState: Int {
    case favorited
    case unfavorited
}

class ToastView: UIViewController {
    
    private var imageHeight = 0.0
    var toastViewStyle = ViewStyle.browser
    
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
    
    var favoriteIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = UIColor(hexString: "#D46438")
        return imageView
    }()
    
    var toastTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#173D1C")
        label.textAlignment = .center
        label.font = UIFont.init(name: "Futura-Medium", size: 15)
        label.numberOfLines = 0
        return label
    }()
    
    var toastImage: UIImageView = {
       let toastImage = UIImageView()
        toastImage.contentMode = .scaleAspectFill
        toastImage.layer.borderWidth = 1.0
        toastImage.layer.borderColor = UIColor(hexString: "#436904").cgColor
        toastImage.layer.cornerRadius = 5.0
        toastImage.clipsToBounds = true
        return toastImage
    }()
    
    var photographerLabel: UIButton = {
        let label = UIButton(type: .system)
        
        let attributedString = NSMutableAttributedString(string: "Bold and Red Text")

        // Apply attributes to parts of the string
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18), range: NSRange(location: 0, length: 4))
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: 9, length: 3))
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        config.attributedTitle = AttributedString(attributedString)
        label.configuration = config
        
        label.backgroundColor = UIColor(hexString: "#173D1C")
        label.contentHorizontalAlignment = .right
        label.isUserInteractionEnabled = false
        label.layer.cornerRadius = 5.0
        return label
    }()
    var urlButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor(hexString: "#173D1C"), for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Futura-Medium", size: 13)
        button.setTitle("show original photo", for: .normal)
        button.contentHorizontalAlignment = .center
        return button
    }()

    var addFavoritesButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tag = FavoriteButtonState.unfavorited.rawValue
        button.setTitle("Add To My Favorites", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Futura-Medium", size: 17)
        button.backgroundColor = UIColor(hexString: "#D46438")
        button.layer.cornerRadius = 15.0
        return button
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

    func changeAddFavoriteButtonState(state: FavoriteButtonState) {
        
        addFavoritesButton.tag = state.rawValue
        
        switch state {
        case .favorited:
            addFavoritesButton.setTitle("Remove From My Favorites", for: .normal)
            addFavoritesButton.setTitleColor(UIColor(hexString: "#D46438"), for: .normal)
            addFavoritesButton.titleLabel?.font = UIFont.init(name: "Futura-Medium", size: 17)
            addFavoritesButton.backgroundColor = UIColor(hexString: "#EBEDCF")
            addFavoritesButton.layer.borderColor = UIColor(hexString: "#D46438").cgColor
            addFavoritesButton.layer.borderWidth = 2.0
            addFavoritesButton.layer.cornerRadius = 15.0
        default:
            addFavoritesButton.setTitle("Add To My Favorites", for: .normal)
            addFavoritesButton.setTitleColor(.white, for: .normal)
            addFavoritesButton.titleLabel?.font = UIFont.init(name: "Futura-Medium", size: 17)
            addFavoritesButton.backgroundColor = UIColor(hexString: "#D46438")
            addFavoritesButton.layer.borderWidth = 0.0
            addFavoritesButton.layer.cornerRadius = 15.0
        }
    }
    
    private func configureActionSheetView() {
        view.addSubview(toastFrame)
        if self.toastViewStyle == .favorite  {
            toastFrame.addSubview(favoriteIcon)
        }
        toastFrame.addSubview(toastTitle)
        toastFrame.addSubview(toastImage)
        toastFrame.addSubview(photographerLabel)
        toastFrame.addSubview(urlButton)
        toastFrame.addSubview(addFavoritesButton)
        
        if self.toastViewStyle == .browser {
            toastFrame.addSubview(showFavoritesButton)
        }
        
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
            toastFrame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            toastFrame.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            toastFrame.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])

        
        if self.toastViewStyle == .favorite  {
            favoriteIcon.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                favoriteIcon.topAnchor.constraint(equalTo: toastFrame.topAnchor, constant: 20),
                favoriteIcon.centerXAnchor.constraint(equalTo: toastFrame.centerXAnchor),
                favoriteIcon.widthAnchor.constraint(equalToConstant: 44),
                favoriteIcon.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            toastTitle.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                toastTitle.topAnchor.constraint(equalTo: favoriteIcon.bottomAnchor, constant: 10),
                toastTitle.leadingAnchor.constraint(equalTo: toastFrame.leadingAnchor, constant: 15),
                toastTitle.trailingAnchor.constraint(equalTo: toastFrame.trailingAnchor, constant: -15)
            ])
        }
        else if self.toastViewStyle == .browser {
            toastTitle.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                toastTitle.topAnchor.constraint(equalTo: toastFrame.topAnchor, constant: 20),
                toastTitle.leadingAnchor.constraint(equalTo: toastFrame.leadingAnchor, constant: 15),
                toastTitle.trailingAnchor.constraint(equalTo: toastFrame.trailingAnchor, constant: -15)
            ])
        }
        
        toastImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastImage.topAnchor.constraint(equalTo: toastTitle.bottomAnchor, constant: 10),
            toastImage.leadingAnchor.constraint(equalTo: toastFrame.leadingAnchor, constant: 15),
            toastImage.trailingAnchor.constraint(equalTo: toastFrame.trailingAnchor, constant: -15),
            toastImage.heightAnchor.constraint(equalToConstant: imageHeight)
        ])

        photographerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photographerLabel.topAnchor.constraint(equalTo: toastImage.bottomAnchor, constant: -7),
            photographerLabel.leadingAnchor.constraint(equalTo: toastFrame.leadingAnchor, constant: 15),
            photographerLabel.trailingAnchor.constraint(equalTo: toastFrame.trailingAnchor, constant: -15)
        ])
        
        urlButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            urlButton.topAnchor.constraint(equalTo: photographerLabel.bottomAnchor, constant: 5),
            urlButton.leadingAnchor.constraint(equalTo: toastFrame.leadingAnchor, constant: 15),
            urlButton.trailingAnchor.constraint(equalTo: toastFrame.trailingAnchor, constant: -15)
        ])

        if self.toastViewStyle == .favorite  {
            addFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                addFavoritesButton.topAnchor.constraint(equalTo: urlButton.bottomAnchor, constant: 10),
                addFavoritesButton.heightAnchor.constraint(equalToConstant: 40),
                addFavoritesButton.leadingAnchor.constraint(equalTo: toastFrame.leadingAnchor, constant: 20),
                addFavoritesButton.trailingAnchor.constraint(equalTo: toastFrame.trailingAnchor, constant: -20),
                addFavoritesButton.bottomAnchor.constraint(equalTo: toastFrame.bottomAnchor, constant: -50)
            ])
            
        }
        else if self.toastViewStyle == .browser  {
            addFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                addFavoritesButton.topAnchor.constraint(equalTo: urlButton.bottomAnchor, constant: 10),
                addFavoritesButton.heightAnchor.constraint(equalToConstant: 40),
                addFavoritesButton.leadingAnchor.constraint(equalTo: toastFrame.leadingAnchor, constant: 20),
                addFavoritesButton.trailingAnchor.constraint(equalTo: toastFrame.trailingAnchor, constant: -20),
            ])
            
            showFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                showFavoritesButton.heightAnchor.constraint(equalToConstant: 40),
                showFavoritesButton.topAnchor.constraint(equalTo: addFavoritesButton.bottomAnchor, constant: 10),
                showFavoritesButton.leadingAnchor.constraint(equalTo: toastFrame.leadingAnchor, constant: 20),
                showFavoritesButton.trailingAnchor.constraint(equalTo: toastFrame.trailingAnchor, constant: -20),
                showFavoritesButton.bottomAnchor.constraint(equalTo: toastFrame.bottomAnchor, constant: -50)
            ])
        }

        let tapView = UITapGestureRecognizer(target: self, action: #selector(showFavoritesButtonTapped(_:)))
        view.addGestureRecognizer(tapView)
        view.clipsToBounds = true
    }

    @objc func showFavoritesButtonTapped(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

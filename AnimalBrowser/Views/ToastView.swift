//
//  ToastView.swift
//  AnimalBrowser
//
//  Created by Samuel Napitupulu on 21/01/24.
//

import UIKit
import UIKit

class ToastView: UIView {
    static let shared = ToastView()

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
        button.addTarget(ToastView.self, action: #selector(showFavoritesButtonTapped), for: .touchUpInside)
        return button
    }()

    private init() {
        super.init(frame: CGRect.zero)
        configureToastView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureToastView() {
        self.addSubview(toastFrame)
        toastFrame.addSubview(favoriteIcon)
        toastFrame.addSubview(toastLabel)
        toastFrame.addSubview(showFavoritesButton)
        
        toastFrame.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastFrame.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            toastFrame.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            toastFrame.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
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

        self.isUserInteractionEnabled = true
        showFavoritesButton.isUserInteractionEnabled = true
        self.clipsToBounds = true
        self.alpha = 0
    }

    @objc private func showFavoritesButtonTapped() {
        // Handle button tap as needed
        print("Show My Favorites button tapped!")
    }
    
    func getView() -> UIView {
        return self.toastFrame
    }

    func show(controller: UIViewController,
              message: String,
              duration: TimeInterval = 2.0) {
        toastLabel.text = message

        self.frame = CGRect(x: 0,
                            y: 0,
                            width: controller.view.frame.size.width,
                            height: controller.view.frame.size.height)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 5
        
        controller.view.addSubview(self)

        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: {
                self.alpha = 0.0
            }, completion: { _ in
                self.removeFromSuperview()
            })
        }
    }
}


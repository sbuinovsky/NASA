//
//  PictureOfEPICDetailedViewController.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 09.12.2021.
//

import UIKit

class EPICDetailedViewController: UIViewController {
    
    var object: PictureOfEPIC!
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        photoImageView.clipsToBounds = true
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.layer.cornerRadius = 10
        return photoImageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.preferredMaxLayoutWidth = view.frame.width - 40
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    
        view.addSubview(scrollView)
        addScrollViewSubviews(photoImageView, descriptionLabel)
        setConstraints()
        
        title = object.date
        let imagePath = NetworkManager.shared.generateEPICImageURLPath(for: object)
        NetworkManager.shared.fetchImage(for: imagePath) { [weak self] image in
            self?.photoImageView.image = image
        }
        photoImageView.animate(animation: .opacity, withDuration: 0.5, repeatCount: 0)
        
        descriptionLabel.text = object.description
    }
    
    private func addScrollViewSubviews(_ views:UIView...) {
        for view in views {
            scrollView.addSubview(view)
        }
    }
    
    private func setConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            photoImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            photoImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            photoImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: 1)
        ])
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ])
    }

}

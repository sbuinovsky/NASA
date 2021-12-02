//
//  EPICCell.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 22.11.2021.
//

import UIKit

class EPICCell: UITableViewCell {

    var photoImageView = UIImageView()
    var dateLabel = UILabel()
    var activityIndicator = UIActivityIndicatorView()
    
    func configure(with picture: PictureOfEPIC) {
        self.addSubview(photoImageView)
        self.addSubview(dateLabel)
        photoImageView.addSubview(activityIndicator)
        
        configureImages(with: picture)
        configureLabels(with: picture)
        configureActivityIndicator()
        setConstraints()
    }
    
    private func configureImages(with picture: PictureOfEPIC) {
        photoImageView.clipsToBounds = true
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.image = UIImage(named: picture.image)
        photoImageView.layer.cornerRadius = 10
        photoImageView.animate(animation: .opacity, withDuration: 0.7, repeatCount: 0)
        
        let imagePath = ImageManager.shared.generateEPICImageURLPath(for: picture)
        
        ImageManager.shared.fetchImage(for: imagePath) { [weak self] data in
            self?.photoImageView.image = UIImage(data: data)
            self?.activityIndicator.stopAnimating()
            self?.photoImageView.animate(animation: .opacity, withDuration: 0.7, repeatCount: 0)
            self?.photoImageView.layer.opacity = 1
        }
 
    }
    
    private func configureLabels(with picture: PictureOfEPIC) {
        dateLabel.text = picture.date
        dateLabel.textColor = .white
    }
    
    private func configureActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
    }
    
    private func setConstraints() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let photoImageViewConstraints = [
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 60),
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: 1),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ]
        
        let activityIndicatorConstraints = [
            activityIndicator.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor)
        ]
        
        let dateLabelConstraints = [
            dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(photoImageViewConstraints)
        NSLayoutConstraint.activate(activityIndicatorConstraints)
        NSLayoutConstraint.activate(dateLabelConstraints)
    }
}

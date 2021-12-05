//
//  EPICCell.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 22.11.2021.
//

import UIKit
import AlamofireImage

class EPICCell: UITableViewCell {

    var photoImageView = UIImageView()
    var dateLabel = UILabel()
    var activityIndicator = UIActivityIndicatorView()
    
    func configure(with picture: PictureOfEPIC) {
        self.addSubview(activityIndicator)
        self.addSubview(photoImageView)
        self.addSubview(dateLabel)

        configureActivityIndicator()
        configureLabels(with: picture)
        configureImages(with: picture)
        setConstraints()
    }
    
    private func configureImages(with picture: PictureOfEPIC) {
        photoImageView.clipsToBounds = true
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.layer.cornerRadius = 10
        
        let imagePath = ImageManager.shared.generateEPICImageURLPath(for: picture)
        ImageManager.shared.fetchImage(for: imagePath) { [weak self] image in
            self?.photoImageView.image = image
            self?.photoImageView.animate(animation: .opacity, withDuration: 0.7, repeatCount: 0)
            self?.activityIndicator.stopAnimating()
        }
    }
    
    private func configureLabels(with picture: PictureOfEPIC) {
        dateLabel.text = "Photographed on the:\n" + picture.date
        dateLabel.numberOfLines = 0
    }
    
    private func configureActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.startAnimating()
    }
    
    private func setConstraints() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let photoImageViewConstraints = [
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            photoImageView.widthAnchor.constraint(equalToConstant: 100),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: 1.0),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ]
        
        let activityIndicatorConstraints = [
            activityIndicator.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor)
        ]
        
        let dateLabelConstraints = [
            dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 20)
        ]
        
        NSLayoutConstraint.activate(photoImageViewConstraints)
        NSLayoutConstraint.activate(activityIndicatorConstraints)
        NSLayoutConstraint.activate(dateLabelConstraints)
    }
    
    override func prepareForReuse() {
        photoImageView.image = nil
    }
}

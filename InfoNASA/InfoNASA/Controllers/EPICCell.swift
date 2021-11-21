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
    
    func configure(with picture: PictureOfEPIC) {
        self.addSubview(photoImageView)
        self.addSubview(dateLabel)
        
        configureImages(with: picture)
        configureLabels(with: picture)
        setConstraints()
    }
    
    private func configureImages(with picture: PictureOfEPIC) {
        photoImageView.clipsToBounds = true
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.image = UIImage(named: picture.imageName)
        photoImageView.layer.cornerRadius = 10
    }
    
    private func configureLabels(with picture: PictureOfEPIC) {
        dateLabel.text = picture.date
        dateLabel.textColor = .white
    }
    
    private func setConstraints() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let photoImageViewConstraints = [
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: 1),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ]
        
        let dateLabelConstraints = [
            dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(photoImageViewConstraints)
        NSLayoutConstraint.activate(dateLabelConstraints)
    }
}

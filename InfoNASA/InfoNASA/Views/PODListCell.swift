//
//  PODListCell.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 23.12.2021.
//

import UIKit

class PODListCell: UITableViewCell {
   
    //MARK: - Views
    private lazy var iconImage: UIImageView = {
        let iconImage = UIImageView()
        iconImage.clipsToBounds = true
        iconImage.contentMode = .scaleAspectFit
        iconImage.layer.cornerRadius = 10
        return iconImage
    }()
    
    private lazy var titleLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        return nameLabel
    }()
    
    private lazy var dateLabel = UILabel()

    func configure(with object: PODObject) {
        addSubviews(iconImage, titleLabel, dateLabel)
        setConstraints()
        
        configureLabels(for: object)
        configureImage(for: object)
    }
    
    private func addSubviews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
    
    //MARK: - Constraints
    private func setConstraints() {
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            iconImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            iconImage.widthAnchor.constraint(equalToConstant: 80),
            iconImage.heightAnchor.constraint(equalTo: iconImage.widthAnchor, multiplier: 1.0),
            iconImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: iconImage.topAnchor, constant: 10)
        ])
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        ])
    }
    
    //MARK: - Changing methods
    private func configureLabels(for object: PODObject) {
        titleLabel.text = object.title
        dateLabel.text = "\(object.date)"
    }
    
    private func configureImage(for object: PODObject) {
        NetworkManager.shared.fetchImage(for: object.url) { [weak self] image in
            self?.iconImage.image = image
        }
        iconImage.animate(animation: .opacity, withDuration: 0.5, repeatCount: 0)
    }
}

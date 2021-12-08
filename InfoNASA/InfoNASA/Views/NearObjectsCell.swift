//
//  NearObjectsCell.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 18.11.2021.
//

import UIKit

class NearObjectsCell: UITableViewCell {

    //MARK: - Views
    private lazy var iconImage: UIImageView = {
        let iconImage = UIImageView()
        iconImage.clipsToBounds = true
        iconImage.contentMode = .scaleAspectFit
        iconImage.image = UIImage(systemName: "circle.hexagonpath")
        return iconImage
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        return nameLabel
    }()
    
    private lazy var absoluteMagnitudeLabel = UILabel()
    private lazy var minDiameterLabel = UILabel()
    private lazy var maxDiameterLabel = UILabel()

    func configure(with object: NearEarthObject) {
        addSubviews(iconImage, nameLabel, absoluteMagnitudeLabel, minDiameterLabel, maxDiameterLabel)
        setConstraints()
        
        configureLabels(for: object)
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
            iconImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            iconImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            iconImage.heightAnchor.constraint(equalTo: nameLabel.heightAnchor),
            iconImage.widthAnchor.constraint(equalTo: iconImage.heightAnchor, multiplier: 1.0)
        ])
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        ])
        
        absoluteMagnitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            absoluteMagnitudeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            absoluteMagnitudeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10)
        ])
        
        minDiameterLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            minDiameterLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            minDiameterLabel.topAnchor.constraint(equalTo: absoluteMagnitudeLabel.bottomAnchor, constant: 10)
        ])
        
        maxDiameterLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            maxDiameterLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            maxDiameterLabel.topAnchor.constraint(equalTo: minDiameterLabel.bottomAnchor, constant: 10),
            maxDiameterLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    //MARK: - Changing methods
    private func configureLabels(for object: NearEarthObject) {
        nameLabel.text = object.name
        absoluteMagnitudeLabel.text = "Magnitude: \(object.absoluteMagnitudeH)"
        minDiameterLabel.text = "Diameter min: \(object.estimatedDiameter.kilometers.estimatedDiameterMin)"
        maxDiameterLabel.text = "Diameter max: \(object.estimatedDiameter.kilometers.estimatedDiameterMax)"
    }
}

//
//  NearObjectsCell.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 18.11.2021.
//

import UIKit

class NearObjectsCell: UITableViewCell {

    var iconImage = UIImageView()
    var nameLabel = UILabel()
    var absoluteMagnitudeLabel = UILabel()
    var minDiameterLabel = UILabel()
    var maxDiameterLabel = UILabel()

    func configure(with object: NearEarthObject) {
        self.addSubview(iconImage)
        self.addSubview(nameLabel)
        self.addSubview(absoluteMagnitudeLabel)
        self.addSubview(minDiameterLabel)
        self.addSubview(maxDiameterLabel)
        
        configureLabels(for: object)
        configureImages()
        setConstraints()
    }
    
    private func configureLabels(for object: NearEarthObject) {
        nameLabel.text = object.name
        nameLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        absoluteMagnitudeLabel.text = "Magnitude: \(object.absoluteMagnitudeH)"
        minDiameterLabel.text = "Diameter min: \(object.estimatedDiameter.kilometers.estimatedDiameterMin)"
        maxDiameterLabel.text = "Diameter max: \(object.estimatedDiameter.kilometers.estimatedDiameterMax)"
    }
    
    private func configureImages() {
        iconImage.clipsToBounds = true
        iconImage.contentMode = .scaleAspectFit
        iconImage.image = UIImage(systemName: "circle.hexagonpath")
    }
    
    private func setConstraints() {
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        absoluteMagnitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        minDiameterLabel.translatesAutoresizingMaskIntoConstraints = false
        maxDiameterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageConstraints = [
            iconImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            iconImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            iconImage.heightAnchor.constraint(equalTo: nameLabel.heightAnchor),
            iconImage.widthAnchor.constraint(equalTo: iconImage.heightAnchor, multiplier: 1.0)
        ]
        
        let nameLabelConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        ]
        
        let absoluteMagnitudeLabelConstraints = [
            absoluteMagnitudeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            absoluteMagnitudeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10)
        ]
        
        let minDiameterLabelConstraints = [
            minDiameterLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            minDiameterLabel.topAnchor.constraint(equalTo: absoluteMagnitudeLabel.bottomAnchor, constant: 10)
        ]
        
        let maxDiameterLabelConstraints = [
            maxDiameterLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            maxDiameterLabel.topAnchor.constraint(equalTo: minDiameterLabel.bottomAnchor, constant: 10),
            maxDiameterLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(iconImageConstraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(absoluteMagnitudeLabelConstraints)
        NSLayoutConstraint.activate(minDiameterLabelConstraints)
        NSLayoutConstraint.activate(maxDiameterLabelConstraints)
    }
}

//
//  EPICCell.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 22.11.2021.
//

import UIKit

class EPICListCell: UITableViewCell {

    //MARK: - Views
    private lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        photoImageView.clipsToBounds = true
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.layer.cornerRadius = 10
        return photoImageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.numberOfLines = 0
        return dateLabel
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    func configure(with object: EPICObject) {
        addSubviews(activityIndicator, photoImageView, dateLabel)
        setConstraints()

        configureLabels(with: object)
        configureImage(with: object)
    }
    
    private func addSubviews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
    
    //MARK: - Constraints
    private func setConstraints() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            photoImageView.widthAnchor.constraint(equalToConstant: 100),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: 1.0),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor)
        ])
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 20)
        ])
    }
    
    //MARK: - Changing methods
    private func configureImage(with object: EPICObject) {
        let imagePath = NetworkManager.shared.generateEPICImageURLPath(for: object)
        NetworkManager.shared.fetchImage(for: imagePath) { [weak self] image in
            self?.photoImageView.image = image
            self?.activityIndicator.stopAnimating()
        }
        photoImageView.animate(animation: .opacity, withDuration: 0.5, repeatCount: 0)
    }
    
    private func configureLabels(with object: EPICObject) {
        dateLabel.text = "Photographed on the:\n" + object.date
    }
    
    override func prepareForReuse() {
        photoImageView.image = UIImage(systemName: "globe.europe.africa")
        dateLabel.text = ""
    }
}

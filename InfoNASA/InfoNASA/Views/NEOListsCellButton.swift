//
//  NEOObjectCellButton.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 23.12.2021.

import UIKit

class NEOListsCellButton: UITableViewCell {

    //MARK: - Views
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Load 3 more days", for: .normal)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        return activityIndicator
    }()

    func configure() {
        addSubviews(moreButton, activityIndicator)
        setConstraints()
    }
    
    private func addSubviews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
    
    //MARK: - Constraints
    private func setConstraints() {
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moreButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            moreButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    //MARK: - Public methods
    func startUpdate() {
        moreButton.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func endUpdate() {
        activityIndicator.stopAnimating()
        moreButton.isHidden = false
    }
}

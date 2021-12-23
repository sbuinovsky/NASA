//
//  NEOObjectCellButton.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 23.12.2021.

import UIKit

class NEOObjectCellButton: UITableViewCell {

    //MARK: - Views
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Load 7 more days", for: .normal)
        return button
    }()

    func configure() {
        addSubviews(moreButton)
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
    }
}

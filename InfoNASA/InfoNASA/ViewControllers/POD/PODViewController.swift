//
//  PictureOfDayController.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 11.11.2021.
//

import UIKit
import RealmSwift

protocol PODListProtocol {
    func updatePOD(with object: PODObject)
}

class PODViewController: UIViewController {
    
    //MARK: - Views
    private lazy var scrollView = UIScrollView()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.contentMode = .left
        return titleLabel
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var copyrightLabel: UILabel = {
        let copyrightLabel = UILabel()
        copyrightLabel.contentMode = .right
        return copyrightLabel
    }()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.contentMode = .left
        return dateLabel
    }()
    
    private lazy var explanationLabel: UILabel = {
        let explanationLabel = UILabel()
        explanationLabel.numberOfLines = 0
        explanationLabel.contentMode = .left
        return explanationLabel
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        addScrollViewSubviews(copyrightLabel, dateLabel, imageView, titleLabel, explanationLabel, activityIndicator)
        setConstraints()
        
        NetworkManager.shared.fetchPODObject { [unowned self] result in
            switch result {
            case .success(let podObject):
                self.configureLabels(with: podObject)
                self.configureImage(with: podObject)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.title = "Picture of the Day"
        
        let listOfPODsButton = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(showPODlist))
        
        
        tabBarController?.navigationItem.rightBarButtonItem = listOfPODsButton
    }
    
    private func addScrollViewSubviews(_ views:UIView...) {
        for view in views {
            scrollView.addSubview(view)
        }
    }
    
    //MARK: - Constraints
    private func setConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20)
        ])
        
        copyrightLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            copyrightLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            copyrightLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20)
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.8)
        ])
        
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            explanationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            explanationLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            explanationLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            explanationLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40)
        ])
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        ])
    }

    //MARK: - Changing methods
    private func configureLabels(with picture: PODObject) {
        dateLabel.text = picture.date
        titleLabel.text = picture.title
        copyrightLabel.text = ""
        explanationLabel.text = picture.explanation
    }
    
    private func configureImage(with picture: PODObject) {
        NetworkManager.shared.fetchImage(for: picture.url) { [weak self] image in
            self?.imageView.image = image
            self?.activityIndicator.stopAnimating()
        }
        imageView.animate(animation: .opacity, withDuration: 0.5, repeatCount: 0)
    }
    
    //MARK: - Navigation
    @objc
    private func showPODlist() {
        let podListVC = PODListViewController()
        podListVC.delegate = self
        self.navigationController?.pushViewController(podListVC, animated: true)
    }
}

extension PODViewController: PODListProtocol {
    func updatePOD(with object: PODObject) {
        configureLabels(with: object)
        configureImage(with: object)
    }
}

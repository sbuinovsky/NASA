//
//  PictureOfDayController.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 11.11.2021.
//

import UIKit

class PictureOfDayViewController: UIViewController {

    //MARK: - Views
    var scrollView = UIScrollView()
    var titleLabel = UILabel()
    var imageView = UIImageView()
    var copyrightLabel = UILabel()
    var dateLabel = UILabel()
    var explanationLabel = UILabel()
    var urlLabel = UILabel()
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(copyrightLabel)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(imageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(explanationLabel)
        scrollView.addSubview(urlLabel)
        
        imageView.addSubview(activityIndicator)
        activityIndicator.isHidden = true
        
        NetworkManager.shared.fetchPictureOfDay { [weak self] result in
            switch result {
            case .success(let pictureOfDay):
                guard let picture = pictureOfDay else { return }
                self?.configureLabels(with: picture)
                self?.configureActivityIndicator()
                self?.configureImage(with: picture)
            case .failure(let error):
                print(error)
            }
        }
        
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.title = "Picture of the Day"
        
    }
    
    private func setConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        copyrightLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        urlLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let scrollViewConstraints = [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        let copyrightLabelConstraints = [
            copyrightLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            copyrightLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20)
        ]
        
        let dateLabelConstraints = [
            dateLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20)
        ]
        
        let imageViewConstraints = [
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.8)
        ]
        
        let activityIndicatorConstraints = [
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20)
        ]
        
        let explanationLabelConstraints = [
            explanationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            explanationLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            explanationLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
        ]
        
        let urlLabelConstraints = [
            urlLabel.topAnchor.constraint(equalTo: explanationLabel.bottomAnchor, constant: 20),
            urlLabel.leadingAnchor.constraint(equalTo: explanationLabel.leadingAnchor),
            urlLabel.trailingAnchor.constraint(equalTo: explanationLabel.trailingAnchor),
            urlLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40)
        
        ]
        
        NSLayoutConstraint.activate(scrollViewConstraints)
        NSLayoutConstraint.activate(dateLabelConstraints)
        NSLayoutConstraint.activate(copyrightLabelConstraints)
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(activityIndicatorConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(explanationLabelConstraints)
        NSLayoutConstraint.activate(urlLabelConstraints)
    }

    private func configureLabels(with picture: PictureOfDay) {
        dateLabel.text = picture.date
        dateLabel.font = .systemFont(ofSize: 18)
        dateLabel.contentMode = .left
        
        copyrightLabel.text = ""
        copyrightLabel.font = .systemFont(ofSize: 18)
        copyrightLabel.contentMode = .right
        
        titleLabel.numberOfLines = 0
        titleLabel.text = picture.title
        titleLabel.font = .systemFont(ofSize: 24)
        titleLabel.contentMode = .left
        
        explanationLabel.numberOfLines = 0
        explanationLabel.text = picture.explanation
        explanationLabel.font = .systemFont(ofSize: 20)
        explanationLabel.contentMode = .left
        
        urlLabel.numberOfLines = 1
        urlLabel.text = picture.url
        urlLabel.font = .systemFont(ofSize: 18)
        urlLabel.textColor = .systemBlue
        urlLabel.contentMode = .left
    }
    
    private func configureImage(with picture: PictureOfDay) {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        ImageManager.shared.fetchImage(for: picture.url) { [weak self] data in
            self?.imageView.image = UIImage(data: data)
            self?.activityIndicator.stopAnimating()
            self?.imageView.animate(animation: .opacity, withDuration: 0.7, repeatCount: 0)
            self?.imageView.layer.opacity = 1
        }
    }
    
    private func configureActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
    }
}

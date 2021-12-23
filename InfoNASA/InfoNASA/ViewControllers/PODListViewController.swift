//
//  PODListViewController.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 23.12.2021.
//

import UIKit
import RealmSwift

class PODListViewController: UIViewController {

    var podList: Results<PODObject>!
    
    //MARK: - Views
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = 40
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PODListCell")
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Pictures of Day"
        
        addSubviews(tableView, activityIndicator)
        setConstraints()
        activityIndicator.stopAnimating()
        
        podList = StorageManager.shared.realm.objects(PODObject.self)
        
    }
    
    private func addSubviews(_ views: UIView...) {
        for view in views {
            self.view.addSubview(view)
        }
    }
    
    //MARK: - Constraints
    private func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
}

//MARK: - Extension for TableView
extension PODListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        podList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PODListCell", for: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)

        let podObject = podList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.image = UIImage(systemName: "calendar")
        content.imageProperties.tintColor = UIColor(named: "mainBlueColor")
        content.text = podObject.title
        content.secondaryText = "\(podObject.date)"
        cell.contentConfiguration = content

        return cell
    }
    
    //MARK: - Navigation
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let neoObjectDetailedVC = NEODetailedViewController()
//        let neoObject = neoObjectsList.neoObjects[indexPath.row]
//        neoObjectDetailedVC.object = neoObject
//        self.navigationController?.pushViewController(neoObjectDetailedVC, animated: true)
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
}

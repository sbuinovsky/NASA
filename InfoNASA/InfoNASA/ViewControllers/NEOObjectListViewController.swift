//
//  NEOObjectListViewController.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 22.12.2021.
//

import UIKit

class NEOObjectListViewController: UIViewController {

    var neoObjectsList: NEOObjectsList!
    
    //MARK: - Views
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NEOObjectCell.self, forCellReuseIdentifier: "NEOObjectsCell")
        tableView.sectionHeaderHeight = 40
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
        title = "Objects at \(neoObjectsList.date)"
        
        addSubviews(tableView, activityIndicator)
        setConstraints()
        activityIndicator.stopAnimating()
        
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
extension NEOObjectListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        neoObjectsList.neoObjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NEOObjectsCell", for: indexPath) as! NEOObjectCell

        tableView.deselectRow(at: indexPath, animated: true)

        let neoObject = neoObjectsList.neoObjects[indexPath.row]
        cell.configure(with: neoObject)

        return cell
    }
    
    //MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let neoObjectDetailedVC = NEOObjectDetailedViewController()
        let neoObject = neoObjectsList.neoObjects[indexPath.row]
        neoObjectDetailedVC.object = neoObject
        self.navigationController?.pushViewController(neoObjectDetailedVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

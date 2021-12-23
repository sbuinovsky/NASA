//
//  NearObjectsController.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 12.11.2021.
//

import UIKit
import RealmSwift

class NEOListsViewController: UIViewController {

    //MARK: - Views
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NEOListsCell")
        tableView.register(NEOListsCellButton.self, forCellReuseIdentifier: "NEOListsCellButton")
        tableView.sectionHeaderHeight = 40
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        return activityIndicator
    }()
    
    private var neoObjectsLists: Results<NEOObjectsList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubviews(tableView, activityIndicator)
        setConstraints()
        neoObjectsLists = StorageManager.shared.realm.objects(NEOObjectsList.self).sorted(byKeyPath: "date", ascending: false)
       
        if !neoObjectsLists.isEmpty {
            activityIndicator.stopAnimating()
        } else {
            moreButtonPressed()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.title = "Near Earth objects"
        tabBarController?.navigationItem.rightBarButtonItem = nil
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
    
    @objc
    private func moreButtonPressed() {
        activityIndicator.startAnimating()
        tableView.layer.opacity = 0.2
        
        let lastDateString = neoObjectsLists.last?.date ?? ""
        let lastDate = DateFormatter.dateFromString(for: lastDateString)
        
        let dateRange = DateFormatter.getDateRange(forDays: 7, to: lastDate)
        NetworkManager.shared.fetchNEOObjects(forDateInterval: dateRange) { [unowned self] result in
            switch result {
            case .success(_):
                tableView.reloadData()
                tableView.layer.opacity = 1
                activityIndicator.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - Extension for TableView
extension NEOListsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? neoObjectsLists.count : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NEOListsCellButton", for: indexPath) as! NEOListsCellButton
            cell.configure()
            cell.moreButton.addTarget(self, action: #selector(moreButtonPressed), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NEOListsCell", for: indexPath)
            
            let neoObjectsList = neoObjectsLists[indexPath.row]
            
            var content = cell.defaultContentConfiguration()
            content.image = UIImage(systemName: "calendar")
            content.imageProperties.tintColor = UIColor(named: "mainBlueColor")
            content.text = neoObjectsList.date
            content.secondaryText = "\(neoObjectsList.neoObjects.count) objects"
            cell.contentConfiguration = content
            
            return cell
        }
    }
    
    //MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let neoObjectListVC = NEOListViewController()
            let neoObjectsList = neoObjectsLists[indexPath.row]
            neoObjectListVC.neoObjectsList = neoObjectsList
            self.navigationController?.pushViewController(neoObjectListVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            moreButtonPressed()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

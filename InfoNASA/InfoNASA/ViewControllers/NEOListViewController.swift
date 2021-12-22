//
//  NearObjectsController.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 12.11.2021.
//

import UIKit
import RealmSwift

class NEOListViewController: UIViewController {

    //MARK: - Views
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NEOObjectCell.self, forCellReuseIdentifier: "nearObjectsCell")
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
    
    private var objects: [String: [NEOObject]] = [:]
    private var objectsKeys: [String] = []
    private var tempObjectsKeys: [String] = []
    private var days: Int = 7
    
    private var neoObjectsLists: Results<NEOObjectsList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubviews(tableView, activityIndicator)
        setConstraints()
        
        neoObjectsLists = StorageManager.shared.realm.objects(NEOObjectsList.self).sorted(byKeyPath: "date", ascending: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.title = "Near Earth objects"
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
    
    //MARK: - Changing methods
    private func updateTableView(for days: Int) {
        
        if objects.count >= days {
            tempObjectsKeys = Array(objectsKeys.prefix(days))
            activityIndicator.stopAnimating()
            tableView.layer.opacity = 1
            tableView.reloadData()
            
        } else {
            let dateInterval = NetworkManager.shared.getDateInterval(for: days)
            NetworkManager.shared.fetchNEOObjects(forDateInterval: dateInterval) { [weak self] result in
                switch result {
                case .success(let nearEarthObjectsDict):
                    guard let nearEarthObjectsDict = nearEarthObjectsDict else { return }
                    self?.objects = nearEarthObjectsDict
                    self?.objectsKeys = Array((self?.objects.keys)!).sorted(by: >)
                    self?.tempObjectsKeys = self?.objectsKeys ?? []
                    self?.activityIndicator.stopAnimating()
                    self?.tableView.layer.opacity = 1
                    self?.tableView.reloadData()
                case .failure(_):
                    print("failure")
                }
            }
        }
    }
}

//MARK: - Extension for TableView
extension NEOListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        neoObjectsLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nearObjectsCell", for: indexPath) as! NEOObjectCell

        tableView.deselectRow(at: indexPath, animated: true)
        
        let neoObjectsList = neoObjectsLists[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.image = UIImage(systemName: "calendar")
        content.imageProperties.tintColor = UIColor(named: "mainBlueColor")
        content.text = neoObjectsList.date
        content.secondaryText = "\(neoObjectsList.neoObjects.count) objects"
        cell.contentConfiguration = content
        
        return cell
    }
    
    //MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nearEarthObjectDetailedVC = NEODetailedViewController()
        let key = tempObjectsKeys[indexPath.section]
        let object = objects[key]?[indexPath.row]
        nearEarthObjectDetailedVC.object = object
        self.navigationController?.pushViewController(nearEarthObjectDetailedVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

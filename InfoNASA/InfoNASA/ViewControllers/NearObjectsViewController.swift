//
//  NearObjectsController.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 12.11.2021.
//

import UIKit

class NearObjectsViewController: UIViewController {

    var tableView = UITableView()
    var activityIndicator = UIActivityIndicatorView()
    
    private var objects: [String: [NearEarthObject]] = [:]
    private var objectsKeys: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.addSubview(activityIndicator)
        
        configureTableView()
        configureActivityIndicator()
        setConstraints()
        
        let dateInterval = getDateInterval(for: 2)
        
        NetworkManager.shared.fetchNearEarthObjects(forDateInterval: dateInterval) { [weak self] result in
            switch result {
            case .success(let nearEarthObjectsDict):
                guard let nearEarthObjectsDict = nearEarthObjectsDict else { return }
                self?.objects = nearEarthObjectsDict
                self?.objectsKeys = Array((self?.objects.keys)!).sorted(by: >)
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
            case .failure(_):
                print("failure")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.title = "Near Earth objects"
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NearObjectsCell.self, forCellReuseIdentifier: "nearObjectsCell")
        tableView.sectionHeaderHeight = 60
    }
    
    private func configureActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
    }
    
    private func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        let activityIndicatorConstraints = [
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(tableViewConstraints)
        NSLayoutConstraint.activate(activityIndicatorConstraints)
    }
    
    private func getDateInterval(for days: Int) -> [String: String] {
        let startDate = Date()
        let timeInterval = TimeInterval(-3600 * 24 * days)
        let endDate = Date(timeInterval: timeInterval, since: startDate)
        return NetworkManager.shared.getDateInterval(from: startDate, to: endDate)
    }
}

extension NearObjectsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        objectsKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = objectsKeys[section]
        return objects[key]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nearObjectsCell", for: indexPath) as! NearObjectsCell

        tableView.deselectRow(at: indexPath, animated: true)

        let key = objectsKeys[indexPath.section]
        let object = objects[key]?[indexPath.row]
        if let object = object {
            cell.configure(with: object)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Date: \(objectsKeys[section])"
    }

}

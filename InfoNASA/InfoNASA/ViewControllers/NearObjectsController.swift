//
//  NearObjectsController.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 12.11.2021.
//

import UIKit

class NearObjectsController: UIViewController {

    var tableView = UITableView()
    
    private var objects: [String: [NearEarthObject]] = [:]
    private var objectsKeys: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        NetworkManager.shared.fetchNearEarthObjects { [weak self] result in
            switch result {
            case .success(let nearEarthObjectsDict):
                guard let nearEarthObjectsDict = nearEarthObjectsDict else { return }
                self?.objects = nearEarthObjectsDict
                self?.objectsKeys = Array((self?.objects.keys)!)
                self?.tableView.reloadData()
            case .failure(_):
                print("failure")
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NearObjectsCell.self, forCellReuseIdentifier: "nearObjectsCell")
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.title = "Near Earth objects"
    }
    
    private func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(tableViewConstraints)
    }
}

extension NearObjectsController: UITableViewDataSource, UITableViewDelegate {
    
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

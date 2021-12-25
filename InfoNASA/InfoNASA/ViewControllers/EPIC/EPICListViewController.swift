//
//  EPICController.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 12.11.2021.
//

import UIKit
import RealmSwift

class EPICListViewController: UIViewController {

    //MARK: - Views
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EPICListCell.self, forCellReuseIdentifier: "EPICListCell")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var epicObjects: Results<EPICObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        setConstraints()
        
        epicObjects = StorageManager.shared.realm.objects(EPICObject.self)
        
        if epicObjects.count == 0 {
            loadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.title = "Polychromatic camera"
        tabBarController?.navigationItem.rightBarButtonItem = nil
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
    }
    
    private func loadData() {
        NetworkManager.shared.fetchEPICObjects { [unowned self] result in
            switch result {
            case .success( let message):
                print(message.rawValue)
                tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - Extension for TableView
extension EPICListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        epicObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EPICListCell", for: indexPath) as! EPICListCell
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let object = epicObjects[indexPath.row]
        
        cell.configure(with: object)
        
        return cell
    }
    
    //MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let epicDetailedVC = EPICDetailedViewController()
        let object = epicObjects[indexPath.row]
        epicDetailedVC.object = object
        self.navigationController?.pushViewController(epicDetailedVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

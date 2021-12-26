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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.style = .large
        return activityIndicator
    }()
    
    private var epicObjects: Results<EPICObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        view.backgroundColor = .white
        
        addSubviews(tableView, activityIndicator)
        setConstraints()
        
        epicObjects = StorageManager.shared.realm.objects(EPICObject.self)
        
        activityIndicator.stopAnimating()
        
        if epicObjects.count == 0 {
            loadData(forDate: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.title = "Polychromatic camera"
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
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func loadData(forDate date: Date?) {
        activityIndicator.startAnimating()
        
        NetworkManager.shared.fetchEPICObjects(forDate: date) { [unowned self] result in
            switch result {
            case .success( let message):
                print(message.rawValue)
                tableView.reloadData()
                activityIndicator.stopAnimating()
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

extension EPICListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxRow = indexPaths.map(\.row).max() else { return }
        if maxRow > epicObjects.count - 2  {
            guard let lastObjectDate = epicObjects.last?.date else { return }
            guard let shortDate = lastObjectDate.split(separator: " ").first else { return }
            let date = DateFormatter.dateFromString(for: String(shortDate))
            loadData(forDate: date - 1)
        }
    }
}

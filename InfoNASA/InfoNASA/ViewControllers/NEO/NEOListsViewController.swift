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
        tableView.sectionHeaderHeight = 40
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
    
    private lazy var loadMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Load more objects", for: .normal)
        button.setTitleColor(UIColor(named: "mainBlueColor"), for: .normal)
        button.addTarget(self, action: #selector(loadData), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private var neoObjectsLists: Results<NEOObjectsList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        
        view.backgroundColor = .white
        
        addSubviews(tableView, activityIndicator, loadMoreButton)
        setConstraints()
        print(view.constraints)
        neoObjectsLists = StorageManager.shared.realm.objects(NEOObjectsList.self).sorted(byKeyPath: "date", ascending: false)
        
        activityIndicator.stopAnimating()
        
        if neoObjectsLists.count < 8 {
            loadData()
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
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        loadMoreButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadMoreButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loadMoreButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])
    }
    
    @objc
    private func loadData() {
        activityIndicator.startAnimating()
        
        let lastDateString = neoObjectsLists.last?.date ?? ""
        let lastDate = DateFormatter.dateFromString(for: lastDateString)
        
        let dateRange = DateFormatter.getDateRange(forDays: 7, to: lastDate)
        
        NetworkManager.shared.fetchNEOObjects(forDateInterval: dateRange) { [unowned self] result in
            switch result {
            case .success( let message):
                print(message.rawValue)
                tableView.reloadData()
                activityIndicator.stopAnimating()
                if neoObjectsLists.count > 10 {
                    loadMoreButton.isHidden = true
                } else {
                    loadMoreButton.isHidden = false
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - Extension for TableView
extension NEOListsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        neoObjectsLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    //MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let neoObjectListVC = NEOListViewController()
        let neoObjectsList = neoObjectsLists[indexPath.row]
        neoObjectListVC.neoObjectsList = neoObjectsList
        self.navigationController?.pushViewController(neoObjectListVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NEOListsViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxRow = indexPaths.map(\.row).max() else { return }
        if maxRow > neoObjectsLists.count - 10 {
            loadData()
        }
    }
    
    
    
}

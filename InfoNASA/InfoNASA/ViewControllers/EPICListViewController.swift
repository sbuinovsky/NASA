//
//  EPICController.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 12.11.2021.
//

import UIKit

class EPICListViewController: UIViewController {

    //MARK: - Views
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EPICObjectCell.self, forCellReuseIdentifier: "EPICCell")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var pictures: [PictureOfEPIC] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        setConstraints()
        
        NetworkManager.shared.fetchEPICObjects { [weak self] result in
            switch result {
            case .success( let picturesOfEPIC):
                guard let picturesOfEPIC = picturesOfEPIC else { return }
                self?.pictures = picturesOfEPIC
                self?.tableView.reloadData()
                for picture in self?.pictures ?? [] {
                    print(picture)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.title = "Polychromatic camera"
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
}

//MARK: - Extension for TableView
extension EPICListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EPICCell", for: indexPath) as! EPICObjectCell
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let picture = pictures[indexPath.row]
        
        cell.configure(with: picture)
        
        return cell
    }
    
    //MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pictureOfEPICDetailedVC = EPICDetailedViewController()
        let object = pictures[indexPath.row]
        pictureOfEPICDetailedVC.object = object
        self.navigationController?.pushViewController(pictureOfEPICDetailedVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

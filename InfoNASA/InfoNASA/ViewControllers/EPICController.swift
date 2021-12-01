//
//  EPICController.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 12.11.2021.
//

import UIKit

class EPICController: UIViewController {

    //MARK: - Views
    var tableView = UITableView()
    
    private var pictures: [PictureOfEPIC] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EPICCell.self, forCellReuseIdentifier: "EPICCell")
        tableView.separatorStyle = .none
        
        NetworkManager.shared.fetchPictureOfEPIC { [weak self] result in
            switch result {
            case .success( let picturesOfEPIC):
                guard let picturesOfEPIC = picturesOfEPIC else { return }
                self?.pictures = picturesOfEPIC
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.title = "Polychromatic camera"
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

extension EPICController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EPICCell", for: indexPath) as! EPICCell
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let picture = pictures[indexPath.row]
        
        cell.configure(with: picture)
        
        return cell
    }
    
}

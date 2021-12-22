//
//  NearObjectsController.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 12.11.2021.
//

import UIKit

class NEOListViewController: UIViewController {

    //MARK: - Views
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NearEarthObjectCell.self, forCellReuseIdentifier: "nearObjectsCell")
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
    
    private lazy var sliderView = UIView()
    
    private lazy var sliderLabel: UILabel = {
        let sliderLabel = UILabel()
        sliderLabel.text = "Days: \(days)"
        sliderLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        return sliderLabel
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.tintColor = UIColor(named: "mainBlueColor")
        slider.minimumValue = 1
        slider.maximumValue = 5
        slider.value = Float(days)
        slider.addTarget(self, action: #selector(sliderEndChanging), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderChanging), for: .valueChanged)
        return slider
    }()
    
    private var objects: [String: [NEOObject]] = [:]
    private var objectsKeys: [String] = []
    private var tempObjectsKeys: [String] = []
    private var days: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubviews(sliderView, tableView, activityIndicator)
        addSliderViewSubviews(sliderLabel, slider)
        setConstraints()
        
        updateTableView(for: days)
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
    
    private func addSliderViewSubviews(_ views: UIView...) {
        for view in views {
            sliderView.addSubview(view)
        }
    }
    
    //MARK: - Constraints
    private func setConstraints() {
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sliderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sliderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            sliderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        sliderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sliderLabel.topAnchor.constraint(equalTo: sliderView.topAnchor, constant: 10),
            sliderLabel.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor, constant: 20),
            sliderLabel.trailingAnchor.constraint(equalTo: sliderView.trailingAnchor, constant: -20)
        ])
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: sliderLabel.bottomAnchor, constant: 10),
            slider.centerXAnchor.constraint(equalTo: sliderLabel.centerXAnchor),
            slider.widthAnchor.constraint(equalTo: sliderLabel.widthAnchor),
            slider.bottomAnchor.constraint(equalTo: sliderView.bottomAnchor, constant: -10)
        ])
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: sliderView.bottomAnchor),
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
    private func updateSlider() {
        slider.value = Float(days)
        sliderLabel.text = "Days: \(days)"
    }
    
    @objc
    private func sliderEndChanging(sender: UISlider) {
        activityIndicator.startAnimating()
        tableView.layer.opacity = 0.2
        updateSlider()
        updateTableView(for: days)
    }
    
    @objc
    private func sliderChanging(sender: UISlider) {
        days = Int(sender.value)
        sliderLabel.text = "Days: \(days)"
    }
    
    private func updateTableView(for days: Int) {
        
        if objects.count >= days {
            tempObjectsKeys = Array(objectsKeys.prefix(days))
            activityIndicator.stopAnimating()
            tableView.layer.opacity = 1
            tableView.reloadData()
            
        } else {
            let dateInterval = NetworkManager.shared.getDateInterval(for: days)
            NetworkManager.shared.fetchNearEarthObjects(forDateInterval: dateInterval) { [weak self] result in
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tempObjectsKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = tempObjectsKeys[section]
        return objects[key]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nearObjectsCell", for: indexPath) as! NearEarthObjectCell

        tableView.deselectRow(at: indexPath, animated: true)

        let key = tempObjectsKeys[indexPath.section]
        let object = objects[key]?[indexPath.row]
        if let object = object {
            cell.configure(with: object)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Date: \(tempObjectsKeys[section])"
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

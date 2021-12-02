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
    var sliderView = UIView()
    var sliderLabel = UILabel()
    var slider = UISlider()
    
    private var objects: [String: [NearEarthObject]] = [:]
    private var objectsKeys: [String] = []
    private var tempObjectsKeys: [String] = []
    private var days: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(sliderView)
        sliderView.addSubview(sliderLabel)
        sliderView.addSubview(slider)
        configureSlider()
        configureSliderLabel()
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        configureTableView()
        configureActivityIndicator()
        setConstraints()
        
        updateTableView(for: days)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.title = "Near Earth objects"
    }
    
    private func configureSliderLabel() {
        sliderLabel.text = "Days: \(days)"
        sliderLabel.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    private func configureSlider() {
        slider.minimumValue = 1
        slider.maximumValue = 5
        slider.value = Float(days)
        slider.addTarget(self, action: #selector(sliderEndChanging), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderChanging), for: .valueChanged)
    }
    
    private func updateSlider() {
        slider.value = Float(days)
    }
    
    @objc
    private func sliderEndChanging(sender: UISlider) {
        activityIndicator.startAnimating()
        tableView.layer.opacity = 0.2
        configureSliderLabel()
        updateSlider()
        updateTableView(for: days)
    }
    
    @objc
    private func sliderChanging(sender: UISlider) {
        days = Int(sender.value)
        configureSliderLabel()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NearObjectsCell.self, forCellReuseIdentifier: "nearObjectsCell")
        tableView.sectionHeaderHeight = 40
    }
    
    private func configureActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        tableView.layer.opacity = 0.2
    }
    
    private func setConstraints() {
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderLabel.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let sliderViewConstraints = [
            sliderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sliderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            sliderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ]
        
        let sliderLabelConstraints = [
            sliderLabel.topAnchor.constraint(equalTo: sliderView.topAnchor, constant: 10),
            sliderLabel.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor, constant: 20),
            sliderLabel.trailingAnchor.constraint(equalTo: sliderView.trailingAnchor, constant: -20)
        ]
        
        let sliderConstraints = [
            slider.topAnchor.constraint(equalTo: sliderLabel.bottomAnchor, constant: 10),
            slider.centerXAnchor.constraint(equalTo: sliderLabel.centerXAnchor),
            slider.widthAnchor.constraint(equalTo: sliderLabel.widthAnchor),
            slider.bottomAnchor.constraint(equalTo: sliderView.bottomAnchor, constant: -10)
        ]
        
        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: sliderView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        let activityIndicatorConstraints = [
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(sliderViewConstraints)
        NSLayoutConstraint.activate(sliderLabelConstraints)
        NSLayoutConstraint.activate(sliderConstraints)
        NSLayoutConstraint.activate(tableViewConstraints)
        NSLayoutConstraint.activate(activityIndicatorConstraints)
    }
    
    private func getDateInterval(for days: Int) -> [String: String] {
        let startDate = Date()
        let timeInterval = TimeInterval(-3600 * 24 * (days - 1))
        let endDate = Date(timeInterval: timeInterval, since: startDate)
        return NetworkManager.shared.getDateInterval(from: startDate, to: endDate)
    }
    
    private func updateTableView(for days: Int) {
        
        if objects.count >= days {
            tempObjectsKeys = Array(objectsKeys.prefix(days))
            activityIndicator.stopAnimating()
            tableView.layer.opacity = 1
            tableView.reloadData()
            
        } else {
            let dateInterval = getDateInterval(for: days)
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

extension NearObjectsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tempObjectsKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = tempObjectsKeys[section]
        return objects[key]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nearObjectsCell", for: indexPath) as! NearObjectsCell

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
}

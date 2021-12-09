//
//  MainNavigationController.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 11.11.2021.
//

import UIKit

class MainNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.prefersLargeTitles = true
        
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "mainBlueColor") ?? .brown]
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "mainBlueColor") ?? .brown]
        navigationBar.tintColor = UIColor(named: "mainBlueColor")
    }
}

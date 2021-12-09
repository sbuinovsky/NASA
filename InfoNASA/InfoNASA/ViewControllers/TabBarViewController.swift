//
//  TabBarController.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 11.11.2021.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        modalPresentationStyle = .fullScreen
        delegate = self
        addControllers()
    }

    private func addControllers() {
        let pictureOfDayVC = PictureOfDayViewController()
        let tabBarItem = UITabBarItem(title: "POD",
                                       image: UIImage(systemName: "photo.artframe"),
                                       selectedImage: UIImage(systemName: "photo.artframe"))
        tabBarItem.imageInsets = UIEdgeInsets(top: 85, left: 85, bottom: 85, right: 85)
        pictureOfDayVC.tabBarItem = tabBarItem
        
        let nearObjectsVC = NearEarthObjectListViewController()
        let tabBarItem1 = UITabBarItem(title: "NEO",
                                       image: UIImage(systemName: "allergens"),
                                       selectedImage: UIImage(systemName: "allergens"))
        tabBarItem1.imageInsets = UIEdgeInsets(top: 85, left: 85, bottom: 85, right: 85)
        nearObjectsVC.tabBarItem = tabBarItem1
        
        let epicVC = PictureOfEPICListViewController()
        let tabBarItem2 = UITabBarItem(title: "EPIC",
                                       image: UIImage(systemName: "globe.europe.africa"),
                                       selectedImage: UIImage(systemName: "globe.europe.africa"))
        tabBarItem2.imageInsets = UIEdgeInsets(top: 85, left: 85, bottom: 85, right: 85)
        epicVC.tabBarItem = tabBarItem2
        
        self.viewControllers = [pictureOfDayVC, nearObjectsVC, epicVC]
    }
}

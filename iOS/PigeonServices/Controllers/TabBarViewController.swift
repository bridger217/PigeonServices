//
//  TabBarViewController.swift
//  PigeonServices
//
//  Created by Bridge Dudley on 7/10/23.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpControllers()
    }
    
    private func setUpControllers() {
        let todaysPicture = TodaysMemoryViewController()
        let pastPictures = PastMemoriesViewController()
        
        let todaysPictureNav = UINavigationController(rootViewController: todaysPicture)
        let pastPicturesNav = UINavigationController(rootViewController: pastPictures)
        
        todaysPictureNav.navigationBar.tintColor = .label
        pastPicturesNav.navigationBar.tintColor = .label
        
        if #available(iOS 14.0, *) {
            todaysPicture.navigationItem.backButtonDisplayMode = .minimal
            pastPictures.navigationItem.backButtonDisplayMode = .minimal
        } else {
            todaysPicture.navigationItem.backButtonTitle = ""
            pastPictures.navigationItem.backButtonTitle = ""
        }
        
        todaysPictureNav.tabBarItem = UITabBarItem(title: "Today", image: UIImage(systemName: "heart.fill"), tag: 1)
        pastPicturesNav.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "clock.fill"), tag: 1)
        
        self.setViewControllers([
            todaysPictureNav,
            pastPicturesNav
        ], animated: false)
        
        self.tabBar.tintColor = .systemPink
    }
}

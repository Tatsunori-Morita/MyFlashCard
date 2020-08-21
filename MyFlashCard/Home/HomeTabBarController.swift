//
//  HomeTabBarController.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var viewControllers = [UIViewController]()
        
        let homeVC = HomeViewController.createInstance()
        let homeNavi = UINavigationController(rootViewController: homeVC)
        homeNavi.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))
        homeNavi.tabBarItem.tag = 1
        
        let commonVC = CommonSettingViewController.createInstance()
        let commonNavi = UINavigationController(rootViewController: commonVC)
        commonNavi.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "gear"), selectedImage: UIImage(named: "gear"))
        commonNavi.tabBarItem.tag = 2
        
        viewControllers.append(homeNavi)
        viewControllers.append(commonNavi)
        
        UITabBar.appearance().tintColor = UIColor(red: 90/255, green: 91/255, blue: 90/255, alpha: 1.0)
        tabBar.barTintColor = UIColor(red: 250/255, green: 249/255, blue: 249/255, alpha: 1.0)
        self.tabBar.isTranslucent = false
        self.setViewControllers(viewControllers, animated: false)
        
    }
}

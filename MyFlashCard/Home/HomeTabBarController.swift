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
        homeNavi.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))
        homeNavi.tabBarItem.tag = 1
        
        let commonVC = CommonSettingViewController.createInstance()
        let commonNavi = UINavigationController(rootViewController: commonVC)
        commonNavi.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(systemName: "gear"), selectedImage: UIImage(named: "gear"))
        commonNavi.tabBarItem.tag = 2
        
        viewControllers.append(homeNavi)
        viewControllers.append(commonNavi)
        
        self.tabBar.isTranslucent = false
        self.setViewControllers(viewControllers, animated: false)
        
    }
}

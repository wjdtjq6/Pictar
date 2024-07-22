//
//  TabBarViewController.swift
//  Picha
//
//  Created by t2023-m0032 on 7/22/24.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .mainColor
        tabBar.unselectedItemTintColor = .greyColor
        
        let topic = TopicViewController()
        let nav1 = UINavigationController(rootViewController: topic)
        nav1.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_trend"), selectedImage: UIImage(named: "tab_trend_inactive"))
       
        let random = RandomViewController()
        let nav2 = UINavigationController(rootViewController: random)
        nav2.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_random"), selectedImage: UIImage(named: "tab_random_inactive"))
        
        let search = SearchViewController()
        let nav3 = UINavigationController(rootViewController: search)
        nav3.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_search"), selectedImage: UIImage(named: "tab_search_inactive"))
        
        let like = LikeSearchViewController()
        let nav4 = UINavigationController(rootViewController: like)
        nav4.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_like"), selectedImage: UIImage(named: "tab_like_inactive"))
        
        setViewControllers([nav1,nav2,nav3,nav4], animated: true)
    }
}

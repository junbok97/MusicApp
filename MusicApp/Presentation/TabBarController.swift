//
//  TabBarViewController.swift
//  NewMusicApp
//
//  Created by 이준복 on 2023/02/21.
//

import UIKit
import SwiftUI

final class TabBarController: UITabBarController {
    
    private lazy var searchListViewController: UINavigationController = {
        let viewController = SearchListViewController()
        let tabBarItem = UITabBarItem(title: "Music Search", image:  UIImage(systemName: "magnifyingglass"), tag: 0)
        viewController.tabBarItem = tabBarItem
        return UINavigationController(rootViewController: viewController)
    }()
    
    private lazy var savedListViewController: UINavigationController = {
        let viewController = SavedListViewController()
        let tabBarItem =  UITabBarItem(title: "Saved", image: UIImage(systemName: "bookmark"), selectedImage:  UIImage(systemName: "bookmark.fill"))
        viewController.tabBarItem = tabBarItem
        return UINavigationController(rootViewController: viewController)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    func setupTabBar() {
        viewControllers = [searchListViewController, savedListViewController]
        modalPresentationStyle = .fullScreen
        tabBar.tintColor = .label
    }
}

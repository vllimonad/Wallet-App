//
//  ViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    let mainView = MainViewController()
    let transactionsView = TransactionsTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "cell")
        setupTabBarAppearance()
        setupTabBarItems()
    }
    
    func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    func setupTabBarItems() {
        mainView.tabBarItem = UITabBarItem(title: "Statistics", image: UIImage(named: "statisticsIcon"), tag: 0)
        transactionsView.tabBarItem = UITabBarItem(title: "Records", image: UIImage(named: "history"), tag: 1)
        transactionsView.delegate = mainView
        mainView.transactionsList = DataManager.shared.readData()
        viewControllers = [
            UINavigationController(rootViewController: mainView),
            UINavigationController(rootViewController: transactionsView)
        ]
    }
}


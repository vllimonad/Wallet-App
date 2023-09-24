//
//  ViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

final class ViewController: UITabBarController {
    
    let mainView = MainViewController()
    let tableView = TransactionsTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        tabBar.layer.borderWidth = 0
        setupAppearance()
        addViews()
    }
    
    func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    func addViews() {
        mainView.tabBarItem = UITabBarItem(title: "Statistics", image: UIImage(named: "statisticsIcon"), tag: 0)
        tableView.tabBarItem = UITabBarItem(title: "Records", image: UIImage(named: "history"), tag: 1)
        //mainView.transactionsTableViewController = tableView
        mainView.readData()
        tableView.transactionsTableViewControllerDelegate = mainView
        //tableView.readData()
        
        viewControllers = [UINavigationController(rootViewController: mainView), tableView]
    }
}


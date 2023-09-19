//
//  ViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

class ViewController: UITabBarController {
    
    let mainView = MainViewController()
    let tableView = TransactionsTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        tabBar.layer.borderWidth = 0
        appearance()
        setViews()
    }
    
    func appearance() {
        let scrollEdgeAppearance = UITabBarAppearance()
        let standardAppearance = UITabBarAppearance()
        standardAppearance.configureWithOpaqueBackground()
        scrollEdgeAppearance.configureWithTransparentBackground()
        //scrollEdgeAppearance.configureWithOpaqueBackground()
        //scrollEdgeAppearance.backgroundColor = .white
        standardAppearance.backgroundColor = UIColor.white
        tabBar.standardAppearance = scrollEdgeAppearance
        tabBar.scrollEdgeAppearance = scrollEdgeAppearance
    }
    
    func setViews() {
        mainView.tabBarItem = UITabBarItem(title: "Statistics", image: UIImage(named: "statisticsIcon"), tag: 0)
        tableView.tabBarItem = UITabBarItem(title: "History", image: UIImage(named: "history"), tag: 1)
        mainView.transactionsTableViewController = tableView
        tableView.mainVewController = mainView
        tableView.readData()
        
        viewControllers = [UINavigationController(rootViewController: mainView), tableView]
    }
}


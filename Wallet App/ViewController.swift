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
        //appearance()
        setViews()
    }
    
    func appearance() {
        let scrollEdgeAppearance = UITabBarAppearance()
        let standardAppearance = UITabBarAppearance()
        standardAppearance.configureWithOpaqueBackground()
        scrollEdgeAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = UIColor(named: "background")
        tabBar.standardAppearance = standardAppearance
        tabBar.scrollEdgeAppearance = standardAppearance
    }
    
    func setViews() {
        mainView.tabBarItem = UITabBarItem(title: "Statistics", image: UIImage(named: "statisticsIcon"), tag: 0)
        tableView.tabBarItem = UITabBarItem(title: "History", image: UIImage(named: "history"), tag: 1)
        mainView.transactionsTableViewDelegate = tableView
        tableView.mainVewController = mainView
        tableView.readData()
        
        viewControllers = [UINavigationController(rootViewController: mainView), tableView]
    }
}


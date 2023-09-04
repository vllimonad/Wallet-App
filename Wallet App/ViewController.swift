//
//  ViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

class ViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    func setViews() {
        let mainView = MainViewController()
        mainView.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)

        let transactionView = UIViewController()
        transactionView.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)

        let tableView = TransactionsTableViewController()
        tableView.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 2)
            
        setViewControllers([mainView, transactionView, tableView], animated: false)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            let transactionView = UINavigationController(rootViewController: NewTransactionViewController())
            transactionView.modalPresentationStyle = UIModalPresentationStyle.formSheet
            present(transactionView, animated: true)
        }
    }
}


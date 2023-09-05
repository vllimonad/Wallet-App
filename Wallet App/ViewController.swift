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
        mainView.tabBarItem = UITabBarItem(title: "Statistics", image: UIImage(named: "statisticsIcon"), tag: 0)
        

        let transactionView = UIViewController()
        transactionView.view.backgroundColor = .white
        transactionView.tabBarItem = UITabBarItem(title: nil , image: UIImage(named: "add"), tag: 1)

        let tableView = TransactionsTableViewController()
        tableView.tabBarItem = UITabBarItem(title: "History", image: UIImage(named: "history"), tag: 2)
            
        viewControllers = [mainView, transactionView, tableView]
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            let transactionView = UINavigationController(rootViewController: NewTransactionViewController())
            transactionView.modalPresentationStyle = UIModalPresentationStyle.formSheet
            present(transactionView, animated: true)
        }
    }
}


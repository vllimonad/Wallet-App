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
        
        let vc = MainViewController()
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        let add = NewTransactionViewController()
        add.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 2)
        let navc2 = UINavigationController(rootViewController: add)
        
//        navc2.modalPresentationStyle = .formSheet
//        present(navc2, animated: true)
        
        let tr = TransactionsTableViewController()
        tr.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 1)
        
        self.setViewControllers([vc, navc2, tr], animated: true)
    }


}


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
        let navc = UINavigationController(rootViewController: vc)
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        let tr = TransactionsTableView()
        tr.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 1)
        self.setViewControllers([navc,tr], animated: true)
    }


}


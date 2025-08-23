//
//  ViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private let mainViewController: MainViewController
    
    private let addRecordViewController: AddRecordViewController
    
    private let historyViewController: HistoryTableViewController
    
    init() {
        self.mainViewController = MainViewController()
        self.addRecordViewController = AddRecordViewController()
        self.historyViewController = HistoryTableViewController()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarAppearance()
        setupTabBarItems()
    }
    
    func setupTabBarAppearance() {
        view.backgroundColor = UIColor(named: "cell")
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    func setupTabBarItems() {
        mainViewController.tabBarItem = UITabBarItem(title: "Statistics",
                                                     image: UIImage(systemName: "chart.pie"),
                                                     selectedImage: UIImage(systemName: "chart.pie.fill"))
        
        let addRecordIcon = UIImage(systemName: "plus.circle")?.applyingSymbolConfiguration(.init(pointSize: 25))
        addRecordViewController.tabBarItem = UITabBarItem(title: nil,
                                                          image: addRecordIcon,
                                                          selectedImage: addRecordIcon)
        
        historyViewController.tabBarItem = UITabBarItem(title: "Records",
                                                        image: UIImage(systemName: "list.clipboard"),
                                                        selectedImage: UIImage(systemName: "list.clipboard.fill"))
        
        historyViewController.delegate = mainViewController
        mainViewController.transactionsList = DataManager.shared.readData()
        
        viewControllers = [
            UINavigationController(rootViewController: mainViewController),
            UINavigationController(rootViewController: addRecordViewController),
            UINavigationController(rootViewController: historyViewController)
        ]
    }
}


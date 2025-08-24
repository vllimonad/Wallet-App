//
//  ViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
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
        
        setupTabBar()
        setupTabBarAppearance()
        setupTabBarItems()
        updateTabBar()
    }
    
    private func setupTabBar() {
        let tabBar = TabBar()
        setValue(tabBar, forKey: "tabBar")
        delegate = self
        
        tabBar.didTapAddRecord = { [weak self] in
            let addRecordViewController = UINavigationController(rootViewController: AddRecordViewController())
            self?.present(addRecordViewController, animated: true)
        }
    }
    
    private func setupTabBarAppearance() {
        view.backgroundColor = UIColor(named: "cell")
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func setupTabBarItems() {
//        historyViewController.delegate = mainViewController
//        mainViewController.transactionsList = DataManager.shared.readData()

        viewControllers = [
            UINavigationController(rootViewController: mainViewController),
            UINavigationController(rootViewController: historyViewController)
        ]
    }
    
    private func updateTabBar() {
        (tabBar as? TabBar)?.updateButtonsState(selectedIndex)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateTabBar()
    }
}

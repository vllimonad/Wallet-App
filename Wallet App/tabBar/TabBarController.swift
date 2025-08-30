//
//  ViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private let transactionService: TransactionService

    init(_ transactionService: TransactionService) {
        self.transactionService = transactionService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupTabBarAppearance()
        updateTabBar()
    }
    
    private func setupTabBar() {
        let tabBar = TabBar()
        setValue(tabBar, forKey: "tabBar")
        delegate = self
        
        tabBar.didTapAddRecord = { [weak self] in
            guard let self else { return }
            
            let addTransactionViewModel = AddTransactionViewModel(transactionService)
            let addTransactionViewController = AddTransactionViewController(viewModel: addTransactionViewModel)
            
            self.present(UINavigationController(rootViewController: addTransactionViewController), animated: true)
        }
    }
    
    private func setupTabBarAppearance() {
        view.backgroundColor = UIColor(named: "cell")
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func updateTabBar() {
        (tabBar as? TabBar)?.updateButtonsState(selectedIndex)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateTabBar()
    }
}

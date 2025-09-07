//
//  TableOfCategoriesViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 08/09/2023.
//

import UIKit

final class CategoryTableViewController: UIViewController {
    
    private let tableView: UITableView
        
    public var didSelectCategory: ((TransactionCategory) -> ())?
    
    init() {
        self.tableView = UITableView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavigationBar()
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor(resource: .cell)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryViewCell.self, forCellReuseIdentifier: CategoryViewCell.reuseIdentifier())
        tableView.rowHeight = 75
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.title = NSLocalizedString("Categories", comment: "")
    }
}

extension CategoryTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        TransactionCategory.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryViewCell.reuseIdentifier(), for: indexPath) as? CategoryViewCell else {
            return UITableViewCell()
        }
        
        let category = TransactionCategory.allCases[indexPath.row]
        cell.bind(category)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = TransactionCategory.allCases[indexPath.row]
        didSelectCategory?(selectedCategory)
        
        navigationController?.popViewController(animated: true)
    }
}

//
//  TableOfCategoriesViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 08/09/2023.
//

import UIKit

final class CategoryTableViewController: UITableViewController {
    
    private let categories: [TransactionCategory]
    
    public var didSelectCategory: ((TransactionCategory) -> ())?
    
    init() {
        self.categories = TransactionCategory.allCases
        
        super.init(style: .plain)
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
        tableView.register(CategoryViewCell.self, forCellReuseIdentifier: CategoryViewCell.reuseIdentifier())
        tableView.rowHeight = 70
        tableView.backgroundColor = UIColor(named: "cell")
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Categories"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryViewCell.reuseIdentifier(), for: indexPath) as? CategoryViewCell else {
            return UITableViewCell()
        }
        
        let category = categories[indexPath.row]
        cell.bind(category)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        didSelectCategory?(selectedCategory)
        
        navigationController?.popViewController(animated: true)
    }
}

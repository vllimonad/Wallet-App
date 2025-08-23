//
//  TableOfCategoriesViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 08/09/2023.
//

import UIKit

final class TableOfCategoriesViewController: UITableViewController {
    var selectItem: ((String) -> ())?
    private let cellIdentifier = "category"
    private let backgroundColorName = "cell"
    private let categories = ["Food", "Transportation", "Shopping", "Communication", "Entertainment", "Housing", "Financial expenses"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarTitle()
        configureTableView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CategoryViewCell
        cell.backgroundColor = UIColor(named: backgroundColorName)
        cell.categoryLabel.text = categories[indexPath.row]
        cell.icon.image = UIImage(named: categories[indexPath.row].lowercased())
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectItem!(categories[indexPath.row])
        dismiss(animated: true)
    }
}

extension TableOfCategoriesViewController {
    func setupNavigationBarTitle() {
        title = "Categories"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func configureTableView() {
        tableView.register(CategoryViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 70
        tableView.backgroundColor = UIColor(named: backgroundColorName)
    }
}

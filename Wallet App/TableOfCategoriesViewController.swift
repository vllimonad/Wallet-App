//
//  TableOfCategoriesViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 08/09/2023.
//

import UIKit

enum Category: Codable {
    case groceries
    case transportation
    case shopping
    case entertainment
    case housing
}

class TableOfCategoriesViewController: UITableViewController {
    
    var delegate: TableOfCategoriesViewControllerDelegate?
    var categories = ["Food", "Transportation", "Shopping", "Communication", "Entertainment", "Housing", "Financial expenses"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(CategoryViewCell.self, forCellReuseIdentifier: "category")
        tableView.rowHeight = 70
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath) as! CategoryViewCell
        cell.categoryLabel.text = categories[indexPath.row]
        cell.icon.image = UIImage(named: categories[indexPath.row].lowercased())
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectItem(categories[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true)
    }
    
}

protocol TableOfCategoriesViewControllerDelegate {
    func selectItem(_ item: String)
}

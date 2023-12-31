//
//  TransactionsTableView.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

final class TransactionsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var transactionsList = [[Transaction]]()
    var transactionsTableViewControllerDelegate: TransactionsTableViewControllerDelegate?
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    let tableView: UITableView = {
        let table = UITableView()
        table.register(TransactionCell.self, forCellReuseIdentifier: "cell")
        table.rowHeight = 80
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(named: "cell")
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        transactionsList = transactionsTableViewControllerDelegate!.getTransactionsList()
        tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        transactionsTableViewControllerDelegate!.setTransactionsList(transactionsList)
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TransactionCell
        cell.backgroundColor = UIColor(named: "cell")
        cell.amountLabel.text = "\(transactionsList[indexPath.section][indexPath.row].amount) \(transactionsList[indexPath.section][indexPath.row].currency)"
        cell.categoryLabel.text = transactionsList[indexPath.section][indexPath.row].category
        cell.desciptionLabel.text = transactionsList[indexPath.section][indexPath.row].description
        cell.icon.image = UIImage(named: "\(transactionsList[indexPath.section][indexPath.row].category.lowercased())")
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionsList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return formatter.string(from: transactionsList[section].first?.date ?? Date.now)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipe = UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] _,_,_ in
            self?.transactionsList[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
            if self?.transactionsList[indexPath.section].count == 0 {
                self?.transactionsList.remove(at: indexPath.section)
                tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .top)
            }
        })])
        return swipe
    }
}

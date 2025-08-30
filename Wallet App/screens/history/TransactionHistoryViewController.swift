//
//  TransactionsTableView.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

final class TransactionHistoryViewController: UIViewController {
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private let tableView: UITableView
    
    private let viewModel: TransactionHistoryViewModel
    
    init(viewModel: TransactionHistoryViewModel) {
        self.viewModel = viewModel
        
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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TransactionViewCell.self, forCellReuseIdentifier: TransactionViewCell.reuseIdentifier())
        tableView.rowHeight = 75
        tableView.backgroundColor = UIColor(named: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        viewModel.didUpdateTransactions = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Records"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

extension TransactionHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.transactions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.transactions[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionViewCell.reuseIdentifier(), for: indexPath) as? TransactionViewCell else {
            return UITableViewCell()
        }
        
        let model = viewModel.transactions[indexPath.section].items[indexPath.row]
        cell.bind(model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        formatter.string(from: viewModel.transactions[section].date)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let swipe = UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] _,_,_ in
//            self?.viewModel.transactions[indexPath.section].remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .right)
//            if self?.transactionsList[indexPath.section].count == 0 {
//                self?.transactionsList.remove(at: indexPath.section)
//                tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .top)
//            }
//        })])
//        return swipe
//    }
}

//
//  TransactionsTableView.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

class Day {
    var date: String
    var arr: [Transaction]
    
    init(date: String, arr: [Transaction]) {
        self.date = date
        self.arr = arr
    }
}

class TransactionsTableViewController: UITableViewController {
    
    var multiplier = 1.0
    var transactionsList = [Day]()
    var mainVewController: MainViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Records"
        tableView.backgroundColor = .white
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 60
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsList[section].arr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TransactionCell
        cell.amountLabel.text = "\(transactionsList[indexPath.section].arr[indexPath.row].amount) \(transactionsList[indexPath.section].arr[indexPath.row].currency)"
        cell.categoryLabel.text = transactionsList[indexPath.section].arr[indexPath.row].category
        cell.desciptionLabel.text = transactionsList[indexPath.section].arr[indexPath.row].description
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return transactionsList.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return transactionsList[section].date
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipe = UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] _,_,_ in
            self?.transactionsList[indexPath.section].arr.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
            if self?.transactionsList[indexPath.section].arr.count == 0 {
                self?.transactionsList.remove(at: indexPath.section)
                tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .top)
            }
        })])
        return swipe
    }

    func countSum() -> Double {
        var sum: Double = 0
        for i in transactionsList {
            for transaction in i.arr {
                sum += transaction.amount / transaction.exchangeRate
            }
        }
        return (sum * 100).rounded() / 100
    }
    
    func getValues() -> (String, Int) {
        let a = ("sdv", 5)
        return a
    }
}

extension TransactionsTableViewController: NewTransactionViewControllerDelegate {
    
    func addNewTransaction(_ transaction: Transaction) {
        if let index = transactionsList.firstIndex(where: { $0.date == transaction.date}) {
            transactionsList[index].arr.append(transaction)
        } else {
            transactionsList.append(Day(date: transaction.date, arr: [transaction]))
        }
        mainVewController?.amountLabel.text = "Total: \(countSum()) eur"
        transactionsList.sort(by: { $0.date > $1.date })
        tableView.reloadData()
    }
}

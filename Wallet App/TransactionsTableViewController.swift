//
//  TransactionsTableView.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

class Day: Codable {
    var date: Date
    var arr: [Transaction]
    
    init(date: Date, arr: [Transaction]) {
        self.date = date
        self.arr = arr
    }
}

class TransactionsTableViewController: UITableViewController {
    
    var transactionsList = [Day]()
    var mainVewController: MainViewController?
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Records"
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 80
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
        cell.icon.image = UIImage(named: "\(transactionsList[indexPath.section].arr[indexPath.row].category.lowercased())")
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return transactionsList.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return formatter.string(from: transactionsList[section].date)
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
            self?.updateMainViewController()
        })])
        return swipe
    }

    func getTotalMontnSum() -> Double {
        var sum: Double = 0
        for i in getExpensesByCategories() {
            sum += i.value
        }
        return sum == 0 ? 0 : (sum * 100).rounded() / 100
    }
    
    func getExpensesByCategories() -> [String: Double] {
        let date = mainVewController?.monthLabel.text!.components(separatedBy: " ")
        var values = [String: Double]()
        for day in transactionsList {
            let formattedDate = formatter.string(from: day.date)
            if formattedDate.hasPrefix(date![0]) && formattedDate.hasSuffix(date![1]){
                for transaction in day.arr {
                    if let index = values.index(forKey: transaction.category){
                        values[transaction.category]! += (transaction.amount / transaction.exchangeRate * 100).rounded() / 100
                    } else {
                        values[transaction.category] = (transaction.amount / transaction.exchangeRate * 100).rounded() / 100
                    }
                }
            }
        }
        return values
    }
    
    func updateMainViewController() {
        mainVewController?.updateTotalSum()
        mainVewController?.updateStackView()
        saveData()
    }
    
    func saveData() {
        if let data = try? JSONEncoder().encode(transactionsList){
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: "list")
        }
    }
    
    func readData() {
        let defaults = UserDefaults.standard
        if let data = defaults.object(forKey: "list") as? Data {
            do {
                transactionsList = try JSONDecoder().decode([Day].self, from: data)
            } catch {
                print("reading failed")
            }
        }
        tableView.reloadData()
    }
}

extension TransactionsTableViewController: NewTransactionViewControllerDelegate {
    
    func addNewTransaction(_ transaction: Transaction) {
        if let index = transactionsList.firstIndex(where: { formatter.string(from: $0.date) == formatter.string(from: transaction.date)}) {
            transactionsList[index].arr.append(transaction)
        } else {
            transactionsList.append(Day(date: transaction.date, arr: [transaction]))
        }
        updateMainViewController()
        transactionsList.sort(by: { $0.date > $1.date })
        tableView.reloadData()
    }
}

//
//  TransactionsTableView.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

class TransactionsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var transactionsList = [[Transaction]]()
    var mainVewController: MainViewController?
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
        tableView.backgroundColor = UIColor(named: "background")
        setupLayout()
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
        return formatter.string(from: transactionsList[section][0].date)
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
            let formattedDate = formatter.string(from: day[0].date)
            if formattedDate.hasPrefix(date![0]) && formattedDate.hasSuffix(date![1]){
                for transaction in day {
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
                transactionsList = try JSONDecoder().decode([[Transaction]].self, from: data)
            } catch {
                print("reading failed")
            }
        }
        tableView.reloadData()
    }
}

extension TransactionsTableViewController: NewTransactionViewControllerDelegate {
    
    func addNewTransaction(_ transaction: Transaction) {
        if let index = transactionsList.firstIndex(where: { formatter.string(from: $0[0].date) == formatter.string(from: transaction.date)}) {
            transactionsList[index].append(transaction)
        } else {
            transactionsList.append([transaction])
        }
        updateMainViewController()
        transactionsList.sort(by: { $0[0].date > $1[0].date })
        tableView.reloadData()
    }
}

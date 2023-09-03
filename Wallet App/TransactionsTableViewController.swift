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
    
    var dict: [Day] = {
        var f = [Day]()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        f.append(Day(date: formatter.string(from: Date.distantPast), arr: [Transaction(12, formatter.string(from: Date.now), "Car"), Transaction(52, formatter.string(from: Date.now), "Groceries")]))
        f.append(Day(date: formatter.string(from: Date.now), arr: [Transaction(46, formatter.string(from: Date.now), "Bar"), Transaction(25, formatter.string(from: Date.now), "Care")]))
        f.sort(by: { $0.date < $1.date })
        return f
    }()
    
    /*
    var transactions: [Transaction] = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        print(formatter.string(from: Date.now))
        var transactionsw = [Transaction]()
        transactionsw.append(Transaction(65, formatter.string(from: Date.distantPast), "Groceries"))
        transactionsw.append(Transaction(12, formatter.string(from: Date.now), "Groceries"))
        transactionsw.append(Transaction(23, formatter.string(from: Date.now), "Groceries"))
        transactionsw.append(Transaction(35, formatter.string(from: Date.now), "Groceries"))
        transactionsw.append(Transaction(3, formatter.string(from: Date.now), "Groceries"))
        transactionsw.append(Transaction(29, formatter.string(from: Date.now), "Groceries"))
        transactionsw.append(Transaction(34, formatter.string(from: Date.now), "Groceries"))
        return transactionsw
    }()
    
    var uniqueDays: Set<String> {
        var set = Set<String>()
        for i in transactions {
            set.insert(i.date)
        }
        return set
    }
     */

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 68
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dict[section].arr.count
        /*let arr = Array(uniqueDays)
        let date = arr[section]
        return transactions.lastIndex(where: { $0.date == date })! - transactions.firstIndex(where: { $0.date == date })! + 1
         */
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TransactionCell
        cell.amountLabel.text = " -\(dict[indexPath.section].arr[indexPath.row].amount) pln"
        cell.categoryLabel.text = dict[indexPath.section].arr[indexPath.row].category
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dict.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dict[section].date
    }
    
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

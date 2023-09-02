//
//  TransactionsTableView.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

class TransactionsTableView: UITableViewController {
    
    var transactions: [Transaction] = {
        var transactionsw = [Transaction]()
        transactionsw.append(Transaction(12, Date.now, "Groceries"))
        transactionsw.append(Transaction(23, Date.now, "Groceries"))
        transactionsw.append(Transaction(35, Date.now, "Groceries"))
        transactionsw.append(Transaction(65, Date.now, "Groceries"))
        transactionsw.append(Transaction(3, Date.now, "Groceries"))
        transactionsw.append(Transaction(29, Date.now, "Groceries"))
        transactionsw.append(Transaction(34, Date.now, "Groceries"))
        return transactionsw
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .white

        tableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 68
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell 
        cell.amountLabel.text = "\(transactions[indexPath.row].amount)"
        cell.categoryLabel.text = transactions[indexPath.row].category
        return cell
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

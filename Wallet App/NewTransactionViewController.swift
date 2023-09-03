//
//  NewTransactionViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 03/09/2023.
//

import UIKit

class NewTransactionViewController: UIViewController, UITableViewDataSource {
    
    var options = ["Category", "Currency", "Date", "Notes"]
    
    var amountTextField: UITextField = {
        let textField = UITextField()
        textField.text = "-0"
        textField.textAlignment = .right
        textField.font = UIFont.systemFont(ofSize: 45)
        textField.backgroundColor = .lightGray
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 70
        
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        view.backgroundColor = .white
        title = "Add Record"

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
        
        setupTableView()
        setupLayout()
    }
    func setupTableView() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "k")
        tableView.backgroundColor = .clear
    }
    
    func setupLayout() {
        view.addSubview(amountTextField)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            amountTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            amountTextField.heightAnchor.constraint(equalToConstant: 100),
            
            tableView.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 50),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "k", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }

}

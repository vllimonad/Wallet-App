//
//  NewTransactionViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 03/09/2023.
//

import UIKit

class NewTransactionViewController: UIViewController, UITableViewDataSource {
    
    var options = ["Category", "Date"]
    
    var dollarButton: UIButton = {
        let button = UIButton()
        button.setTitle("USD", for: .normal)
        button.titleLabel?.textColor = .black
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var euroButton: UIButton = {
        let button = UIButton()
        button.setTitle("EUR", for: .normal)
        //button.titleLabel?.font = .boldSystemFont(ofSize: 21)
        button.backgroundColor = .lightGray
        button.titleLabel?.textColor = .black
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var zlotyButton: UIButton = {
        let button = UIButton()
        button.setTitle("PLN", for: .normal)
        button.backgroundColor = .lightGray
        button.titleLabel?.textColor = .black
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
    
    var notesTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Notes"
        textField.backgroundColor = .lightGray
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
        view.addSubview(dollarButton)
        view.addSubview(euroButton)
        view.addSubview(zlotyButton)
        view.addSubview(tableView)
        view.addSubview(notesTextField)

        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            amountTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            amountTextField.heightAnchor.constraint(equalToConstant: 100),
            
            dollarButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
            dollarButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dollarButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.24),
            dollarButton.heightAnchor.constraint(equalToConstant: 40),
            
            euroButton.centerYAnchor.constraint(equalTo: dollarButton.centerYAnchor),
            euroButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            euroButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.24),
            euroButton.heightAnchor.constraint(equalToConstant: 40),
            
            zlotyButton.centerYAnchor.constraint(equalTo: dollarButton.centerYAnchor),
            zlotyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            zlotyButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.24),
            zlotyButton.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: dollarButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -400),
            
            notesTextField.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            notesTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notesTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notesTextField.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -200)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "k", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }

}

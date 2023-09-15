//
//  NewTransactionViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 03/09/2023.
//

import UIKit

enum Currency: Codable{
    case pln
    case usd
    case eur
}

class NewTransactionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var options = ["Category", "Date"]
    var selectedCategory: String?
    var currency = Currency.eur
    var delegateController: NewTransactionViewControllerDelegate?
    
    var dollarButton: UIButton = {
        let button = UIButton()
        button.setTitle("USD", for: .normal)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(dollarButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var euroButton: UIButton = {
        let button = UIButton()
        button.setTitle("EUR", for: .normal)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(euroButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var zlotyButton: UIButton = {
        let button = UIButton()
        button.setTitle("PLN", for: .normal)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(zlotyButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "1234"
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 45)
        textField.backgroundColor = .systemGray4
        textField.layer.cornerRadius = 20
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
    
    var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    var notesTextField: NotesTextField = {
        let textField = NotesTextField(placeholder: "Notes")
        textField.backgroundColor = .systemGray4
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGray3
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 17
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveTransaction), for: .touchUpInside)
        return button
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGray3
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 17
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelTransaction), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Record"
        view.backgroundColor = .white
        
        configureTableView()
        setupLayout()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "option")
        tableView.backgroundColor = .clear
    }
    
    func setupLayout() {
        view.addSubview(amountTextField)
        view.addSubview(dollarButton)
        view.addSubview(euroButton)
        view.addSubview(zlotyButton)
        view.addSubview(tableView)
        view.addSubview(notesTextField)
        view.addSubview(cancelButton)
        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
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
            
            notesTextField.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            notesTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            notesTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            notesTextField.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -200),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            cancelButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.42),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.42),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "option", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        if indexPath.row == 1 {
            cell.contentView.addSubview(datePicker)
            datePicker.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -20).isActive = true
            datePicker.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let table = TableOfCategoriesViewController()
            table.delegate = self
            present(UINavigationController(rootViewController: table), animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func cancelTransaction() {
        dismiss(animated: true)
    }
    
    @objc func saveTransaction() {
        guard let amount = amountTextField.text else { return }
        guard let category = selectedCategory else { return }
        let description = notesTextField.text == nil ? "" : notesTextField.text!
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        var transaction = Transaction(amount: Double(amount)!, currency: currency, date: formatter.string(from: datePicker.date), category: category, description: description, exchangeRate: 1.0)
        getExchangeRate(for: transaction)
        dismiss(animated: true)
    }
    
    func getExchangeRate(for transaction: Transaction) {
        let request = URLRequest(url: URL(string: "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/eur.json")!)
        let task = URLSession.shared.dataTask(with: request) { data,_,error in
        guard let data = data, let rate = try? JSONDecoder().decode(Rate.self, from: data) else { return }
            switch transaction.currency {
            case .usd: transaction.exchangeRate = rate.eur["usd"]!
            case .pln: transaction.exchangeRate = rate.eur["pln"]!
            default: break
            }
            DispatchQueue.main.async { [weak self] in
                self!.delegateController?.addNewTransaction(transaction)
            }
        }
        task.resume()
    }
    
    @objc func dollarButtonTapped() {
        currency = .usd
        dollarButton.backgroundColor = .systemGray
        euroButton.backgroundColor = .systemGray4
        zlotyButton.backgroundColor = .systemGray4
    }
    @objc func euroButtonTapped() {
        currency = .eur
        dollarButton.backgroundColor = .systemGray4
        euroButton.backgroundColor = .systemGray
        zlotyButton.backgroundColor = .systemGray4
    }
    @objc func zlotyButtonTapped() {
        currency = .pln
        dollarButton.backgroundColor = .systemGray4
        euroButton.backgroundColor = .systemGray4
        zlotyButton.backgroundColor = .systemGray
    }
}

extension NewTransactionViewController: TableOfCategoriesViewControllerDelegate {
    func selectedItem(_ item: String) {
        options[0] = item
        selectedCategory = item
        tableView.reloadData()
    }
}

protocol NewTransactionViewControllerDelegate {
    func addNewTransaction(_ transaction: Transaction)
}

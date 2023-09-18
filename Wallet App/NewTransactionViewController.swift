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
    var currency = Currency.eur
    var delegateController: NewTransactionViewControllerDelegate?
    
    var dollarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("USD", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 20
        //button.layer.borderWidth = 1
        //button.layer.borderColor = UIColor.systemGray4.cgColor
        button.addTarget(self, action: #selector(dollarButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var euroButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("EUR", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 20
        //button.layer.borderWidth = 1
        //button.layer.borderColor = UIColor.systemGray4.cgColor
        button.addTarget(self, action: #selector(euroButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var zlotyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PLN", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 20
        //button.layer.borderWidth = 1
        //button.layer.borderColor = UIColor.systemGray4.cgColor
        button.addTarget(self, action: #selector(zlotyButtonTapped), for: .touchUpInside)
    
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "1234.56"
        //textField.layer.borderWidth = 1
        //textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 35)
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 20
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 70
        //tableView.layer.borderWidth = 1
        //tableView.layer.borderColor = UIColor.systemGray4.cgColor
        tableView.layer.cornerRadius = 20
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
        textField.backgroundColor = .systemGray6
        //textField.layer.borderWidth = 1
        //textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGray5
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 17
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveTransaction), for: .touchUpInside)
        return button
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGray5
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 17
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelTransaction), for: .touchUpInside)
        return button
    }()
    
    //MARK: second version of ui
    
    let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.systemGray.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let categoryCellLabel: UILabel = {
        let label = UILabel()
        label.text = "Required"
        label.textColor = .systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupLayout() {
        view.addSubview(backView)
        backView.addSubview(amountTextField)
        backView.addSubview(dollarButton)
        backView.addSubview(euroButton)
        backView.addSubview(zlotyButton)
        backView.addSubview(tableView)
        backView.addSubview(notesTextField)
        backView.addSubview(saveButton)
        backView.addSubview(cancelButton)
                
        NSLayoutConstraint.activate([
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            backView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            
            amountTextField.topAnchor.constraint(equalTo: backView.topAnchor, constant: 20),
            amountTextField.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            amountTextField.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
            amountTextField.heightAnchor.constraint(equalToConstant: 70),
            
            dollarButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
            dollarButton.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 20),
            dollarButton.widthAnchor.constraint(equalTo: backView.widthAnchor, multiplier: 0.24),
            dollarButton.heightAnchor.constraint(equalToConstant: 40),
            
            euroButton.centerYAnchor.constraint(equalTo: dollarButton.centerYAnchor),
            euroButton.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            euroButton.widthAnchor.constraint(equalTo: backView.widthAnchor, multiplier: 0.24),
            euroButton.heightAnchor.constraint(equalToConstant: 40),
            
            zlotyButton.centerYAnchor.constraint(equalTo: dollarButton.centerYAnchor),
            zlotyButton.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20),
            zlotyButton.widthAnchor.constraint(equalTo: backView.widthAnchor, multiplier: 0.24),
            zlotyButton.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: dollarButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
            tableView.heightAnchor.constraint(equalToConstant: 140),
            
            notesTextField.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            notesTextField.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            notesTextField.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
            notesTextField.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -50),
            
            cancelButton.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -20),
            cancelButton.widthAnchor.constraint(equalTo: backView.widthAnchor, multiplier: 0.42),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            
            saveButton.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalTo: backView.widthAnchor, multiplier: 0.42),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Record"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor(named: "background")
        
        configureTableView()
        setupLayout()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "option")
        tableView.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "option", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        cell.backgroundColor = .systemGray6
        if indexPath.row == 1 {
            cell.contentView.addSubview(datePicker)
            datePicker.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -20).isActive = true
            datePicker.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        } else {
            cell.accessoryType = .disclosureIndicator
            cell.contentView.addSubview(categoryCellLabel)
            categoryCellLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -40).isActive = true
            categoryCellLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
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
        guard let category = categoryCellLabel.text, category != "Required" else { return }
        let description = notesTextField.text == nil ? "" : notesTextField.text!
        let transaction = Transaction(amount: Double(amount)!, currency: currency, date: datePicker.date, category: category, description: description, exchangeRate: 1.0)
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
        dollarButton.backgroundColor = .systemGray4
        euroButton.backgroundColor = .systemGray6
        zlotyButton.backgroundColor = .systemGray6
    }
    @objc func euroButtonTapped() {
        currency = .eur
        dollarButton.backgroundColor = .systemGray6
        euroButton.backgroundColor = .systemGray4
        zlotyButton.backgroundColor = .systemGray6
    }
    @objc func zlotyButtonTapped() {
        currency = .pln
        dollarButton.backgroundColor = .systemGray6
        euroButton.backgroundColor = .systemGray6
        zlotyButton.backgroundColor = .systemGray4
    }
}

extension NewTransactionViewController: TableOfCategoriesViewControllerDelegate {
    func selectItem(_ item: String) {
        categoryCellLabel.text = item
        categoryCellLabel.textColor = .black
        tableView.reloadData()
    }
}

protocol NewTransactionViewControllerDelegate {
    func addNewTransaction(_ transaction: Transaction)
}

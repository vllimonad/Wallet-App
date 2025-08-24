//
//  NewTransactionViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 03/09/2023.
//

import UIKit

enum Currency: String, Codable {
    case pln = "PLN"
    case usd = "USD"
    case eur = "EUR"
}

final class AddRecordViewController: UIViewController {
    
    var delegate: NewTransactionViewControllerDelegate?
    var networkManager: NetworkManagerProtocol?
    var selectedCurrency = Currency.pln
    var exchangeRates: [Rate]? {
        didSet {
            saveTransaction()
        }
    }
    
    var usdButton = CustomButton(type: .system)
    var eurButton = CustomButton(type: .system)
    var plnButton = CustomButton(type: .system)
    var saveButton = CustomButton(type: .system)
    var cancelButton = CustomButton(type: .system)
    
    var amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "1234.56"
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
    
    var notesView:UIView = {
        let view = UIView()
        let label: UILabel = {
            let label = UILabel()
            label.text = "Notes"
            label.textColor = .systemGray
            label.frame = CGRect(x: 20, y: 15, width: 70, height: 15)
            return label
        }()
        view.addSubview(label)
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var notesTextView: UITextView = {
        let textField = UITextView()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textColor = UIColor(named: "text")
        textField.backgroundColor = .systemGray6
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //MARK: second version of ui
    
    let contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24
        view.layer.shadowColor = UIColor.systemGray.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.backgroundColor = UIColor(named: "view")
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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        networkManager = NetworkManager()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        setupNavigationBarTitle()
        setupSubviews()
        setupLayout()
        configureTableView()
        configureButtons()
    }
}

extension AddRecordViewController {
    
    func setupNavigationBarTitle() {
        title = "Add Record"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupSubviews() {
        view.addSubview(contentView)
        contentView.addSubview(amountTextField)
        contentView.addSubview(usdButton)
        contentView.addSubview(eurButton)
        contentView.addSubview(plnButton)
        contentView.addSubview(tableView)
        contentView.addSubview(notesView)
        contentView.addSubview(saveButton)
        contentView.addSubview(cancelButton)
        notesView.addSubview(notesTextView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            
            amountTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            amountTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            amountTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            amountTextField.heightAnchor.constraint(equalToConstant: 70),
            
            usdButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
            usdButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            usdButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.24),
            usdButton.heightAnchor.constraint(equalToConstant: 40),
            
            eurButton.centerYAnchor.constraint(equalTo: usdButton.centerYAnchor),
            eurButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            eurButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.24),
            eurButton.heightAnchor.constraint(equalToConstant: 40),
            
            plnButton.centerYAnchor.constraint(equalTo: usdButton.centerYAnchor),
            plnButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            plnButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.24),
            plnButton.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: usdButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            tableView.heightAnchor.constraint(equalToConstant: 140),
        
            notesView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            notesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            notesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            notesView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -50),
            
            notesTextView.topAnchor.constraint(equalTo: notesView.topAnchor, constant: 30),
            notesTextView.leadingAnchor.constraint(equalTo: notesView.leadingAnchor, constant: 15),
            notesTextView.trailingAnchor.constraint(equalTo: notesView.trailingAnchor, constant: -15),
            notesTextView.bottomAnchor.constraint(equalTo: notesView.bottomAnchor, constant: -10),
            
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            cancelButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.42),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.42),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "option")
        tableView.backgroundColor = .clear
    }
    
    func configureButtons() {
        usdButton.configure("USD", .systemGray6, 20)
        eurButton.configure("EUR", .systemGray6, 20)
        plnButton.configure("PLN", .systemGray4, 20)
        saveButton.configure("Save", .systemGray5, 17)
        cancelButton.configure("Cancel", .systemGray5, 17)
        
        usdButton.addTarget(self, action: #selector(usdButtonTapped), for: .touchUpInside)
        eurButton.addTarget(self, action: #selector(eurButtonTapped), for: .touchUpInside)
        plnButton.addTarget(self, action: #selector(plnButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(getExchangeRates), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTransaction), for: .touchUpInside)
    }
    
    @objc func getExchangeRates() {
        networkManager?.fetchRates { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.exchangeRates = response.rates
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.handleError(error)
                }
            }
        }
    }
    
    func handleError(_ error: Error) {
        guard let error = error as? URLError else { return }
        showAlert(with: error.localizedDescription)
    }
    
    func showAlert(with description: String) {
        let ac = UIAlertController(title: "Try again", message: description, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Done", style: .default))
        present(ac, animated: true)
    }
    
    @objc func cancelTransaction() {
        dismiss(animated: true)
    }
    
    @objc func saveTransaction() {
        guard let amountText = amountTextField.text, let amount = Double(amountText) else { return }
        guard let category = categoryCellLabel.text, category != "Required" else { return }
        let description = notesTextView.text ?? ""
        let rate = exchangeRates?.first { $0.code == selectedCurrency.rawValue }
        let rateValue = rate?.mid ?? 1.0
//        delegate?.addTransaction(
//            Transaction(amount: amount,
//                        currency: selectedCurrency,
//                        date: datePicker.date,
//                        category: category,
//                        description: description,
//                        exchangeRate: rateValue))
        dismiss(animated: true)
    }
    
    @objc func usdButtonTapped() {
        selectedCurrency = .usd
        usdButton.backgroundColor = .systemGray4
        eurButton.backgroundColor = .systemGray6
        plnButton.backgroundColor = .systemGray6
    }
    @objc func eurButtonTapped() {
        selectedCurrency = .eur
        usdButton.backgroundColor = .systemGray6
        eurButton.backgroundColor = .systemGray4
        plnButton.backgroundColor = .systemGray6
    }
    @objc func plnButtonTapped() {
        selectedCurrency = .pln
        usdButton.backgroundColor = .systemGray6
        eurButton.backgroundColor = .systemGray6
        plnButton.backgroundColor = .systemGray4
    }
}


extension AddRecordViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "option", for: indexPath)
        cell.backgroundColor = .systemGray6
        if indexPath.row == 1 {
            cell.textLabel?.text = "Date"
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CGFloat.greatestFiniteMagnitude)
            cell.contentView.addSubview(datePicker)
            datePicker.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -20).isActive = true
            datePicker.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        } else {
            cell.textLabel?.text = "Category"
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
            table.selectItem = { [weak self] category in
                self?.categoryCellLabel.text = category
                self?.categoryCellLabel.textColor = UIColor(named: "text")
                self?.tableView.reloadData()
            }
            present(UINavigationController(rootViewController: table), animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

protocol NewTransactionViewControllerDelegate {
    func addTransaction(_ transaction: Transaction)
}

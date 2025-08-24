//
//  NewTransactionViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 03/09/2023.
//

import UIKit

final class AddRecordViewController: UIViewController, UITextFieldDelegate {
    
//    var delegate: NewTransactionViewControllerDelegate?
//    var networkManager: NetworkManagerProtocol?
    var selectedCurrency = TransactionCurrency.pln
    var exchangeRates: [Rate]? {
        didSet {
            //saveTransaction()
        }
    }
    
    var amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "1234.56"
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 30)
        textField.keyboardType = .decimalPad
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
    
    let containerView: UIView = {
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
    
    private let currencyButtonsContainer: UIStackView
    
    private let viewModel: AddRecordViewModel
    
    init() {
        self.currencyButtonsContainer = UIStackView()
        self.viewModel = AddRecordViewModel()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "background")
        
        configureUI()
        configureNavigationBar()
    }
    
    private func configureUI() {
        amountTextField.delegate = self

        configureCurrencyButtons()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "option")
        tableView.backgroundColor = .clear
        
        view.addSubview(containerView)
        
        containerView.addSubview(amountTextField)
        containerView.addSubview(currencyButtonsContainer)
        containerView.addSubview(tableView)
        containerView.addSubview(notesView)
        
        notesView.addSubview(notesTextView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            amountTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            amountTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            amountTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            amountTextField.heightAnchor.constraint(equalToConstant: 70),
            
            currencyButtonsContainer.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
            currencyButtonsContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            currencyButtonsContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            currencyButtonsContainer.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: currencyButtonsContainer.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            tableView.heightAnchor.constraint(equalToConstant: 140),
        
            notesView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            notesView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            notesView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            notesView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            notesView.heightAnchor.constraint(equalToConstant: 100),
            
            notesTextView.topAnchor.constraint(equalTo: notesView.topAnchor, constant: 30),
            notesTextView.bottomAnchor.constraint(equalTo: notesView.bottomAnchor, constant: -30),
            notesTextView.leadingAnchor.constraint(equalTo: notesView.leadingAnchor, constant: 15),
            notesTextView.trailingAnchor.constraint(equalTo: notesView.trailingAnchor, constant: -15),
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Add Record"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.leftBarButtonItem?.tintColor = .red
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
    }
    
    private func configureCurrencyButtons() {
        currencyButtonsContainer.axis = .horizontal
        currencyButtonsContainer.distribution = .fillEqually
        currencyButtonsContainer.spacing = 15
        currencyButtonsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        TransactionCurrency.allCases.forEach { currency in
            let currencyButton = CurrencyButton()
            currencyButton.configure(currency.title)
            currencyButton.tag = currency.rawValue
            currencyButton.addTarget(self, action: #selector(currencyButtonTapped(_:)), for: .touchUpInside)
            
            if currency == .pln {
                currencyButton.setActive()
            }
            
            currencyButtonsContainer.addArrangedSubview(currencyButton)
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 10
    }
    
    @objc func getExchangeRates() {
//        networkManager?.fetchRates { [weak self] result in
//            switch result {
//            case .success(let response):
//                DispatchQueue.main.async {
//                    self?.exchangeRates = response.rates
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    self?.handleError(error)
//                }
//            }
//        }
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
    
    @objc
    private func currencyButtonTapped(_ sender: UIButton) {
        currencyButtonsContainer.arrangedSubviews.forEach { button in
            (button as? CurrencyButton)?.setInactive()
        }
        
        (currencyButtonsContainer.arrangedSubviews[sender.tag] as? CurrencyButton)?.setActive()
        
        selectedCurrency = TransactionCurrency(rawValue: sender.tag) ?? .pln
    }
        
    @objc
    private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc
    private func didTapSaveButton() {
//        guard let amountText = amountTextField.text, let amount = Double(amountText) else { return }
//        guard let category = categoryCellLabel.text, category != "Required" else { return }
//        let description = notesTextView.text ?? ""
//        let rate = exchangeRates?.first { $0.code == selectedCurrency.rawValue }
//        let rateValue = rate?.mid ?? 1.0
//        delegate?.addTransaction(
//            Transaction(amount: amount,
//                        currency: selectedCurrency,
//                        date: datePicker.date,
//                        category: category,
//                        description: description,
//                        exchangeRate: rateValue))
        dismiss(animated: true)
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

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
    
    private let amountTextField: UITextField = {
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
    
    private let currencyButtonsContainer: UIStackView
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let notesView:UIView = {
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
    
    private let notesTextView: UITextView = {
        let textField = UITextView()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textColor = UIColor(named: "text")
        textField.backgroundColor = .systemGray6
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
        
    private let containerView: UIView = {
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
    
    private let categoryValueLabel: UILabel = {
        let label = UILabel()
        label.text = "Required"
        label.textColor = .systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        
        configureUI()
        configureNavigationBar()
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor(named: "background")
        
        amountTextField.delegate = self

        configureCurrencyButtons()
        
        let transactionDetailsView = getTransactionDetailsView()
        
        view.addSubview(containerView)
        
        containerView.addSubview(amountTextField)
        containerView.addSubview(currencyButtonsContainer)
        containerView.addSubview(transactionDetailsView)
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
            
            transactionDetailsView.topAnchor.constraint(equalTo: currencyButtonsContainer.bottomAnchor, constant: 20),
            transactionDetailsView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            transactionDetailsView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
        
            notesView.topAnchor.constraint(equalTo: transactionDetailsView.bottomAnchor, constant: 20),
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
    
    private func getTransactionDetailsView() -> UIView {
        let categoryLabel = UILabel()
        categoryLabel.text = "Category"
        categoryLabel.textColor = UIColor(named: "text")
        
        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImageView.tintColor = .systemGray
        
        let categoryContainerView = UIStackView(arrangedSubviews: [categoryLabel, categoryValueLabel, chevronImageView])
        categoryContainerView.axis = .horizontal
        categoryContainerView.distribution = .fill
        categoryContainerView.alignment = .center
        categoryContainerView.setCustomSpacing(8, after: categoryValueLabel)
        categoryContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCategoryButton)))
        
        let dateLabel = UILabel()
        dateLabel.text = "Date"
        dateLabel.textColor = UIColor(named: "text")
        
        let dateContainerView = UIStackView(arrangedSubviews: [dateLabel, datePicker])
        dateContainerView.axis = .horizontal
        dateContainerView.distribution = .fill
        dateContainerView.alignment = .center
        
        let separatorView = UIView()
        separatorView.backgroundColor = .systemGray4
        
        let detailsStackView = UIStackView(arrangedSubviews: [categoryContainerView, separatorView, dateContainerView])
        detailsStackView.axis = .vertical
        detailsStackView.distribution = .fill
        detailsStackView.spacing = 15
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let detailsContainerView = UIView()
        detailsContainerView.backgroundColor = .systemGray6
        detailsContainerView.layer.cornerRadius = 20
        detailsContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        detailsContainerView.addSubview(detailsStackView)
        
        NSLayoutConstraint.activate([
            detailsStackView.topAnchor.constraint(equalTo: detailsContainerView.topAnchor, constant: 15),
            detailsStackView.bottomAnchor.constraint(equalTo: detailsContainerView.bottomAnchor, constant: -15),
            detailsStackView.leadingAnchor.constraint(equalTo: detailsContainerView.leadingAnchor, constant: 15),
            detailsStackView.trailingAnchor.constraint(equalTo: detailsContainerView.trailingAnchor, constant: -15),
            
            categoryContainerView.heightAnchor.constraint(equalTo: dateContainerView.heightAnchor),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        return detailsContainerView
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
    private func didTapCategoryButton() {
        let categoryTableViewController = CategoryTableViewController()
        categoryTableViewController.didSelectCategory = { [weak self] category in
            self?.categoryValueLabel.text = category.rawValue
            self?.categoryValueLabel.textColor = .systemBlue
        }
        
        navigationController?.pushViewController(categoryTableViewController, animated: true)
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

protocol NewTransactionViewControllerDelegate {
    func addTransaction(_ transaction: Transaction)
}

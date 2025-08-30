//
//  NewTransactionViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 03/09/2023.
//

import UIKit

final class AddTransactionViewController: UIViewController {
    
//    var delegate: NewTransactionViewControllerDelegate?
//    var networkManager: NetworkManagerProtocol?
//    var exchangeRates: [Rate]? {
//        didSet {
//            //saveTransaction()
//        }
//    }
    
    private let amountTextField: UITextField
    
    private let currencyButtonsContainer: UIStackView
    
    private let datePicker: UIDatePicker
    
    private let notesTextView: UITextView
        
    private let containerView: UIView
    
    private let categoryValueLabel: UILabel
    
    private let viewModel: AddRecordViewModel
    
    init() {
        self.containerView = UIView()
        self.amountTextField = UITextField()
        self.categoryValueLabel = UILabel()
        self.currencyButtonsContainer = UIStackView()
        self.datePicker = UIDatePicker()
        self.notesTextView = UITextView()
        
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
        
        containerView.layer.cornerRadius = 24
        containerView.layer.shadowColor = UIColor.systemGray.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 10
        containerView.backgroundColor = UIColor(named: "view")
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        amountTextField.placeholder = "1234.56"
        amountTextField.textAlignment = .center
        amountTextField.font = UIFont.systemFont(ofSize: 30)
        amountTextField.keyboardType = .decimalPad
        amountTextField.backgroundColor = .systemGray6
        amountTextField.layer.cornerRadius = 20
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        
        amountTextField.delegate = self

        configureCurrencyButtons()
        
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(didSelectDate), for: .valueChanged)
        
        let transactionDetailsView = getTransactionDetailsView()
        
        let notesView = getNotesView()
        
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
            notesView.heightAnchor.constraint(equalToConstant: 170),
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
            
            if currency == viewModel.selectedCurrency {
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
        
        categoryValueLabel.text = "Required"
        categoryValueLabel.textColor = .systemRed
        
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
    
    private func getNotesView() -> UIView {
        let notesView = UIView()
        notesView.backgroundColor = .systemGray6
        notesView.layer.cornerRadius = 20
        notesView.translatesAutoresizingMaskIntoConstraints = false
        
        let notesTitleLabel = UILabel()
        notesTitleLabel.text = "Note"
        notesTitleLabel.textColor = .black
        notesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        notesTextView.font = UIFont.systemFont(ofSize: 17)
        notesTextView.textColor = UIColor(named: "text")
        notesTextView.backgroundColor = .systemGray5
        notesTextView.layer.cornerRadius = 20
        notesTextView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        
        notesView.addSubview(notesTextView)
        notesView.addSubview(notesTitleLabel)
        
        NSLayoutConstraint.activate([
            notesTitleLabel.topAnchor.constraint(equalTo: notesView.topAnchor, constant: 8),
            notesTitleLabel.leadingAnchor.constraint(equalTo: notesView.leadingAnchor, constant: 15),
            notesTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: notesView.trailingAnchor),
            
            notesTextView.topAnchor.constraint(equalTo: notesTitleLabel.bottomAnchor, constant: 5),
            notesTextView.bottomAnchor.constraint(equalTo: notesView.bottomAnchor),
            notesTextView.leadingAnchor.constraint(equalTo: notesView.leadingAnchor),
            notesTextView.trailingAnchor.constraint(equalTo: notesView.trailingAnchor),
        ])
        
        return notesView
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
        
        viewModel.selectedCurrency = TransactionCurrency(rawValue: sender.tag) ?? .pln
    }
    
    @objc
    private func didTapCategoryButton() {
        let categoryTableViewController = CategoryTableViewController()
        categoryTableViewController.didSelectCategory = { [weak self] category in
            self?.viewModel.selectedCategory = category
            
            self?.categoryValueLabel.text = category.rawValue
            self?.categoryValueLabel.textColor = .systemBlue
        }
        
        navigationController?.pushViewController(categoryTableViewController, animated: true)
    }
    
    @objc
    private func didSelectDate() {
        viewModel.selectedDate = datePicker.date
    }
        
    @objc
    private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc
    private func didTapSaveButton() {
        guard viewModel.isValidInput() else { return }
        
        viewModel.saveTransaction()
        
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

extension AddTransactionViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 10
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard
            let amountText = amountTextField.text,
            let amount = Double(amountText)
        else { return }

        viewModel.amount = amount
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.note = textView.text
    }
}

protocol NewTransactionViewControllerDelegate {
    func addTransaction(_ transaction: Transaction)
}

//
//  MainViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    var transactionsList = [[Transaction]]()
    var selectedDate = [String: String]()
    var monthIndex = 1
    var yearIndex = 0
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    let monthLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backwardButton: UIButton = {
        var button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        button.setImage(UIImage(systemName: "chevron.backward", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(showPreviousMonth), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let forwardButton: UIButton = {
        var button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        button.setImage(UIImage(systemName: "chevron.forward", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(showNextMonth), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let monthStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.layer.shadowColor = UIColor.systemGray.cgColor
        stack.layer.shadowOpacity = 0.2
        stack.layer.shadowOffset = .zero
        stack.layer.shadowRadius = 10
        stack.backgroundColor = UIColor(named: "view")
        stack.layer.cornerRadius = 13
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let backView: UIView = {
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
    
    var amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 70
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        setupNavigationBar()
        setupSubviews()
        setupLayout()
        setupDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
}

extension MainViewController {
    
    func setupNavigationBar() {
        navigationItem.title = "Statistics"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    func setupSubviews() {
        view.addSubview(monthStackView)
        monthStackView.addArrangedSubview(backwardButton)
        monthStackView.addArrangedSubview(monthLabel)
        monthStackView.addArrangedSubview(forwardButton)
        
        view.addSubview(backView)
        backView.addSubview(amountLabel)
        backView.addSubview(stackView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            backwardButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            forwardButton.widthAnchor.constraint(equalTo: backwardButton.widthAnchor),

            monthStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            monthStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            monthStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            monthStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.04),
            
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            backView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 20),
            backView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),

            amountLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 20),
            amountLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 20),
            
            stackView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 20),
        ])
    }
    
    func setupDate() {
        let index = Calendar.current.component(.month, from: Date())
        selectedDate["Month"] = Calendar.current.standaloneMonthSymbols[index-1]
        selectedDate["Year"] = "\(Calendar.current.component(.year, from: Date()))"
    }
    
    func getTotalSum() -> Double {
        var sum: Double = 0
        for i in getExpensesByCategories() {
            sum += i.value
        }
        return (sum * 100).rounded()/100
    }
    
    func getExpensesByCategories() -> [String: Double] {
        var values = [String: Double]()
        for day in transactionsList {
            if formatter.string(from: day[0].date).contains(selectedDate["Month"]!)
                && formatter.string(from: day[0].date).contains(selectedDate["Year"]!){
                for transaction in day {
                    if values.index(forKey: transaction.category) != nil {
                        values[transaction.category]! += (transaction.amount * transaction.exchangeRate).rounded()
                    } else {
                        values[transaction.category] = (transaction.amount * transaction.exchangeRate).rounded()
                    }
                }
            }
        }
        return values
    }
    
    func updateUI() {
        amountLabel.text = "Total: \(getTotalSum())zł"
        monthLabel.text = selectedDate["Month"]! + " " + selectedDate["Year"]!
        updateBars()
    }
    
    func updateBars() {
        for view in stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        let values = getExpensesByCategories().sorted(by: { $0.value > $1.value } )
        for value in values {
            let bar = BarView()
            bar.amountLabel.text = "\(value.value)"
            bar.categoryLabel.text = value.key
            bar.progressView.setProgress(Float(value.value/values.first!.value), animated: false)
            stackView.addArrangedSubview(bar)
        }
    }
    
    @objc func addButtonTapped() {
        let transactionView = AddRecordViewController()
        transactionView.delegate = self
        transactionView.modalPresentationStyle = .overCurrentContext
        present(UINavigationController(rootViewController: transactionView), animated: true)
    }
    
    @objc func showPreviousMonth() {
        let index = Calendar.current.component(.month, from: Date())
        if index - monthIndex - 1 < 0 {
            yearIndex -= 31_577_600
            monthIndex -= 12
        }
        monthIndex += 1
        selectedDate["Month"] = Calendar.current.standaloneMonthSymbols[index-monthIndex]
        selectedDate["Year"] = "\(Calendar.current.component(.year, from: Date.now.addingTimeInterval(TimeInterval(yearIndex))))"
        updateUI()
    }
    
    @objc func showNextMonth() {
        let index = Calendar.current.component(.month, from: Date())
        if index - monthIndex + 1 > 11 {
            yearIndex += 31_577_600
            monthIndex += 12
        }
        monthIndex -= 1
        selectedDate["Month"] = Calendar.current.standaloneMonthSymbols[index-monthIndex]
        selectedDate["Year"] = "\(Calendar.current.component(.year, from: Date.now.addingTimeInterval(TimeInterval(yearIndex))))"
        updateUI()
    }
}

extension MainViewController: NewTransactionViewControllerDelegate {
    func addTransaction(_ transaction: Transaction) {
        if let index = transactionsList.firstIndex(where: {
            formatter.string(from: $0[0].date) == formatter.string(from: transaction.date) })
        {
            transactionsList[index].insert(transaction, at: 0)
        } else {
            transactionsList.append([transaction])
        }
        transactionsList.sort(by: { $0[0].date > $1[0].date })
        updateUI()
        //DataManager.shared.saveData(transactionsList)
    }
}

extension MainViewController: TransactionsTableViewControllerDelegate {
    
    func getTransactionsList() -> [[Transaction]] {
        return transactionsList
    }
    
    func setTransactionsList(_ list: [[Transaction]]) {
        transactionsList = list
        updateUI()
        //DataManager.shared.saveData(transactionsList)
    }
}

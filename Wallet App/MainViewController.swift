//
//  MainViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit
import Charts

class MainViewController: UIViewController {
    
    var transactionsTableViewController: TransactionsTableViewController?
    var monthIndex = 1
    var yearIndex = 0
    
    let monthLabel: UILabel = {
        var label = UILabel()
        let index = Calendar.current.component(.month, from: Date())
        label.text = "\(Calendar.current.standaloneMonthSymbols[index-1]) \(Calendar.current.component(.year, from: Date()))"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backwardButton: UIButton = {
        var button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        button.setImage(UIImage(systemName: "chevron.backward", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let forwardButton: UIButton = {
        var button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        button.setImage(UIImage(systemName: "chevron.forward", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
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
        title = "Statistics"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTransaction))
        setupLayout()
        updateStackView()
        updateTotalSum()
    }
    
    func setupLayout() {
        view.addSubview(monthStackView)
        monthStackView.addArrangedSubview(backwardButton)
        monthStackView.addArrangedSubview(monthLabel)
        monthStackView.addArrangedSubview(forwardButton)
        view.addSubview(backView)
        backView.addSubview(amountLabel)
        backView.addSubview(stackView)
        
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
    
    @objc func addTransaction() {
        let transactionView = NewTransactionViewController()
        transactionView.modalPresentationStyle = .formSheet
        transactionView.delegateController = transactionsTableViewController
        present(UINavigationController(rootViewController: transactionView), animated: true)
    }
    
    @objc func previousMonth() {
        let index = Calendar.current.component(.month, from: Date())
        if index - monthIndex - 1 < 0 {
            yearIndex -= 31_577_600
            monthIndex -= 12
        }
        monthIndex += 1
        monthLabel.text = "\(Calendar.current.standaloneMonthSymbols[index-monthIndex]) \(Calendar.current.component(.year, from: Date.now.addingTimeInterval(TimeInterval(yearIndex))))"
        updateStackView()
        updateTotalSum()
    }
    
    @objc func nextMonth() {
        let index = Calendar.current.component(.month, from: Date())
        if index - monthIndex + 1 > 11 {
            yearIndex += 31_577_600
            monthIndex += 12
        }
        monthIndex -= 1
        monthLabel.text = "\(Calendar.current.standaloneMonthSymbols[index-monthIndex]) \(Calendar.current.component(.year, from: Date.now.addingTimeInterval(TimeInterval(yearIndex))))"
        updateStackView()
        updateTotalSum()
    }

    func updateStackView() {
        for view in stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        let values = transactionsTableViewController!.getExpensesByCategories().sorted(by: { $0.value > $1.value } )
        for value in values {
            let bar = Bar()
            bar.amountLabel.text = "\(value.value)"
            bar.categoryLabel.text = value.key
            bar.progressView.setProgress(Float(value.value/values.first!.value), animated: false)
            stackView.addArrangedSubview(bar)
        }
    }
    
    func updateTotalSum() {
        amountLabel.text = "Total: €\(transactionsTableViewController?.getTotalMontnSum() ?? 0.0)"
    }
}

class Bar: UIView {
    
    let categoryLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var amountLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var progressView: UIProgressView = {
        var progress = UIProgressView()
        progress.progressViewStyle = .default
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(categoryLabel)
        addSubview(amountLabel)
        addSubview(progressView)
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: topAnchor),
            categoryLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            amountLabel.topAnchor.constraint(equalTo: topAnchor),
            amountLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),

            progressView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5),
            progressView.heightAnchor.constraint(equalToConstant: 15),
            progressView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
}

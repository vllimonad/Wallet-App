//
//  MainViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit
import Charts

class MainViewController: UIViewController {
    
    var transactionsTableViewDelegate: TransactionsTableViewController?
    var monthIndex = 1
    var yearIndex = 0
    
    var monthLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .systemGray6
        let index = Calendar.current.component(.month, from: Date())
        label.text = "\(Calendar.current.standaloneMonthSymbols[index-1]) \(Calendar.current.component(.year, from: Date()))"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var backwardButton: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGray6
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        button.setImage(UIImage(systemName: "chevron.backward", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var forwardButton: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGray6
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        button.setImage(UIImage(systemName: "chevron.forward", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.text = "Total: 0.0 eur"
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
        view.backgroundColor = UIColor.systemBackground
        title = "Statistics"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTransaction))
        
        setupLayout()
        updateStackView()
    }
    
    func setupLayout() {
        view.addSubview(amountLabel)
        view.addSubview(backwardButton)
        view.addSubview(forwardButton)
        view.addSubview(monthLabel)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            backwardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backwardButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            backwardButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            backwardButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.04),
            
            forwardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            forwardButton.centerYAnchor.constraint(equalTo: backwardButton.centerYAnchor),
            forwardButton.widthAnchor.constraint(equalTo: backwardButton.widthAnchor),
            forwardButton.heightAnchor.constraint(equalTo: backwardButton.heightAnchor),
            
            monthLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            monthLabel.centerYAnchor.constraint(equalTo: backwardButton.centerYAnchor),
            monthLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            monthLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.04),

            amountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            amountLabel.topAnchor.constraint(equalTo: backwardButton.bottomAnchor, constant: 20),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 30),
        ])
    }
    
    @objc func addTransaction() {
        let transactionView = NewTransactionViewController()
        transactionView.modalPresentationStyle = .formSheet
        transactionView.delegateController = transactionsTableViewDelegate
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
        let values = transactionsTableViewDelegate!.getValues().sorted(by: { $0.value > $1.value } )
        for value in values {
            let bar = Bar()
            bar.amountLabel.text = "\(value.value)"
            bar.categoryLabel.text = value.key
            bar.progressView.setProgress(Float(value.value/values.first!.value), animated: false)
            stackView.addArrangedSubview(bar)
        }
    }
    
    func updateTotalSum() {
        amountLabel.text = "Total: \(transactionsTableViewDelegate?.countSum() ?? 0) eur"
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

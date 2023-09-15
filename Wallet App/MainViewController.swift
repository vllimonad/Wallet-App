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
    
    let monthLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .systemBackground
        let index = Calendar.current.component(.month, from: Date())
        label.text = "\(Calendar.current.standaloneMonthSymbols[index-1]) \(Calendar.current.component(.year, from: Date()))"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backwardButton: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBackground
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        button.setImage(UIImage(systemName: "chevron.backward", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let forwardButton: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBackground
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        button.setImage(UIImage(systemName: "chevron.forward", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.systemGray.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
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
        view.backgroundColor = UIColor(named: "background")
        //view.backgroundColor = UIColor.systemBackground
        title = "Statistics"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTransaction))
        
        setupLayout()
        updateStackView()
    }
    
    func setupLayout() {
        view.addSubview(backwardButton)
        view.addSubview(forwardButton)
        view.addSubview(monthLabel)
        view.addSubview(backView)
        backView.addSubview(amountLabel)
        backView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            backwardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backwardButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
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
            
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            backView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 20),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),

            amountLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 20),
            amountLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 20),
            
            stackView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20),
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
        //progress.progressTintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
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

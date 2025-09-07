//
//  BarView.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 24/09/2023.
//

import UIKit

final class StatisticViewCell: UITableViewCell {
    
    public static func reuseIdentifier() -> String {
        "\(Self.self)"
    }
    
    private let categoryLabel: UILabel
    
    private let amountLabel: UILabel
    
    private let progressView: UIProgressView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.categoryLabel = UILabel()
        self.amountLabel = UILabel()
        self.progressView = UIProgressView()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        progressView.layer.cornerRadius = 8
        progressView.clipsToBounds = true
        progressView.progressViewStyle = .default
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(categoryLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            categoryLabel.bottomAnchor.constraint(equalTo: amountLabel.bottomAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            amountLabel.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -10),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            amountLabel.leadingAnchor.constraint(greaterThanOrEqualTo: categoryLabel.trailingAnchor, constant: 20),

            progressView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            progressView.heightAnchor.constraint(equalToConstant: 16),
            progressView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    func bind(_ model: CategoryExpense, _ totalExpenses: Double) {
        categoryLabel.text = String(localized: model.category.description)
        
        amountLabel.text = model.amount.description
        
        progressView.setProgress(Float(model.amount / totalExpenses), animated: false)
    }
}


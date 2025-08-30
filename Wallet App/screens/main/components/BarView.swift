//
//  BarView.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 24/09/2023.
//

import UIKit

final class BarView: UIView {
    
     let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     let progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.layer.cornerRadius = 8
        progress.clipsToBounds = true
        progress.progressViewStyle = .default
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(categoryLabel)
        addSubview(amountLabel)
        addSubview(progressView)
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: amountLabel.topAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            amountLabel.topAnchor.constraint(equalTo: topAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            amountLabel.leadingAnchor.constraint(greaterThanOrEqualTo: categoryLabel.trailingAnchor, constant: 20),

            progressView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            progressView.heightAnchor.constraint(equalToConstant: 16),
            progressView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
}


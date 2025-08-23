//
//  BarView.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 24/09/2023.
//

import UIKit

class BarView: UIView {
    
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
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        addSubview(categoryLabel)
        addSubview(amountLabel)
        addSubview(progressView)
    }
    
    func setupLayout() {
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


//
//  CustomCell.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

final class TransactionCell: UITableViewCell {
    
    var amountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var categoryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var desciptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var icon: UIImageView = {
        let icon = UIImageView()
        icon.layer.cornerRadius = 25
        icon.contentMode = .center
        icon.backgroundColor = UIColor(named: "background")
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        addSubview(icon)
        addSubview(categoryLabel)
        addSubview(desciptionLabel)
        addSubview(amountLabel)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            icon.widthAnchor.constraint(equalToConstant: 50),
            icon.heightAnchor.constraint(equalToConstant: 50),
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            categoryLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            desciptionLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            desciptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5),
            
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

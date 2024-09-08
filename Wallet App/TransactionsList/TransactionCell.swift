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
        icon.layer.cornerRadius = 22.5
        icon.contentMode = .center
        icon.backgroundColor = UIColor(named: "background")
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        stack.addArrangedSubview(categoryLabel)
        stack.addArrangedSubview(desciptionLabel)
        addSubview(stack)
        addSubview(icon)
        addSubview(amountLabel)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            icon.widthAnchor.constraint(equalToConstant: 45),
            icon.heightAnchor.constraint(equalToConstant: 45),
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            stack.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

//
//  CategoryViewCell.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 08/09/2023.
//

import UIKit

final class CategoryViewCell: UITableViewCell {
    
    var icon: UIImageView = {
        let icon = UIImageView()
        icon.backgroundColor = UIColor(named: "background")
        icon.contentMode = .center
        icon.layer.cornerRadius = 25
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    var categoryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.layer.borderColor = UIColor.black.cgColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoryViewCell {
    
    func setupSubviews() {
        addSubview(icon)
        addSubview(categoryLabel)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            icon.widthAnchor.constraint(equalToConstant: 50),
            icon.heightAnchor.constraint(equalToConstant: 50),
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            categoryLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 15),
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

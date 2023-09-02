//
//  CustomCell.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

class CustomCell: UITableViewCell {
    
    var amountLabel: UILabel!
    var categoryLabel: UILabel!
    var icon: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        amountLabel = UILabel()
        amountLabel.layer.borderWidth = 1
        amountLabel.layer.borderColor = UIColor.black.cgColor
        addSubview(amountLabel)
        
        categoryLabel = UILabel()
        categoryLabel.layer.borderWidth = 1
        categoryLabel.layer.borderColor = UIColor.black.cgColor
        addSubview(categoryLabel)
        
        icon = UIImageView()
        icon.layer.borderWidth = 1
        icon.layer.borderColor = UIColor.black.cgColor
        addSubview(icon)
        
        NSLayoutConstraint.activate([
            icon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            amountLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10),
            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            categoryLabel.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 10),
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

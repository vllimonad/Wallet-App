//
//  CustomCell.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

class CustomCell: UITableViewCell {
    
    var amountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var categoryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    var icon: UIImageView = {
//        let icon = UIImageView()
//        icon.layer.borderWidth = 1
//        icon.layer.borderColor = UIColor.black.cgColor
//        return icon
//    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    func setupLayout() {
        amountLabel.text = "spivub"
        addSubview(amountLabel)
        addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            

        ])
    }
}

//
//  CustomCell.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

final class TransactionViewCell: UITableViewCell {
    
    public static func reuseIdentifier() -> String {
        return "\(Self.self)"
    }
            
    private let categoryImageView: UIImageView
    
    private let categoryLabel: UILabel
    
    private let amountLabel: UILabel

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.categoryImageView = UIImageView()
        self.categoryLabel = UILabel()
        self.amountLabel = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        categoryImageView.image = nil
        categoryLabel.text = nil
        amountLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        categoryImageView.layer.cornerRadius = categoryImageView.bounds.width / 2
    }
    
    private func configureUI() {
        contentView.backgroundColor = UIColor(resource: .cell)
        
        categoryImageView.contentMode = .center
        categoryImageView.backgroundColor = UIColor(resource: .background)
        
        amountLabel.numberOfLines = 1
        amountLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        categoryLabel.numberOfLines = 1
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        let containerView = UIStackView(arrangedSubviews: [categoryImageView, categoryLabel, amountLabel])
        containerView.axis = .horizontal
        containerView.alignment = .center
        containerView.distribution = .fill
        containerView.setCustomSpacing(10, after: categoryImageView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            categoryImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            categoryImageView.widthAnchor.constraint(equalTo: categoryImageView.heightAnchor)
        ])
    }
    
    public func bind(_ model: TransactionModel) {
        let categoryImageResource = TransactionDataSource.getCategoryImageResource(model.category)
        categoryImageView.image = UIImage(resource: categoryImageResource)
        
        categoryLabel.text = model.category.rawValue
        
        amountLabel.text = model.amount.description
    }
}

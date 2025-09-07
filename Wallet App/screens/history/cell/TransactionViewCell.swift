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
    
    private let imageContainer: UIView
    
    private let categoryLabel: UILabel
    
    private let amountLabel: UILabel

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.categoryImageView = UIImageView()
        self.imageContainer = UIView()
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
        
        imageContainer.layer.cornerRadius = imageContainer.bounds.width / 2
    }
    
    private func configureUI() {
        contentView.backgroundColor = UIColor(resource: .cell)
                
        categoryImageView.preferredSymbolConfiguration = .init(pointSize: 20)
        categoryImageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageContainer.backgroundColor = UIColor(resource: .background)
        
        amountLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        let containerView = UIStackView(arrangedSubviews: [imageContainer, categoryLabel, amountLabel])
        containerView.axis = .horizontal
        containerView.alignment = .center
        containerView.setCustomSpacing(10, after: imageContainer)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerView)
        
        imageContainer.addSubview(categoryImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            imageContainer.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            imageContainer.widthAnchor.constraint(equalTo: imageContainer.heightAnchor),
            
            categoryImageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            categoryImageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor)
        ])
    }
    
    func bind(_ model: TransactionModel) {
        let categoryImageName = TransactionDataSource.getCategorySystemImageName(model.category)
        categoryImageView.image = UIImage(systemName: categoryImageName)
        
        categoryLabel.text = String(localized: model.category.description)
        
        amountLabel.text = "\(model.amount) \(model.currency.title)"
    }
}

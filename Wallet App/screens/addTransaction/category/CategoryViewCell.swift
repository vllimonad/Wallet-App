//
//  CategoryViewCell.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 08/09/2023.
//

import UIKit

final class CategoryViewCell: UITableViewCell {
    
    public static func reuseIdentifier() -> String {
        "\(Self.self)"
    }
    
    private var categoryImageView: UIImageView
    
    private var categoryLabel: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.categoryImageView = UIImageView()
        self.categoryLabel = UILabel()
        
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        categoryImageView.layer.cornerRadius = categoryImageView.bounds.width / 2
    }

    private func configureUI() {
        contentView.backgroundColor = UIColor(resource: .cell)
        
        categoryImageView.contentMode = .center
        categoryImageView.backgroundColor = UIColor(resource: .background)
        
        categoryLabel.numberOfLines = 1
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        let containerView = UIStackView(arrangedSubviews: [categoryImageView, categoryLabel])
        containerView.axis = .horizontal
        containerView.alignment = .center
        containerView.spacing = 10
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
    
    public func bind(_ category: TransactionCategory) {
        let categoryImageResource = TransactionDataSource.getCategoryImageResource(category)
        categoryImageView.image = UIImage(resource: categoryImageResource)
        
        categoryLabel.text = category.rawValue
    }
}

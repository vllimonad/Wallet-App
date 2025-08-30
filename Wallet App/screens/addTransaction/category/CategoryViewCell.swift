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
        contentView.backgroundColor = UIColor(named: "cell")
        
        categoryImageView.backgroundColor = UIColor(named: "background")
        categoryImageView.contentMode = .center
        categoryImageView.translatesAutoresizingMaskIntoConstraints = false
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(categoryImageView)
        contentView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            categoryImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoryImageView.widthAnchor.constraint(equalToConstant: 50),
            categoryImageView.heightAnchor.constraint(equalTo: categoryImageView.widthAnchor),
            categoryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            categoryLabel.leadingAnchor.constraint(equalTo: categoryImageView.trailingAnchor, constant: 15),
            categoryLabel.centerYAnchor.constraint(equalTo: categoryImageView.centerYAnchor)
        ])
    }
    
    public func bind(_ category: TransactionCategory) {
        let categoryImageResource = TransactionDataSource.getCategoryImageResource(category)
        categoryImageView.image = UIImage(resource: categoryImageResource)
        
        categoryLabel.text = category.rawValue
    }
}

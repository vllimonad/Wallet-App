//
//  EmptyStatisticView.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 31/08/2025.
//

import UIKit

final class EmptyStatisticView: UIView {
    
    private let titleLabel: UILabel
    
    private let iconImageView: UIImageView
    
    init() {
        self.titleLabel = UILabel()
        self.iconImageView = UIImageView()
        
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        let iconImage = UIImage(resource: .emptyStatistic).withRenderingMode(.alwaysTemplate)
        iconImageView.image = iconImage

        titleLabel.text = "No transactions in this month"
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = UIColor(resource: .text)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        let contentContainer = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        contentContainer.axis = .vertical
        contentContainer.alignment = .center
        contentContainer.spacing = 20
        contentContainer.translatesAutoresizingMaskIntoConstraints = false

        addSubview(contentContainer)
        
        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            contentContainer.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            contentContainer.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            contentContainer.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            contentContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 70),
            iconImageView.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
}

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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        titleLabel.font = .systemFont(ofSize: 17, weight: .medium)
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
            contentContainer.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    public func bind(_ title: String, _ iconImageResource: ImageResource) {
        titleLabel.text = title
        
        iconImageView.image = UIImage(resource: iconImageResource)
    }
}

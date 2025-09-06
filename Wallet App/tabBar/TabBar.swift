//
//  TabBar.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 23/08/2025.
//

import UIKit

final class TabBar: UITabBar {
    
    private let mainButton: UIButton
    
    private let addRecordButton: UIButton
    
    private let historyButton: UIButton
    
    public var didTapAddRecord: (() -> Void)?
    
    init() {
        self.mainButton = UIButton()
        self.addRecordButton = UIButton()
        self.historyButton = UIButton()
        
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        mainButton.configuration = getTabButtonConfiguration("Statistics", "chart.pie")
        mainButton.tag = TabBarTag.main.rawValue
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        
        addRecordButton.configuration = getTabButtonConfiguration(nil, "plus.circle")
        addRecordButton.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 30)
        addRecordButton.tag = TabBarTag.addRecord.rawValue
        addRecordButton.addTarget(self, action: #selector(didTapAddRecordButton), for: .touchUpInside)
        addRecordButton.translatesAutoresizingMaskIntoConstraints = false
        
        historyButton.configuration = getTabButtonConfiguration("History", "list.clipboard")
        historyButton.tag = TabBarTag.history.rawValue
        historyButton.translatesAutoresizingMaskIntoConstraints = false
        
        let containerView = UIStackView(arrangedSubviews: [mainButton, addRecordButton, historyButton])
        containerView.axis = .horizontal
        containerView.distribution = .fillEqually
        containerView.alignment = .top
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func getTabButtonConfiguration(_ title: String?, _ systemImageName: String) -> UIButton.Configuration {
        var buttonConfiguration = UIButton.Configuration.plain()
        
        if let title {
            buttonConfiguration.attributedTitle = AttributedString(title, attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 13, weight: .medium)
            ]))
        }
        
        buttonConfiguration.image = UIImage(systemName: systemImageName)
        buttonConfiguration.imagePlacement = .top
        buttonConfiguration.imagePadding = 6
        
        return buttonConfiguration
    }
    
    public func updateButtonsState(_ selectedIndex: Int) {
        let isMainSelected = selectedIndex == mainButton.tag
        let mainButtonImageSystemName = isMainSelected ? "chart.bar.fill" : "chart.bar"
        mainButton.configuration?.image = UIImage(systemName: mainButtonImageSystemName)
        
        let isHistorySelected = selectedIndex == historyButton.tag
        let historyButtonImageSystemName = isHistorySelected ? "newspaper.fill" : "newspaper"
        historyButton.configuration?.image = UIImage(systemName: historyButtonImageSystemName)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !isHidden, alpha != 0.0 else {
            return super.hitTest(point, with: event)
        }
        
        guard addRecordButton.frame.contains(point) else {
            return super.hitTest(point, with: event)
        }
        
        return addRecordButton
    }
    
    @objc
    private func didTapAddRecordButton() {
        didTapAddRecord?()
    }
}


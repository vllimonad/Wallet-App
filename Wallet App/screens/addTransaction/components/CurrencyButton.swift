//
//  CurrnecyButton.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 28/08/2024.
//

import UIKit

class CurrencyButton: UIButton {
    
    private let activeBackgroundColor: UIColor
    
    private let activeTitleColor: UIColor
    
    private let inactiveBackgoundColor: UIColor
    
    private let inactiveTitleColor: UIColor
    
    init(activeBackgroundColor: UIColor = .systemBlue,
         activeTitleColor: UIColor = .white,
         inactiveBackgoundColor: UIColor = .systemGray6,
         inactiveTitleColor: UIColor = UIColor(resource: .text)) {
        self.activeBackgroundColor = activeBackgroundColor
        self.activeTitleColor = activeTitleColor
        self.inactiveBackgoundColor = inactiveBackgoundColor
        self.inactiveTitleColor = inactiveTitleColor
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
    }
    
    public func configure(_ title: String) {
        let attributedTitle = NSAttributedString(string: title,
                                                 attributes: [
                                                   .font: UIFont.systemFont(ofSize: 16)
                                                 ])
        setAttributedTitle(attributedTitle, for: .normal)
        setTitleColor(inactiveTitleColor, for: .normal)
        backgroundColor = inactiveBackgoundColor
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func setActive() {
        setTitleColor(activeTitleColor, for: .normal)
        backgroundColor = activeBackgroundColor
    }
    
    public func setInactive() {
        setTitleColor(inactiveTitleColor, for: .normal)
        backgroundColor = inactiveBackgoundColor
    }
}

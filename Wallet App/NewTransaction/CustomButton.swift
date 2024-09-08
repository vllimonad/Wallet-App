//
//  CurrnecyButton.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 28/08/2024.
//

import UIKit

class CustomButton: UIButton {
    
    var delegate: CurrencyButtonDelegate?
    
    func configure(_ title: String, _ background: UIColor, _ cornerRadius: CGFloat) {
        setTitle(title, for: .normal)
        setTitleColor(UIColor(named: "text"), for: .normal)
        backgroundColor = background
        layer.cornerRadius = cornerRadius
        translatesAutoresizingMaskIntoConstraints = false
    }
}

protocol CurrencyButtonDelegate {
    
    func buttonTapped()
}

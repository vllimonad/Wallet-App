//
//  UIView + Shadow.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 04/09/2025.
//

import UIKit

extension UIView {
    
    func applyCustomShadow() {
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 15
    }
}

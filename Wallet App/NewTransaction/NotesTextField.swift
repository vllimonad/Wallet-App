//
//  NotesTextField.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 04/09/2023.
//

import UIKit

final class NotesTextField: UITextField {

    let padding = UIEdgeInsets(top: -110, left: 20, bottom: 0, right: 20)
    
    init(placeholder: String) {
        super.init(frame: .zero)
        setupTextField(placeholder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func setupTextField(_ placeholder: String) {
        textColor = UIColor(named: "text")
        layer.cornerRadius = 20
        attributedPlaceholder = NSAttributedString(string: placeholder)
    }
}

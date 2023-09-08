//
//  Transaction.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

class Transaction {
    var amount: Int
    var date: String
    var category: String
    var description: String
    
    init(amount: Int, date: String, category: String, description: String) {
        self.amount = amount
        self.date = date
        self.category = category
        self.description = description
    }
}

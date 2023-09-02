//
//  Transaction.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

class Transaction {
    var amount: Int
    var date: Date
    var category: String
    
    init(_ amount: Int, _ date: Date, _ category: String) {
        self.amount = amount
        self.date = date
        self.category = category
    }
}

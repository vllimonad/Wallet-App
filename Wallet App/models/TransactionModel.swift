//
//  Transaction.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit
import SwiftData

@Model
class TransactionModel {
    
    var amount: Double
    
    var currency: Currency
    
    var date: Date
    
    var category: String
    
    var note: String
    
    var exchangeRate: Double
    
    init(amount: Double,
         currency: Currency,
         date: Date,
         category: String,
         note: String,
         exchangeRate: Double) {
        self.amount = amount
        self.currency = currency
        self.date = date
        self.category = category
        self.note = note
        self.exchangeRate = exchangeRate
    }
}

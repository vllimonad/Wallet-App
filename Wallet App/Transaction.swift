//
//  Transaction.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

final class Transaction: Codable {
    var amount: Double
    var currency: Currency
    var date: Date
    var category: String
    var description: String
    var exchangeRate: Double
    
    init(amount: Double, currency: Currency, date: Date, category: String, description: String, exchangeRate: Double) {
        self.amount = amount
        self.currency = currency
        self.date = date
        self.category = category
        self.description = description
        self.exchangeRate = exchangeRate
    }
}

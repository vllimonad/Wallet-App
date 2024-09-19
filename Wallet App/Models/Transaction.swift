//
//  Transaction.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

struct Transaction: Codable {
    var amount: Double
    var currency: Currency
    var date: Date
    var category: String
    var description: String
    var exchangeRate: Double
}

//
//  TranscationCategory.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 24/08/2025.
//

import Foundation

enum TransactionCategory: String, Codable, CaseIterable {
    case food = "Food"
    case transportation = "Transportation"
    case shopping = "Shopping"
    case communication = "Communication"
    case entertainment = "Entertainment"
    case housing = "Housing"
    case financialExpenses = "Financial Expenses"
}

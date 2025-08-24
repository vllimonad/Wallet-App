//
//  TranscationCategory.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 24/08/2025.
//

import Foundation

enum TransactionCategory: String, Codable, CaseIterable {
    case food, transportation, shopping, communication, entertainment, housing, financialExpenses
}

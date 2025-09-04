//
//  TransactionCurrency.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 24/08/2025.
//

import Foundation

enum TransactionCurrency: Int, CaseIterable, Codable {
    
    case pln, eur, usd
    
    var title: String {
        switch self {
        case .pln: return "PLN"
        case .usd: return "USD"
        case .eur: return "EUR"
        }
    }
}

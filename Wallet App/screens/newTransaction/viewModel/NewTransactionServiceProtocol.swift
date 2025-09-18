//
//  AddTransactionServiceProtocol.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 18/09/2025.
//

import Foundation

protocol NewTransactionServiceProtocol {
    
    @MainActor
    func addTransaction(_ transaction: TransactionModel) async
}

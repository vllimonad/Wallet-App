//
//  TransactionService.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 30/08/2025.
//

import Foundation

final class TransactionService {
    
    private let storage: TransactionStorage
    
    private(set) var transactions: [TransactionModel]
    
    init() {
        self.storage = TransactionStorage()
        self.transactions = []
        
        fetchTransactions()
    }
    
    private func fetchTransactions() {
        Task {
            self.transactions = await storage.getModels()
        }
    }
    
    public func addTransaction(_ transaction: TransactionModel) {
        Task {
            
        }
    }
}

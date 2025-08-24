//
//  MainViewModel.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 24/08/2025.
//

import Foundation

final class MainViewModel {
    
    private(set) var transactions: [TransactionModel]
    
    init() {
        self.transactions = []
        loadTransactions()
    }
    
    public func loadTransactions() {
        Task {
            let storage = TranscationStorage()
            self.transactions = await storage.getModels()
        }
    }
    
    public func getExpensesByCategory() -> [TransactionCategory: Double] {
        let transactionsByCategory = Dictionary(grouping: transactions, by: { $0.category })
        let sumByCategory = transactionsByCategory.mapValues { transactions in
            var sum = 0.0
            
            transactions.forEach { transaction in
                sum += transaction.amount
            }
            
            return sum
        }
        
        return sumByCategory
    }
}

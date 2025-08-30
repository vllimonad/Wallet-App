//
//  MainViewModel.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 24/08/2025.
//

import Foundation

final class MainViewModel: TransactionServiceObserver {
    
    private let transactionService: TransactionService
    
    private(set) var transactions: [TransactionModel]
    
    init(_ transactionService: TransactionService) {
        self.transactionService = transactionService
        self.transactions = transactionService.transactions
        
        self.transactionService.observers.add(self)
    }
    
    deinit {
        self.transactionService.observers.remove(self)
    }
    
    func updatedTransactionsList() {
        self.transactions = transactionService.transactions
    }
    
//    public func loadTransactions() {
//        Task {
//            let storage = TransactionStorage()
//            self.transactions = await storage.getModels()
//        }
//    }
    
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

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
    
    public var observers = NSHashTable<TransactionServiceObserver>.weakObjects()
    
    init() {
        self.storage = TransactionStorage()
        self.transactions = []
        
        fetchTransactions()
    }
    
    private func fetchTransactions() {
        Task {
            self.transactions = await storage.getModels()
            observers.allObjects.forEach { $0.updatedTransactionsList() }
        }
    }
    
    public func addTransaction(_ transaction: TransactionModel) {
        Task {
            do {
                try await storage.addModel(transaction)
                observers.allObjects.forEach { $0.updatedTransactionsList() }
            } catch {
                print(error)
            }
        }
    }
}

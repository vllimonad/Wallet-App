//
//  TransactionService.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 30/08/2025.
//

import Foundation

final class TransactionService {
    
    private let storage: TransactionStorage
    
    private let exchangeRateService: ExchangeRateService
    
    private(set) var transactions: [TransactionModel]
    
    public var observers = NSHashTable<TransactionServiceObserver>.weakObjects()
    
    init() {
        self.storage = TransactionStorage()
        self.exchangeRateService = ExchangeRateService()
        self.transactions = []
        
        fetchTransactions()
    }
    
    private func fetchTransactions() {
        Task {
            self.transactions = await storage.getModels()
            observers.allObjects.forEach { $0.didAddTransaction() }
        }
    }
    
    func addTransaction(_ transaction: TransactionModel) {
        Task {
            do {
                if transaction.currency != .pln {
                    let transactionCurrency = transaction.currency.title
                    let exchangeDate = getExchageDate(transaction.date)
                    let exchangeDateString = formatDateToString(exchangeDate)
                    
                    transaction.exchangeRate = try await exchangeRateService.fetchRates(transactionCurrency, exchangeDateString)
                } else {
                    transaction.exchangeRate = 1.0
                }
                
                try await storage.addModel(transaction)
                transactions.append(transaction)
                
                observers.allObjects.forEach { $0.didAddTransaction() }
            } catch {
                print(error)
            }
        }
    }
    
    func removeTransaction(_ transaction: TransactionModel) {
        Task {
            guard let transactionIndex = transactions.firstIndex(of: transaction) else { return }
            
            try await storage.deleteModel(transaction)
            transactions.remove(at: transactionIndex)
            
            observers.allObjects.forEach { $0.didRemoveTransaction?() }
        }
    }
    
    private func getExchageDate(_ date: Date) -> Date {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) || calendar.startOfDay(for: date) > calendar.startOfDay(for: .now) {
            return calendar.date(byAdding: .day, value: -1, to: .now)!
        } else {
            return date
        }
    }
    
    private func formatDateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: date)
    }
}

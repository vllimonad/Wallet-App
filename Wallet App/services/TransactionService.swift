//
//  TransactionService.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 30/08/2025.
//

import Foundation

final class TransactionService: NewTransactionServiceProtocol, HistoryTransactionServiceProtocol, StatisticsTransactionServiceProtocol {
    
    private let storage: TransactionStorageProtocol
    
    private let exchangeRateService: ExchangeRateServiceProtocol
    
    private(set) var transactions: [TransactionModel]
    
    public var observers = NSHashTable<TransactionServiceObserver>.weakObjects()
    
    init(storage: TransactionStorageProtocol = TransactionStorage(),
         exchangeRateService: ExchangeRateServiceProtocol = ExchangeRateService()) {
        self.storage = storage
        self.exchangeRateService = exchangeRateService
        self.transactions = []
        
        fetchTransactions()
    }
    
    private func fetchTransactions() {
        Task { @MainActor in
            self.transactions = storage.getModels()
            observers.allObjects.forEach { $0.didAddTransaction() }
        }
    }
    
    @MainActor
    func addTransaction(_ transaction: TransactionModel) async {
        do {
            if transaction.currency != .pln {
                let transactionCurrency = transaction.currency.title
                let exchangeDate = previousWorkingDay(from: transaction.date)
                let exchangeDateString = formatDateToString(exchangeDate)
                
                transaction.exchangeRate = try await exchangeRateService.fetchRates(transactionCurrency, exchangeDateString)
            } else {
                transaction.exchangeRate = 1.0
            }
            
            try storage.addModel(transaction)
            transactions.append(transaction)
            
            observers.allObjects.forEach { $0.didAddTransaction() }
        } catch {
            print(error)
        }
    }
    
    func removeTransaction(_ transaction: TransactionModel) {
        do {
            guard let transactionIndex = transactions.firstIndex(of: transaction) else { return }
            
            try storage.deleteModel(transaction)
            transactions.remove(at: transactionIndex)
            
            observers.allObjects.forEach { $0.didRemoveTransaction?() }
        } catch {
            print(error)
        }
    }
    
    private func previousWorkingDay(from date: Date) -> Date {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: .now)
        
        let referenceDate = date > currentDate ? currentDate : date
        var previousDay = calendar.date(byAdding: .day, value: -1, to: referenceDate)!
        
        while calendar.isDateInWeekend(previousDay) {
            previousDay = calendar.date(byAdding: .day, value: -1, to: previousDay)!
        }
        
        return previousDay
    }
    
    private func formatDateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: date)
    }
}

//
//  MainViewModel.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 24/08/2025.
//

import Foundation

final class MainViewModel: TransactionServiceObserver {
    
    private let transactionService: TransactionService
    
    private(set) var expenses: [MonthExpenses]
        
    private var selectedMonthIndex: Int
    
    private var selectedYearIndex: Int
    
    init(_ transactionService: TransactionService) {
        self.transactionService = transactionService
        self.expenses = []
        
        self.selectedMonthIndex = Calendar.current.component(.month, from: .now) - 1
        self.selectedYearIndex = Calendar.current.component(.year, from: .now)
        
        self.transactionService.observers.add(self)
    }
    
    deinit {
        self.transactionService.observers.remove(self)
    }
    
//    public func loadTransactions() {
//        Task {
//            let storage = TransactionStorage()
//            self.transactions = await storage.getModels()
//        }
//    }
    
    private func getMonthExpenses(from transactions: [TransactionModel]) -> [MonthExpenses] {
        let calendar = Calendar.current
        
        let groupedByMonth = Dictionary(grouping: transactions) { transaction -> Date in
            let components = calendar.dateComponents([.year, .month], from: transaction.date)
            return calendar.date(from: components)!
        }
        
        // Convert each month group into MonthExpenses
        let monthExpenses = groupedByMonth.map { (monthDate, transactions) -> MonthExpenses in
            // Group by category inside month
            let groupedByCategory = Dictionary(grouping: transactions) { $0.category }
            
            var categoryExpenses = groupedByCategory.map { (category, items) -> CategoryExpense in
                let total = items.reduce(0) { $0 + $1.amount }
                return CategoryExpense(category: category, amount: total)
            }
            
            var totalMonthExpenses: Double = categoryExpenses.reduce(0) { $0 + $1.amount }
            
            categoryExpenses.sort { $0.amount > $1.amount }
            
            return MonthExpenses(date: monthDate, total: totalMonthExpenses, expenses: categoryExpenses)
        }
        
        // Sort by date (latest first for example)
        return monthExpenses.sorted { $0.date > $1.date }
    }
    
    func updatedTransactionsList() {
        let transactions = transactionService.transactions
        self.expenses = getMonthExpenses(from: transactions)
    }
    
    public func getSelectedMonthExpenses() -> MonthExpenses {
        MonthExpenses(date: .now, total: 234, expenses: [CategoryExpense(category: .communication, amount: 234)])
    }
    
    public func showPreviousMonth() {
        if selectedMonthIndex == 0 {
            selectedMonthIndex = 11
            selectedYearIndex -= 1
        } else {
            selectedMonthIndex -= 1
        }
    }
    
    public func showNextMonth() {
        if selectedMonthIndex == 11 {
            selectedMonthIndex = 0
            selectedYearIndex += 1
        } else {
            selectedMonthIndex += 1
        }
    }
    
    public func getSelectedDateDescription() -> String {
        let monthName = Calendar.current.standaloneMonthSymbols[selectedMonthIndex]
        let yearName = selectedYearIndex.description
        
        return monthName + " " + yearName
    }
}

struct MonthExpenses {
    let date: Date
    let total: Double
    let expenses: [CategoryExpense]
}

struct CategoryExpense {
    let category: TransactionCategory
    let amount: Double
}

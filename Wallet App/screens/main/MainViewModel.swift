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
    
    private var selectedDate: [Calendar.Component: String]
    
    private var selectedMonthIndex = 1
    
    private var selectedYearIndex = 0
    
    init(_ transactionService: TransactionService) {
        self.transactionService = transactionService
        self.expenses = []
        self.selectedDate = [:]
        
        self.transactionService.observers.add(self)
        
        setupCurrentDate()
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
    
    private func setupCurrentDate() {
        let monthIndex = Calendar.current.component(.month, from: .now) - 1
        selectedDate[.month] = Calendar.current.standaloneMonthSymbols[monthIndex]
        
        selectedDate[.year] = Calendar.current.component(.year, from: .now).description
    }
    
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
        let index = Calendar.current.component(.month, from: Date())
        
        if index - selectedMonthIndex - 1 < 0 {
            selectedYearIndex -= 31_577_600
            selectedMonthIndex -= 12
        }
        
        selectedMonthIndex += 1
        
        selectedDate[.month] = Calendar.current.standaloneMonthSymbols[index-selectedMonthIndex]
        selectedDate[.year] = "\(Calendar.current.component(.year, from: Date.now.addingTimeInterval(TimeInterval(selectedYearIndex))))"
    }
    
    public func showNextMonth() {
        let index = Calendar.current.component(.month, from: Date())
        if index - selectedMonthIndex + 1 > 11 {
            selectedYearIndex += 31_577_600
            selectedMonthIndex += 12
        }
        selectedMonthIndex -= 1
        selectedDate[.month] = Calendar.current.standaloneMonthSymbols[index-selectedMonthIndex]
        selectedDate[.year] = "\(Calendar.current.component(.year, from: Date.now.addingTimeInterval(TimeInterval(selectedYearIndex))))"
    }
    
    public func getSelectedDateDescription() -> String {
        selectedDate[.month]! + " " + selectedDate[.year]!
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

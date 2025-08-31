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
    
    public var didUpdateExpenses: (() -> Void)?
    
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
    
    private func getMonthExpenses(from transactions: [TransactionModel]) -> [MonthExpenses] {
        let calendar = Calendar.current
        
        let expensesByMonth = Dictionary(grouping: transactions) { transaction -> Date in
            let components = calendar.dateComponents([.year, .month], from: transaction.date)
            return calendar.date(from: components)!
        }
        
        let expensesByMonthCategory = expensesByMonth.map { (date, transactions) -> MonthExpenses in
            let expensesByCategory = Dictionary(grouping: transactions) { $0.category }
            
            var categoryExpenses = expensesByCategory.map { (category, items) -> CategoryExpense in
                let total = items.reduce(0) { $0 + $1.amount }
                return CategoryExpense(category: category, amount: total)
            }
            
            let totalMonthExpenses = categoryExpenses.reduce(0) { $0 + $1.amount }
            
            categoryExpenses.sort { $0.amount > $1.amount }
            
            return MonthExpenses(date: date, total: totalMonthExpenses, items: categoryExpenses)
        }
        
        return expensesByMonthCategory
    }
    
    func updatedTransactionsList() {
        let transactions = transactionService.transactions
        self.expenses = getMonthExpenses(from: transactions)
        
        didUpdateExpenses?()
    }
    
    public func getSelectedMonthTotalExpenses() -> Double {
        expenses.first(where: {
            let expensesDateComponents = Calendar.current.dateComponents([.year, .month], from: $0.date)
            return expensesDateComponents.year == selectedYearIndex && expensesDateComponents.month == selectedMonthIndex + 1
        })?.total ?? 0
    }
    
    public func getSelectedMonthExpenses() -> [CategoryExpense] {
        expenses.first(where: {
            let expensesDateComponents = Calendar.current.dateComponents([.year, .month], from: $0.date)
            return expensesDateComponents.year == selectedYearIndex && expensesDateComponents.month == selectedMonthIndex + 1
        })?.items ?? []
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
    let items: [CategoryExpense]
}

struct CategoryExpense {
    let category: TransactionCategory
    let amount: Double
}

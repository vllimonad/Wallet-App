//
//  AddRecordViewModel.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 24/08/2025.
//

import Foundation

final class AddTransactionViewModel {
    
    private let transactionSecrvice: TransactionService
    
    public var amount: Double?
    
    public var selectedCurrency: TransactionCurrency
    
    public var selectedCategory: TransactionCategory?
    
    public var selectedDate: Date
    
    public var note: String?
    
    init(_ transactionSecrvice: TransactionService) {
        self.transactionSecrvice = transactionSecrvice
        
        self.selectedCurrency = .pln
        self.selectedDate = Date()
    }
    
    public func isValidInput() -> Bool {
        amount != nil && selectedCategory != nil
    }
    
    public func saveTransaction() {
        guard
            let amount = amount,
            let selectedCategory = selectedCategory
        else { return }
        
        let transaction = TransactionModel(amount: amount, currency: selectedCurrency, date: selectedDate, category: selectedCategory, note: note, exchangeRate: 1.0)
        
        transactionSecrvice.addTransaction(transaction)
    }
}

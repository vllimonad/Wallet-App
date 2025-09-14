//
//  AddRecordViewModel.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 24/08/2025.
//

import Foundation

final class AddTransactionViewModel: AddTransactionViewModelType {
    
    private let transactionService: TransactionService
    
    var amount: Double?
    
    var selectedCurrency: TransactionCurrency
    
    var selectedCategory: TransactionCategory?
    
    var selectedDate: Date
    
    var note: String?
    
    init(_ transactionService: TransactionService) {
        self.transactionService = transactionService
        
        self.selectedCurrency = .pln
        self.selectedDate = Date()
    }
    
    func isValidInput() -> Bool {
        amount != nil && selectedCategory != nil
    }
    
    func saveTransaction() {
        guard
            let amount = amount,
            let selectedCategory = selectedCategory
        else { return }
        
        let transaction = TransactionModel(amount: amount, currency: selectedCurrency, date: selectedDate, category: selectedCategory, note: note, exchangeRate: 1.0)
        
        Task {
            await transactionService.addTransaction(transaction)
        }
    }
}

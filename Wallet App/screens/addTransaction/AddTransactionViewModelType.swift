//
//  AddTransactionViewModelDelegate.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 04/09/2025.
//

import Foundation

protocol AddTransactionViewModelType: AnyObject {
    
    var amount: Double? { get set }
    
    var selectedCurrency: TransactionCurrency { get set }
    
    var selectedCategory: TransactionCategory? { get set }
    
    var selectedDate: Date { get set }
    
    var note: String? { get set }
    
    func isValidInput() -> Bool
    
    func saveTransaction()
}

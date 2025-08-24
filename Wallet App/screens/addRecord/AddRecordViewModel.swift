//
//  AddRecordViewModel.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 24/08/2025.
//

import Foundation

final class AddRecordViewModel {
    
    public var amount: Double?
    
    public var selectedCurrency: TransactionCurrency
    
    public var selectedCategory: TransactionCategory?
    
    public var selectedDate: Date
    
    public var note: String?
    
    init() {
        self.selectedCurrency = .pln
        self.selectedDate = Date()
    }
}

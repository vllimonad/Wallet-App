//
//  TransactionHistoryViewModel.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 30/08/2025.
//

import Foundation

final class TransactionHistoryViewModel: TransactionServiceObserver {
    
    private let transactionService: TransactionService
    
    private(set) var transactions: [[Transaction]]
    
    init(_ transactionService: TransactionService) {
        self.transactionService = transactionService
        self.transactions = []
        
        self.transactionService.observers.add(self)
    }
    
    deinit {
        self.transactionService.observers.remove(self)
    }
    
    func updatedTransactionsList() {
        
    }
}

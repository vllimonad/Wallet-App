//
//  HistoryTransactionServiceProtocol.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 14/09/2025.
//

import Foundation

protocol HistoryTransactionServiceProtocol {
    
    var transactions: [TransactionModel] { get }
    
    var observers: NSHashTable<TransactionServiceObserver> { get set }
    
    @MainActor
    func removeTransaction(_ transaction: TransactionModel)
}

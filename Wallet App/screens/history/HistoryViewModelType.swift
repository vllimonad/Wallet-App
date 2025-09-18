//
//  TransactionHistoryViewModelType.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 04/09/2025.
//

import Foundation

protocol HistoryViewModelType {
    
    var viewDelegate: HistoryViewModelViewDelegate? { get set }
    
    var transactions: [TransactionsSection] { get }
    
    @MainActor
    func removeTransaction(at indexPath: IndexPath)
    
    func getFormattedDate(for section: Int) -> String
}

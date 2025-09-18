//
//  StatisticsTransactionServiceProtocol.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 18/09/2025.
//

import Foundation

protocol StatisticsTransactionServiceProtocol {
    
    var transactions: [TransactionModel] { get }
    
    var observers: NSHashTable<TransactionServiceObserver> { get set }
}

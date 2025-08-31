//
//  TransactionServiceObserver.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 30/08/2025.
//

import Foundation

@objc
protocol TransactionServiceObserver: AnyObject {
    
    func updatedTransactionsList()
}

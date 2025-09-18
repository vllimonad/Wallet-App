//
//  TransactionStorageProtocol.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 14/09/2025.
//

import Foundation

protocol TransactionStorageProtocol {
    
    @MainActor
    func getModels() -> [TransactionModel]
    
    @MainActor
    func addModel(_ model: TransactionModel) throws
    
    @MainActor
    func deleteModel(_ model: TransactionModel) throws
}

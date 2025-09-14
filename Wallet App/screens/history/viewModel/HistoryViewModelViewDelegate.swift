//
//  TransactionHistoryViewModelDelegate.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 04/09/2025.
//

import Foundation

protocol HistoryViewModelViewDelegate: AnyObject {
    
    @MainActor
    func reloadData()
    
    @MainActor
    func deleteRow(at indexPath: IndexPath)
    
    @MainActor
    func deleteSection(at indexPath: IndexPath)
}

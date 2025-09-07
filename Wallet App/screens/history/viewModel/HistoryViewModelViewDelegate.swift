//
//  TransactionHistoryViewModelDelegate.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 04/09/2025.
//

import Foundation

protocol HistoryViewModelViewDelegate: AnyObject {
    
    func reloadData()
    
    func deleteRow(at indexPath: IndexPath)
    
    func deleteSection(at indexPath: IndexPath)
}

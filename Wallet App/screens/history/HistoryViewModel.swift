//
//  TransactionHistoryViewModel.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 30/08/2025.
//

import Foundation

final class HistoryViewModel: TransactionServiceObserver {
    
    private let transactionService: TransactionService
    
    private let dateFormatter: DateFormatter
    
    weak var viewDelegate: HistoryViewModelViewDelegate?
    
    private(set) var transactions: [TransactionsSection]
    
    init(_ transactionService: TransactionService) {
        self.transactionService = transactionService
        self.transactions = []
        self.dateFormatter = DateFormatter()
        
        self.configureDateFormatter()
        
        self.transactionService.observers.add(self)
    }
    
    deinit {
        self.transactionService.observers.remove(self)
    }
    
    private func configureDateFormatter() {
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
    }
    
    private func groupTransactionsByDate(_ transactions: [TransactionModel]) -> [TransactionsSection] {
        let groupedTransactionsByDate = Dictionary(grouping: transactions) { transaction in
            Calendar.current.startOfDay(for: transaction.date)
        }

        return groupedTransactionsByDate
            .map { TransactionsSection(date: $0.key, items: $0.value.sorted { $0.date > $1.date }) }
            .sorted { $0.date > $1.date }
    }
        
    func updatedTransactionsList() {
        let fetchedTransactions = transactionService.transactions
        self.transactions = groupTransactionsByDate(fetchedTransactions)
        
        viewDelegate?.reloadData()
    }
}

extension HistoryViewModel: HistoryViewModelType {
    
    func getFormattedDate(for section: Int) -> String {
        dateFormatter.string(from: transactions[section].date)
    }
}

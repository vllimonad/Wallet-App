//
//  HistoryViewModelTests.swift
//  WalletAppTests
//
//  Created by Vlad Klunduk on 14/09/2025.
//

import XCTest

@testable import Wallet_App

final class MockHistoryTransactionService: HistoryTransactionServiceProtocol {
    
    var transactions: [TransactionModel]
    
    var observers: NSHashTable<TransactionServiceObserver>
    
    var removedTransactionsCount: Int
    
    init(transactions: [TransactionModel], observers: NSHashTable<TransactionServiceObserver>) {
        self.transactions = transactions
        self.observers = observers
        self.removedTransactionsCount = 0
    }
    
    func removeTransaction(_ transaction: TransactionModel) {
        removedTransactionsCount += 1
    }
}

final class MockHistoryViewModelViewDelegate: HistoryViewModelViewDelegate {
    
    var dataReloadsCount: Int
    var deletedRowsCount: Int
    var deletedSectionsCount: Int
    
    init() {
        self.dataReloadsCount = 0
        self.deletedRowsCount = 0
        self.deletedSectionsCount = 0
    }
    
    func reloadData() {
        dataReloadsCount += 1
    }
    
    func deleteRow(at indexPath: IndexPath) {
        deletedRowsCount += 1
    }
    
    func deleteSection(at indexPath: IndexPath) {
        deletedSectionsCount += 1
    }
}

final class HistoryViewModelTests: XCTestCase {
    
    var transactionService: MockHistoryTransactionService!
    
    var viewDelegate: MockHistoryViewModelViewDelegate!
    
    var sut: HistoryViewModel!
    
    override func setUp() {
        super.setUp()
        
        let transaction1 = TransactionModel(amount: 100,
                                           currency: TransactionCurrency.usd,
                                           date: Date(),
                                           category: TransactionCategory.food,
                                           note: "",
                                           exchangeRate: 1.0)
        let transaction2 = TransactionModel(amount: 100,
                                           currency: TransactionCurrency.usd,
                                           date: Date(),
                                           category: TransactionCategory.food,
                                           note: "",
                                           exchangeRate: 1.0)
        
        transactionService = MockHistoryTransactionService(transactions: [transaction1, transaction2],
                                                           observers: .weakObjects())
        viewDelegate = MockHistoryViewModelViewDelegate()
        
        sut = HistoryViewModel(transactionService)
        sut.viewDelegate = viewDelegate
    }
    
    override func tearDown() {
        transactionService = nil
        viewDelegate = nil
        sut = nil
        
        super.tearDown()
    }
    
    @MainActor
    func test_DidAddTransaction_UpdatesTransactions() {
        sut.didAddTransaction()
        
        XCTAssertEqual(viewDelegate.dataReloadsCount, 1)
        XCTAssertEqual(sut.transactions.first!.items.count, 2)
    }
    
    @MainActor
    func test_RemoveTransaction_WhenRemovesOneTransactionInSection_RemovesTransaction() {
        let indexPath = IndexPath(item: 0, section: 0)
        
        sut.didAddTransaction()
        
        sut.removeTransaction(at: indexPath)
        
        XCTAssertEqual(sut.transactions.first!.items.count, 1)
        XCTAssertEqual(transactionService.removedTransactionsCount, 1)
        XCTAssertEqual(viewDelegate.deletedRowsCount, 1)
    }
    
    @MainActor
    func test_RemoveTransaction_WhenRemovesAllTransactionsInSection_RemovesSection() {
        let indexPath = IndexPath(item: 0, section: 0)
        
        sut.didAddTransaction()
        
        sut.removeTransaction(at: indexPath)
        sut.removeTransaction(at: indexPath)
        
        XCTAssertTrue(sut.transactions.isEmpty)
        XCTAssertEqual(transactionService.removedTransactionsCount, 2)
        XCTAssertEqual(viewDelegate.deletedRowsCount, 1)
        XCTAssertEqual(viewDelegate.deletedSectionsCount, 1)
    }
}

//
//  TransactionServiceTests.swift
//  WalletAppTests
//
//  Created by Vlad Klunduk on 14/09/2025.
//

import XCTest

@testable import Wallet_App

final class MockTransactionStorage: TransactionStorageProtocol {
    
    var models: [TransactionModel]
    
    init(models: [TransactionModel]) {
        self.models = models
    }
    
    func getModels() -> [TransactionModel] {
        models
    }
    
    func addModel(_ model: TransactionModel) throws {
        models.append(model)
    }
    
    func deleteModel(_ model: TransactionModel) throws {
        models.removeAll(where: { $0 == model })
    }
}

final class StubExchangeRateService: ExchangeRateServiceProtocol {
    
    let rate: Double
    
    init(rate: Double) {
        self.rate = rate
    }
    
    func fetchRates(_ currency: String, _ dateString: String) async throws -> Double {
        rate
    }
}

final class TransactionServiceTests: XCTestCase {

    var storage: MockTransactionStorage!
    
    var exchangeRateService: StubExchangeRateService!
    
    var sut: TransactionService!
    
    override func setUp() {
        super.setUp()
        
        storage = MockTransactionStorage(models: [])
        exchangeRateService = StubExchangeRateService(rate: 3.99)
        
        sut = TransactionService(storage: storage, exchangeRateService: exchangeRateService)
    }
    
    override func tearDown() {
        storage = nil
        exchangeRateService = nil
        sut = nil
        
        super.tearDown()
    }
    
    @MainActor
    func test_AddTransaction_WithPLN_SavesTransaction() async {
        let transaction = TransactionModel(amount: 100,
                                           currency: TransactionCurrency.pln,
                                           date: Date(),
                                           category: TransactionCategory.food,
                                           note: "",
                                           exchangeRate: 1.0)
                
        await sut.addTransaction(transaction)
                
        XCTAssertEqual(sut.transactions.count, 1)
        XCTAssertEqual(storage.models.count, 1)
        
        XCTAssertEqual(sut.transactions.first!, transaction)
        XCTAssertEqual(storage.models.first!, transaction)
        
        XCTAssertEqual(transaction.exchangeRate, 1.0)
    }
    
    @MainActor
    func test_AddTransaction_WithUSD_SavesTransaction() async {
        let transaction = TransactionModel(amount: 100,
                                           currency: TransactionCurrency.usd,
                                           date: Date(),
                                           category: TransactionCategory.food,
                                           note: "",
                                           exchangeRate: 1.0)
                
        await sut.addTransaction(transaction)
                
        XCTAssertEqual(sut.transactions.count, 1)
        XCTAssertEqual(storage.models.count, 1)
        
        XCTAssertEqual(sut.transactions.first!, transaction)
        XCTAssertEqual(storage.models.first!, transaction)
        
        XCTAssertEqual(transaction.exchangeRate, 3.99)
    }
    
    @MainActor
    func test_DeleteTransaction_DeletesTransaction() async {
        let transaction = TransactionModel(amount: 100,
                                           currency: TransactionCurrency.usd,
                                           date: Date(),
                                           category: TransactionCategory.food,
                                           note: "",
                                           exchangeRate: 1.0)
                
        await sut.addTransaction(transaction)
        
        sut.removeTransaction(transaction)
                
        XCTAssertTrue(sut.transactions.isEmpty)
        XCTAssertTrue(storage.models.isEmpty)        
    }
}

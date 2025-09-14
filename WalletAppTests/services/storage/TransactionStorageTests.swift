//
//  TransactionStorageTests.swift
//  WalletAppTests
//
//  Created by Vlad Klunduk on 14/09/2025.
//

import XCTest
import SwiftData

@testable import Wallet_App

final class TransactionStorageTests: XCTestCase {

    var sut: TransactionStorage!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: TransactionModel.self, configurations: modelConfiguration)
        
        sut = TransactionStorage(modelContainer)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }

    @MainActor
    func test_GetModels_WhenEmpty_ReturnsEmptyArray() {
        let models = sut.getModels()
        
        XCTAssertTrue(models.isEmpty)
    }
    
    @MainActor
    func test_GetModels_ReturnsModels() throws {
        let model1 = TransactionModel(amount: 100,
                                     currency: TransactionCurrency.eur,
                                     date: Date(),
                                     category: TransactionCategory.communication,
                                     note: "",
                                     exchangeRate: 1.0)
        
        let model2 = TransactionModel(amount: 100,
                                     currency: TransactionCurrency.eur,
                                     date: Date(),
                                     category: TransactionCategory.communication,
                                     note: "",
                                     exchangeRate: 1.0)
        try sut.addModel(model1)
        try sut.addModel(model2)
        
        let models = sut.getModels()
        
        XCTAssertEqual(models.count, 2)
        XCTAssert(models.contains(model1))
        XCTAssert(models.contains(model2))
    }
    
    @MainActor
    func test_AddModel_SavesModel() throws {
        let model = TransactionModel(amount: 100,
                                     currency: TransactionCurrency.eur,
                                     date: Date(),
                                     category: TransactionCategory.communication,
                                     note: "",
                                     exchangeRate: 1.0)
        
        try sut.addModel(model)
        
        let models = sut.getModels()
        
        XCTAssertEqual(models.count, 1)
        XCTAssertEqual(models.first!, model)
    }
    
    @MainActor
    func test_DeleteModel_DeletesModel() throws {
        let model = TransactionModel(amount: 100,
                                     currency: TransactionCurrency.eur,
                                     date: Date(),
                                     category: TransactionCategory.communication,
                                     note: "",
                                     exchangeRate: 1.0)
        
        try sut.addModel(model)
        try sut.deleteModel(model)
        
        let models = sut.getModels()
        
        XCTAssertTrue(models.isEmpty)
    }
    
    @MainActor
    func test_DeleteModel_WhenEmpty_DoesNotThrow()  throws {
        let model = TransactionModel(amount: 100,
                                     currency: TransactionCurrency.eur,
                                     date: Date(),
                                     category: TransactionCategory.communication,
                                     note: "",
                                     exchangeRate: 1.0)
        
        XCTAssertNoThrow(try sut.deleteModel(model))
        
        let models = sut.getModels()
        
        XCTAssertTrue(models.isEmpty)
    }
}

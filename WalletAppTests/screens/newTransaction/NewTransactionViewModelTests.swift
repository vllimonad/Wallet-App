//
//  NewTransactionViewModelTests.swift
//  WalletAppTests
//
//  Created by Vlad Klunduk on 18/09/2025.
//

import XCTest

@testable import Wallet_App

final class MockNewTransactionServiceProtocol: NewTransactionServiceProtocol {
    
    var addTransactionCount: Int
    
    init() {
        addTransactionCount = 0
    }
    
    func addTransaction(_ transaction: Wallet_App.TransactionModel) async {
        addTransactionCount += 1
    }
}

final class NewTransactionViewModelTests: XCTestCase {

    var transactionService: MockNewTransactionServiceProtocol!
    
    var sut: NewTransactionViewModel!

    override func setUp() {
        super.setUp()
        
        transactionService = MockNewTransactionServiceProtocol()
        sut = NewTransactionViewModel(transactionService)
    }
    
    func test_Init_CreatesDefaultParameters() {
        XCTAssertTrue(Calendar.current.isDateInToday(sut.selectedDate))
        XCTAssertEqual(sut.selectedCurrency, .pln)
    }
    
    func test_IsValidInput_ReturnsTrue() {
        sut.amount = 100
        sut.selectedCategory = .communication
        
        let isValid = sut.isValidInput()
        
        XCTAssertTrue(isValid)
    }
    
    func test_IsValidInput_WhenAmountIsNil_ReturnsFalse() {
        sut.selectedCategory = .communication
        
        let isValid = sut.isValidInput()
        
        XCTAssertFalse(isValid)
    }
    
    func test_IsValidInput_WhenCategoryIsNil_ReturnsFalse() {
        sut.amount = 100
        
        let isValid = sut.isValidInput()
        
        XCTAssertFalse(isValid)
    }
    
    func test_SaveTransaction_SavesTransaction() async {
        sut.amount = 100
        sut.selectedCategory = .communication
        
        sut.saveTransaction()
        
        try? await Task.sleep(for: .seconds(0.1))
        
        XCTAssertEqual(transactionService.addTransactionCount, 1)
    }
    
    func test_SaveTransaction_WhenAmountNil_Returns() async {
        sut.selectedCategory = .communication
        
        sut.saveTransaction()
        
        try? await Task.sleep(for: .seconds(0.1))
        
        XCTAssertEqual(transactionService.addTransactionCount, 0)
    }
    
    func test_SaveTransaction_WhenCategoryNil_Returns() async {
        sut.amount = 100
        
        sut.saveTransaction()
        
        try? await Task.sleep(for: .seconds(0.1))
        
        XCTAssertEqual(transactionService.addTransactionCount, 0)
    }
}

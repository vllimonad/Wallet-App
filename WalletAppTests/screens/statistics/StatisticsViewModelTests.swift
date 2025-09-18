//
//  StatisticsViewModelTests.swift
//  WalletAppTests
//
//  Created by Vlad Klunduk on 18/09/2025.
//

import XCTest

@testable import Wallet_App

final class MockStatisticsTransactionService: StatisticsTransactionServiceProtocol {
    
    var transactions: [TransactionModel]
    
    var observers: NSHashTable<TransactionServiceObserver>
    
    init() {
        transactions = []
        observers = .weakObjects()
    }
}

final class StatisticsViewModelTests: XCTestCase {

    var sut: StatisticsViewModel!
    
    override func setUp() {
        super.setUp()
        
        let transactionService = MockStatisticsTransactionService()
        sut = StatisticsViewModel(transactionService)
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }

    func test_MoveToPreviousMonth_MovesToPreviousMonth() {
        let currentMonthIndex = sut.selectedMonthIndex
        
        sut.moveToPreviousMonth()
        
        XCTAssertNotEqual(currentMonthIndex, sut.selectedMonthIndex)
    }
    
    func test_MoveToPreviousMonth_WhenFirstMonthOfYear_MovesToPreviousYear() {
        let currentYearIndex = sut.selectedYearIndex
        
        while sut.selectedMonthIndex != 0 {
            sut.moveToPreviousMonth()
        }
        
        sut.moveToPreviousMonth()
        
        XCTAssertNotEqual(currentYearIndex, sut.selectedYearIndex)
    }
    
    func test_MoveToNextMonth_MovesToNextMonth() {
        let currentMonthIndex = sut.selectedMonthIndex
        
        sut.moveToNextMonth()
        
        XCTAssertNotEqual(currentMonthIndex, sut.selectedMonthIndex)
    }
    
    func test_MoveToNextMonth_WhenLastMonthOfYear_MovesToNextYear() {
        let currentYearIndex = sut.selectedYearIndex
        
        while sut.selectedMonthIndex != 11 {
            sut.moveToNextMonth()
        }
        
        sut.moveToNextMonth()
        
        XCTAssertNotEqual(currentYearIndex, sut.selectedYearIndex)
    }
}

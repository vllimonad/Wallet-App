//
//  TransactionDataSourceTests.swift
//  WalletAppTests
//
//  Created by Vlad Klunduk on 13/09/2025.
//

import XCTest

@testable import Wallet_App

final class TransactionDataSourceTests: XCTestCase {
    
    func test_GetCategorySystemImageName_ReturnsCorrectName() {
        let foodImageName = TransactionDataSource.getCategorySystemImageName(.food)
        let communicationImageName = TransactionDataSource.getCategorySystemImageName(.communication)
        let entertainmentImageName = TransactionDataSource.getCategorySystemImageName(.entertainment)
        let financialExpensesImageName = TransactionDataSource.getCategorySystemImageName(.financialExpenses)
        let housingImageName = TransactionDataSource.getCategorySystemImageName(.housing)
        let shoppingImageName = TransactionDataSource.getCategorySystemImageName(.shopping)
        let transportationImageName = TransactionDataSource.getCategorySystemImageName(.transportation)

        XCTAssertEqual(foodImageName, "fork.knife")
        XCTAssertEqual(communicationImageName, "phone.fill")
        XCTAssertEqual(entertainmentImageName, "gamecontroller.fill")
        XCTAssertEqual(financialExpensesImageName, "creditcard.fill")
        XCTAssertEqual(housingImageName, "house.fill")
        XCTAssertEqual(shoppingImageName, "handbag.fill")
        XCTAssertEqual(transportationImageName, "car.fill")
    }

}

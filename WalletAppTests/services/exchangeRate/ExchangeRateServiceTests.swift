//
//  ExchangeRateServiceTests.swift
//  WalletAppTests
//
//  Created by Vlad Klunduk on 13/09/2025.
//

import XCTest

@testable import Wallet_App

final class StubExchangeRateClient: ExchangeRateClient {
    
    private let data: Data
    
    private let response: URLResponse
    
    init(data: Data, response: URLResponse) {
        self.data = data
        self.response = response
    }
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        return (data, response)
    }
    
}

final class ExchangeRateServiceTests: XCTestCase {
        
    var sut: ExchangeRateService!
    
    var dateString: String!
    
    override func setUp() {
        super.setUp()
        
        dateString = "2025-08-09"
        
        let data = """
        {
            "rates": [
                { "mid": 3.99 }
            ]
        }
        """.data(using: .utf8)!
        let response = URLResponse()
        let stubExchangeRateClient = StubExchangeRateClient(data: data, response: response)
        
        sut = ExchangeRateService(client: stubExchangeRateClient)
    }
    
    override func tearDown() {
        dateString = nil
        sut = nil
        
        super.tearDown()
    }
    
    func test_FetchRates_ReturnsCorrectRate() async throws {
        let currency = "USD"
        
        let result = try await sut.fetchRates(currency, dateString)
                
        XCTAssertEqual(result, 3.99)
    }

    func test_FetchRates_WhenInvalidCurrency_ReturnsDefaultRate() async throws {
        let currency = "USDD"
        
        let result = try await sut.fetchRates(currency, dateString)
                
        XCTAssertEqual(result, 1.0)
    }
}

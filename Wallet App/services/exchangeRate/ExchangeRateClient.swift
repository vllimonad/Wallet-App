//
//  ExchangeRateClient.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 13/09/2025.
//

import Foundation

protocol ExchangeRateClient {
    
    func data(from url: URL) async throws -> (Data, URLResponse)
}

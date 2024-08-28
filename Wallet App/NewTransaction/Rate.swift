//
//  Rate.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 10/09/2023.
//

import Foundation

struct NBPResponse: Codable {
    let rates: [Rate]
}

struct Rate: Codable {
    let code: String
    let mid: Double
}

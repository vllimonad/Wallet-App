//
//  NBPResponse.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 08/09/2024.
//

import Foundation

struct NBPResponse: Codable {
    let rates: [Rate]
}

struct Rate: Codable {
    let code: String
    let mid: Double
}

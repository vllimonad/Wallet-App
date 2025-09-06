//
//  TransactionDataSource.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 30/08/2025.
//

import Foundation
import DeveloperToolsSupport

final class TransactionDataSource {
    
    public static func getCategorySystemImageName(_ category: TransactionCategory) -> String {
        let imageName: String
        
        switch category {
        case .food:
            imageName = "fork.knife"
        case .communication:
            imageName = "phone.fill"
        case .entertainment:
            imageName = "gamecontroller.fill"
        case .financialExpenses:
            imageName = "creditcard.fill"
        case .housing:
            imageName = "house.fill"
        case .shopping:
            imageName = "handbag.fill"
        case .transportation:
            imageName = "car.fill"
        }
        
        return imageName
    }
}

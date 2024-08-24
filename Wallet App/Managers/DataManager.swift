//
//  DataManager.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 23/08/2024.
//

import Foundation

class DataManager {
    
    static var shared = DataManager()
    var filename = "lisOfTransactions.txt"
    
    private init() {}
    
    func readData() -> [[Transaction]] {
        if let data = try? Data(contentsOf: getURL()){
            return try! JSONDecoder().decode([[Transaction]].self, from: data)
        }
        return []
    }
    
    func saveData(_ transactions: [[Transaction]]) {
        if let data = try? JSONEncoder().encode(transactions){
            try? data.write(to: getURL())
        }
    }
    
    func getURL() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return url.appending(path: filename)
    }
}

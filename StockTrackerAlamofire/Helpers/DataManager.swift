//
//  StorageManager.swift
//  StockTrackerAlamofire
//
//  Created by Эрмек Жоробеков on 26.03.2022.
//

import Foundation

final class DataManager {
    
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults.standard
    private let key = "stocks"
    
    private init() {}
    
    func fetchTickers() -> [String] {
        if let stocks = userDefaults.value(forKey: key) as? [String] {
            return stocks
        }
        return []
    }
    
    func save(tickers: [String]) {
        userDefaults.set(tickers, forKey: key)
    }
}

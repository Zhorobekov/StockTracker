//
//  StockModel.swift
//  StockTrackerAlamofire
//
//  Created by Эрмек Жоробеков on 26.03.2022.
//

import Foundation

struct Stock: Decodable {
    
    let symbol: String
    let price: Float
    let name: String
    let changesPercentage: Float
    
}

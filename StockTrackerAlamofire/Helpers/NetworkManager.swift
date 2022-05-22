//
//  NetworkManager.swift
//  StockTrackerAlamofire
//
//  Created by Эрмек Жоробеков on 26.03.2022.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchStock(with ticker: String, completion: @escaping(Stock) -> Void) {
        
        let url = "https://financialmodelingprep.com/api/v3/quote/\(ticker)?apikey=a15af8fcd7e5332f5022f0ccca771b00"
        AF.request(url)
            .validate()
            .responseDecodable(of: [Stock].self) { dataResponse in
                switch dataResponse.result {
                case .success(let stocks):
                    if !stocks.isEmpty {
                        let stock = Stock(
                            symbol: stocks[0].symbol,
                            price: stocks[0].price,
                            name: stocks[0].name,
                            changesPercentage: stocks[0].changesPercentage
                        )
                        completion(stock)
                    }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
    }

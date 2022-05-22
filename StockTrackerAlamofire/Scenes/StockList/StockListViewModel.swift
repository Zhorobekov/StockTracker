//
//  StockListViewModel.swift
//  StockTrackerAlamofire
//
//  Created by Эрмек Жоробеков on 14.04.2022.
//

import Foundation

protocol StockListViewModelProtocol {
    var stocks: [Stock] { get set }
    var tickers: [String] { get set }
    
    func addStock(ticker: String, completion: @escaping (Stock?) -> Void)
    func deleteStock(at index: Int)
    func updateStocks(completion: @escaping () -> Void)
    func cellViewModel(at indexPath: IndexPath) -> StockCellViewModelProtocol
}

class StockListViewModel: StockListViewModelProtocol {
   
    var stocks: [Stock] = []

    var tickers = DataManager.shared.fetchTickers()
    
    func updateStocks(completion: @escaping () -> Void) {
        for ticker in tickers {
            NetworkManager.shared.fetchStock(with: ticker) { stock in
               
                    if let index = self.stocks.firstIndex(where: { $0.symbol == stock.symbol}) {
                        self.stocks[index] = stock
                        completion()
                    } else {
                        self.stocks.append(stock)
                        completion()
                    }
                }
            }
        }
    
    func addStock(ticker: String, completion: @escaping (Stock?) -> Void) {
        NetworkManager.shared.fetchStock(with: ticker) { stock in
                self.stocks.append(stock)
                self.tickers.append(ticker)
                DataManager.shared.save(tickers: self.tickers)
                completion(stock)
            }
        }
    
    func deleteStock(at index: Int) {
        guard let tickerIndex = tickers.firstIndex(of: stocks.remove(at: index).symbol) else { print("1"); return }
        tickers.remove(at: tickerIndex)
        DataManager.shared.save(tickers: tickers)
    }
    
    func cellViewModel(at indexPath: IndexPath) -> StockCellViewModelProtocol {
        let stock = stocks[indexPath.row]
        return StockCellViewModel(stock: stock)
    }
}

//
//  StockTableViewCell.swift
//  StockTrackerAlamofire
//
//  Created by Эрмек Жоробеков on 26.03.2022.
//

import UIKit

class StockCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var ticker: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var changeInPercentage: UILabel!
    
    var viewModel: StockCellViewModelProtocol! {
        didSet {
            ticker.text = viewModel.ticker
            name.text = viewModel.name
            price.text = "$\(viewModel.price)"
            changeInPercentage.text = "\(viewModel.changeInPercentage)%"
        }
    }
    
}

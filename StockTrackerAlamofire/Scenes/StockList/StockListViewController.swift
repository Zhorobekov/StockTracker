//
//  ViewController.swift
//  StockTrackerAlamofire
//
//  Created by Эрмек Жоробеков on 26.03.2022.
//

import UIKit

final class StockListViewController: UIViewController {
        
    private var viewModel: StockListViewModelProtocol! {
        didSet {
            viewModel.updateStocks {
                self.stockTableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }

    private var activityIndicator = UIActivityIndicatorView()
    private var refreshControl = UIRefreshControl()
    
    @IBOutlet weak private var stockTableView: UITableView!
    @IBOutlet weak private var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = StockListViewModel()
        activityIndicator = showSpinner(in: view)
        refreshControl = setRefreshControl()
        tableViewSettings()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        showAlert(with: "ADD STOCK", and: "Write stock's ticker")
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        editStocks()
    }
    
    //MARK: Private Methods
    
    private func tableViewSettings() {
        if viewModel.tickers.isEmpty {
            activityIndicator.stopAnimating()
        }
        stockTableView.refreshControl = refreshControl
        stockTableView.allowsSelection = false
        stockTableView.delegate = self
        stockTableView.dataSource = self
        stockTableView.backgroundColor = .none
        stockTableView.separatorStyle = .none
    }
    
    //MARK: Add spinner, Alert
    private func showSpinner(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        
        return activityIndicator
    }
    
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .cancel)
        alert.addTextField()
        
        let addAction = UIAlertAction(title: "ADD", style: .default) { [unowned self] _ in
            activityIndicator.startAnimating()
            guard let ticker = (alert.textFields?.first?.text?.uppercased()) else { return }
            
            if checkRepeatingTicker(ticker) {
                return
            }
            addStockToTableView(ticker: ticker)
        }
        
        alert.addAction(closeAction)
        alert.addAction(addAction)
        present(alert, animated: true)
    }
    
    private func addStockToTableView(ticker: String) {
        viewModel.addStock(ticker: ticker) { [unowned self] error in
            if error == nil {
                showAlert(with: "Invalid ticker", and: "Please try again")
                activityIndicator.stopAnimating()
            } else {
                let indexPath = IndexPath(row: viewModel.stocks.count - 1, section: 0)
                stockTableView.insertRows(at: [indexPath], with: .top)
                activityIndicator.stopAnimating()
            }
        }
    }
    
    private func checkRepeatingTicker(_ ticker: String) -> Bool {
        if viewModel.tickers.contains(ticker) {
            showAlert(with: "Ticker Repeat", and: "This ticker is already contained in your list")
            activityIndicator.stopAnimating()
            return true
        }
        return false
    }
    
    //MARK: Set RefreshControl
    
    private func setRefreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        viewModel.updateStocks() {
            self.stockTableView.reloadData()
        }
        sender.endRefreshing()
    }
    
    //MARK: Editing stocks
    
    private func editStocks() {
        stockTableView.isEditing = stockTableView.isEditing ? false : true
        editButton.image = stockTableView.isEditing ? UIImage(systemName: "pencil.circle.fill") : UIImage(systemName: "pencil.circle")
    }
}

extension StockListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = stockTableView.dequeueReusableCell(withIdentifier: "stockCell") as! StockCell
        
        cell.viewModel = viewModel.cellViewModel(at: indexPath)

        cell.changeInPercentage.textColor = cell.viewModel.isChangeInPercentageSmallerZero ? .red : .green
        cell.layer.cornerRadius = 20
        cell.cellView.backgroundColor = .init(red: 1, green: 1, blue: 1, alpha: 0.14)
        cell.cellView.layer.cornerRadius = 20
        cell.backgroundColor = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteStock(at: indexPath.row)
            stockTableView.deleteRows(at: [indexPath], with: .top)
        }
    }
}
    


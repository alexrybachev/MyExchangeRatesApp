//
//  MainTableViewController.swift
//  MyExchangeRatesApp
//
//  Created by Aleksandr Rybachev on 09.05.2021.
//

import UIKit

class MainTableViewController: UITableViewController {

    // MARK: - Private properties
    private var rates: [Valute] = []
    private var spinnerView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinnerView = showSpinner(in: tableView)
        sendRequest()
        
        title = "Курс ЦБ РФ"
    }
    
    // MARK: - IBActions
    @IBAction func refreshData(_ sender: UIBarButtonItem) {
        sendRequest()
        spinnerView.startAnimating()
    }

    // MARK: - Private methods
    private func sendRequest() {
        NetworkManager.shared.fetchData { rate, rates in
            DispatchQueue.main.async {
                self.spinnerView.stopAnimating()
                self.rates = rates
                self.tableView.reloadData()
                self.title = "Курс ЦБ РФ на " + rate.Date[String.Index(encodedOffset: 0) ..< String.Index(encodedOffset: 10)]
            }
        }
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return rates.count
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rates.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rateCell", for: indexPath) as! RateTableViewCell
        
        cell.nameCurrencyLabel.text = rates[indexPath.row].CharCode
        cell.rateLabel.text = string(rates[indexPath.row].Value)
        
        if rates[indexPath.row].Previous! == rates[indexPath.row].Value! {
            cell.deltaRateLabel.text = "0.0"
        } else if rates[indexPath.row].Previous! < rates[indexPath.row].Value! {
            cell.deltaRateLabel.text = "+" + string((rates[indexPath.row].Value! - rates[indexPath.row].Previous!))
            cell.deltaRateLabel.textColor = .green
            cell.deltaImageView.image = UIImage(named: "sort-up")
        } else {
            cell.deltaRateLabel.text = string((rates[indexPath.row].Value! - rates[indexPath.row].Previous!))
            cell.deltaRateLabel.textColor = .red
            cell.deltaImageView.image = UIImage(named: "sort-down")
        }
        return cell
    }


}

// MARK: - Animation
extension MainTableViewController {
    
    private func showSpinner(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        
        return activityIndicator
    }

}

// MARK: - Extensions
extension MainTableViewController {
    private func string(_ value: Float?) -> String {
        String(format: "%.4f", value ?? 0.0000)
    }
}

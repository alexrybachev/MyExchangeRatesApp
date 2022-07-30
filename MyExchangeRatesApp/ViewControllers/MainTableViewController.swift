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

    override func numberOfSections(in tableView: UITableView) -> Int {
        rates.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        rates[section].Name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
//        return rates.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rateCell", for: indexPath) as! RateTableViewCell
        let valute = rates[indexPath.section]
        
        var content = cell.defaultContentConfiguration()
        
        cell.nameCurrencyLabel.text = rates[indexPath.row].CharCode
        cell.rateLabel.text = string(rates[indexPath.row].Value)
        
        let delta = rates[indexPath.row].Value! - rates[indexPath.row].Previous!
        
        if delta > 0 {
            cell.deltaRateLabel.text = "+" + string(delta)
            cell.deltaRateLabel.textColor = .green
            cell.deltaImageView.image = UIImage(named: "sort-up")
        } else if delta < 0 {
            cell.deltaRateLabel.text = string(delta)
            cell.deltaRateLabel.textColor = .red
            cell.deltaImageView.image = UIImage(named: "sort-down")
        } else {
            cell.deltaRateLabel.text = "0.0"
        }
        return cell
    }

}


// MARK: - UITableViewDelegate
extension MainTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//    }
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

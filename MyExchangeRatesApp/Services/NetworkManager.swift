//
//  NetworkManager.swift
//  MyExchangeRatesApp
//
//  Created by Aleksandr Rybachev on 09.05.2021.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData(_ completion: @escaping (ExchangeRate, [Valute]) -> Void) {
        let jsonURL = "https://www.cbr-xml-daily.ru/daily_json.js"
        guard let url = URL(string: jsonURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let rate = try JSONDecoder().decode(ExchangeRate.self, from: data)
                let rates = rate.Valute.map { $0.value }
                completion(rate, rates)
            } catch let error {
                print("Ошибка получения данных: ", error)
            }
            
        }.resume()
    }
}

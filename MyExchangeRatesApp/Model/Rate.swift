//
//  Rate.swift
//  MyExchangeRatesApp
//
//  Created by Aleksandr Rybachev on 09.05.2021.
//

struct ExchangeRate: Decodable {
    let Date: String
    let PreviousDate: String
    let PreviousURL: String
    let Timestamp: String
    let Valute: [String: Valute]
    
    
}

struct Valute: Decodable {
    let NumCode: String?
    let CharCode: String?
    let Nominal: Int?
    let Name: String?
    let Value: Float?
    let Previous: Float?
}

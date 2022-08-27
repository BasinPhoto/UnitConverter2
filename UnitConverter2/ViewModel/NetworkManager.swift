//
//  NetworkManager.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 20.02.2021.
//

import Foundation
import Combine
import os

final class NetworkManager {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: NetworkManager.self))
    static let shared: NetworkManager = NetworkManager()
    
    let url = URL(string: "https://v6.exchangerate-api.com/v6/83d18ab70ffc027d5021504d/latest/USD")!
    
    func fetchData() async -> CurrencyRatesResponse? {
        if let currencyUpdateDate = UserDefaults.standard.value(forKey: "currencyUpdateDate") as? Date,
           currencyUpdateDate.timeIntervalSinceNow < (60 * 60 * 24),
           let currencyRatesData = UserDefaults.standard.data(forKey: "currencyRates"),
           let result = try? JSONDecoder().decode(CurrencyRatesResponse.self, from: currencyRatesData) {
            logger.debug("\(#function) Currency rates from UserDefaults")
            return result
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            logger.debug("\(#function) Get data from server")
            let result = try JSONDecoder().decode(CurrencyRatesResponse.self, from: data)
            logger.debug("\(#function) Data decoded")
            UserDefaults.standard.set(data, forKey: "currencyRates")
            UserDefaults.standard.set(Date.now, forKey: "currencyUpdateDate")
            return result
        } catch {
            logger.error("\(#function) Error: \(error)")
            return nil
        }
    }
}

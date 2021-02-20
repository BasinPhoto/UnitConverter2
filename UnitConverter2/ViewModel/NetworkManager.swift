//
//  NetworkManager.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 20.02.2021.
//

import Foundation
import Combine

final class NetworkManager {
    
    static let urlAPI = "https://v6.exchangerate-api.com/v6/83d18ab70ffc027d5021504d/latest/USD"
    
    static func fetchData(urlAPI: String, complition: @escaping (CurrencyRates?) -> () ) {
        guard let url = URL(string: urlAPI) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!)
                complition(nil)
                return
            }
            
            guard let safeData = data else {
                complition(nil)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(CurrencyRates.self, from: safeData)
                complition(result)
            } catch {
                print(error.localizedDescription)
                complition(nil)
            }
        }.resume()
    }
}

//
//  CurrencyRates.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 12.06.2022.
//

import Foundation

struct CurrencyRates: Codable {
    let result: String
    let timeLastUpdateUnix: Int
    let timeLastUpdateUTC: String
    let timeNextUpdateUnix: Int
    let timeNextUpdateUTC, baseCode: String
    let conversionRates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case result
        case timeLastUpdateUnix = "time_last_update_unix"
        case timeLastUpdateUTC = "time_last_update_utc"
        case timeNextUpdateUnix = "time_next_update_unix"
        case timeNextUpdateUTC = "time_next_update_utc"
        case baseCode = "base_code"
        case conversionRates = "conversion_rates"
    }
}

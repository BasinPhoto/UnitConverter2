//
//  Formatter+Extension.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 20.08.2022.
//

import Foundation

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.maximumFractionDigits = 8
        return formatter
    }()
}

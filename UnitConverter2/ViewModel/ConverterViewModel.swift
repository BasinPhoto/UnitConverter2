//
//  ConverterViewModel.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 30.11.2020.
//

import Foundation
import SwiftUI

class ConverterViewModel: ObservableObject {
    
    @Published var type: UnitType = .length
    @Published var amountInString = "0"
    @Published var selectedFrom: Int = 0
    @Published var selectedTo: Int = 0
    var temporaryValue: String = ""

    var valuesArray: [String : Double] {
        return values[type.rawValue]
    }
    
    var keysArray: [String] {
        valuesArray.keys.sorted()
    }
    
    var result: Double {
        guard let amount = Double(amountInString) else { return 0 }
        let selectedFromKey = keysArray[selectedFrom]
        let selectedToKey = keysArray[selectedTo]
        let valueFrom = valuesArray[selectedFromKey]!
        let valueTo = valuesArray[selectedToKey]!
        return amount * valueFrom / valueTo
    }
    
}

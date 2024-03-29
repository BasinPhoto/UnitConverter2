//
//  ConverterViewModel.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 30.11.2020.
//

import Foundation
import Combine
import SwiftUI

class ConverterViewModel: ObservableObject {
    
    @Published var type: UnitType = .length {
        didSet {
            temporaryValue = ""
            selectedFrom = nil
            selectedTo = nil
        }
    }
    @Published var amountInString = "Value".localized()
    @Published var selectedFrom: Int?
    @Published var selectedTo: Int?
    
    let localeCurrencyCode = Locale.current.currencyCode
    
    var isBothValuesSelected: Bool {
            guard let _ = selectedFrom else { return false }
            guard let _ = selectedTo else { return false }
            
            return true
    }
    
    var temporaryValue: String = "" {
        didSet {
            print(temporaryValue)
        }
    }

    var valuesDictionary: [String : Double] {
        return UnitType.allValues[type.rawValue]
    }
    
    var keysArray: [String] {
        valuesDictionary.keys.sorted()
    }
    
    var result: Double? {
        
        guard let selectedFrom = selectedFrom else { return nil }
        guard let selectedTo = selectedTo else { return nil }
        
        let selectedFromKey = keysArray[selectedFrom]
        let selectedToKey = keysArray[selectedTo]
        let valueFrom = valuesDictionary[selectedFromKey]!
        let valueTo = valuesDictionary[selectedToKey]!
        
        guard valueTo != 0 else { return nil }
        
        var tmpResult : Double = 0
        
        guard let amount = Double(amountInString) else { return nil }

        switch type {
        case .money:
            tmpResult = (amount * valueTo / valueFrom)
        default:
            tmpResult =  (amount * valueFrom / valueTo)
        }
        
        let roundedValue = roundTo(tmpResult, toDecimalPlaces: 4)
        if roundedValue != 0 {
            return roundedValue
        }
        else {
            return tmpResult
        }
    }
    
    func roundTo(_ value: Double, toDecimalPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }
    
    func swapValues() {
        if result != nil {
            amountInString = result!.description
            selectedFrom = selectedTo
            selectedTo = nil
        } else {
            let tmp = selectedFrom
            selectedFrom = selectedTo
            selectedTo = tmp
        }
    }
    
}

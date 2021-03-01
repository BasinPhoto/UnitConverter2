//
//  ConverterViewModel.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 30.11.2020.
//

import Foundation
import Combine

class ConverterViewModel: ObservableObject {
    
    @Published var type: UnitType = .length {
        didSet {
            amountInString = "0"
            temporaryValue = "0"
            selectedFrom = nil
            selectedTo = nil
        }
    }
    @Published var amountInString = "0"
    @Published var selectedFrom: Int?
    @Published var selectedTo: Int?
    
    var isBothValuesSelected: Bool {
            guard let _ = selectedFrom else { return false }
            guard let _ = selectedTo else { return false }
            
            return true
    }
    
    var temporaryValue: String = "0"

    var valuesDictionary: [String : Double] {
        return UnitType.allValues[type.rawValue]
    }
    
    var keysArray: [String] {
        valuesDictionary.keys.sorted()
    }
    
    var result: Double {
        
        guard let selectedFrom = selectedFrom else { return 0 }
        guard let selectedTo = selectedTo else { return 0 }
        
        let selectedFromKey = keysArray[selectedFrom]
        let selectedToKey = keysArray[selectedTo]
        let valueFrom = valuesDictionary[selectedFromKey]!
        let valueTo = valuesDictionary[selectedToKey]!
        
        var tmpResult : Double = 0
        
        guard valueTo != 0 else { return 0 }
        
        guard let amount = Double(amountInString) else {
            if let tmpValue = Double(temporaryValue) {
                if type != .money { return roundTo(tmpValue * valueFrom / valueTo, toDecimalPlaces: 4) }
                else { return roundTo(tmpValue * valueTo / valueFrom, toDecimalPlaces: 4) }
            }
            else { return 0 }
        }

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
    
}

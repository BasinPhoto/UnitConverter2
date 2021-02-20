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
        
        guard valueTo != 0 else { return 0 }
        
        guard let amount = Double(amountInString) else {
            if let tmpValue = Double(temporaryValue) {
                if type != .money { return tmpValue * valueFrom / valueTo }
                else { return tmpValue * valueTo / valueFrom }
            }
            else { return 0 }
        }

        switch type {
        case .money:
            return amount * valueTo / valueFrom
        default:
            return amount * valueFrom / valueTo
        }
    }
    
}

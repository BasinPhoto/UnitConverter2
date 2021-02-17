//
//  ConverterViewModel.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 30.11.2020.
//

import Foundation
import SwiftUI

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
//        set {
//            if newValue == false {
//                selectedFrom = nil
//                selectedTo = nil
//            }
//        }
        
        get {
            guard let _ = selectedFrom else { return false }
            guard let _ = selectedTo else { return false }
            
            return true
        }
    }
    var temporaryValue: String = "0"

    var valuesDictionary: [String : Double] {
        return allValues[type.rawValue]
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
        
        guard let amount = Double(amountInString) else {
            if let tmpValue = Double(temporaryValue) { return tmpValue * valueFrom / valueTo }
            else { return 0 }
        }

        return amount * valueFrom / valueTo
    }
    
}

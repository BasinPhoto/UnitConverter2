//
//  ConverterViewModel.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 30.11.2020.
//

import Foundation
import SwiftUI

class ConverterViewModel: ObservableObject {
    
    @State var type: UnitType = .volume
    var amount: Double = 0
    @State var selectedFrom: Int = 0
    @State var selectredTo: Int = 0
    
    var valuesArray: [String : Double] {
        return values[type.rawValue]
    }
    
    var keysArray: [String] {
        valuesArray.keys.sorted()
    }
    
    var result: Double {
        let selectedFromKey = keysArray[selectedFrom]
        let selectedToKey = keysArray[selectredTo]
        let valueFrom = valuesArray[selectedFromKey]!
        let valueTo = valuesArray[selectedToKey]!
        return amount * valueFrom / valueTo
    }
    
}

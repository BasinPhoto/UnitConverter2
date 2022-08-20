//
//  ViewModel.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 30.11.2020.
//

import Foundation
import Combine
import SwiftUI

class ViewModel: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var unitType: UnitType = .length {
        didSet {
            selectedIndex1 = 0
            selectedIndex2 = 0
            tempSelectedIndex1 = 0
            tempSelectedIndex2 = 0
        }
    }
    
    @Published var selectedIndex1: Int = 0 {
        didSet {
            calc()
        }
    }
    @Published var tempSelectedIndex1: Int = 0
    
    @Published var selectedIndex2: Int = 0 {
        didSet {
            calc()
        }
    }
    @Published var tempSelectedIndex2: Int = 0
    
    @Published var inputValue: String = "0" {
        didSet {
            calc()
        }
    }
    @Published var resultValue: Double = 0
    
    @Published var operation: OperationType?
    @Published var operationValue: String = ""
    
    private var values: [Double] {
        let dict = UnitType.allValues[unitType.rawValue].sorted(by: {$0.key < $1.key})
        return dict.map({ $0.value })
    }
    
    func getCurrencies() async {
        guard let currencies = await NetworkManager.shared.fetchData() else {
            return
        }
        
        var result: [String: Double] = [:]
        for (key, value) in currencies.conversionRates {
            result[key + (UnitType.flags[key] ?? "")] = value
        }
        
        UnitType.allValues.append(result)
    }
    
    func spawValues() {
        let tmpSelectedIndex1 = selectedIndex1
        withAnimation(.default) {
            selectedIndex1 = selectedIndex2
            selectedIndex2 = tmpSelectedIndex1
        }
        tempSelectedIndex1 = selectedIndex1
        tempSelectedIndex2 = selectedIndex2
    }
    
    private func calc() {
        var returnedRsult: Double = 0

        if let value = Double(self.inputValue),
            selectedIndex1 <= values.count - 1 &&
            selectedIndex2 <= values.count - 1 {
            let valueFrom = values[self.selectedIndex1]
            let valueTo = values[self.selectedIndex2]

            switch unitType {
            case .money:
                returnedRsult = (value * valueTo / valueFrom)
            default:
                returnedRsult =  (value * valueFrom / valueTo)
            }

            self.resultValue = returnedRsult
        }
    }
}

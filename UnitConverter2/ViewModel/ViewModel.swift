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
            var preparedIndex1: Int = 0
            var preparedIndex2: Int = 0
            
            if unitType == .money, let localeIsoCode = Locale.current.currencyCode {
                preparedIndex1 = unitType.labels.firstIndex(where: {$0.prefix(3) == "USD"}) ?? 0
                preparedIndex2 = unitType.labels.firstIndex(where: {$0.prefix(3) == localeIsoCode}) ?? 0
            }
            
            selectedIndex1 = preparedIndex1
            selectedIndex2 = preparedIndex2
            tempSelectedIndex1 = preparedIndex1
            tempSelectedIndex2 = preparedIndex2
        }
    }
    
    @Published var selectedIndex1: Int = 0 {
        didSet {
            resultValue = calc(Double(inputValue) ?? 0)
        }
    }
    @Published var tempSelectedIndex1: Int = 0
    
    @Published var selectedIndex2: Int = 0 {
        didSet {
            resultValue = calc(Double(inputValue) ?? 0)
        }
    }
    @Published var tempSelectedIndex2: Int = 0
    
    @Published var inputValue: String = "0" {
        didSet {
            resultValue = calc(Double(inputValue) ?? 0)
        }
    }
    @Published var resultValue: Double = 0
    
    @Published var operation: OperationType?
    @Published var operationValue: String = ""
    
    private var values: [Double] {
        let dict = UnitType.allValues[unitType.rawValue].sorted(by: {$0.key < $1.key})
        return dict.map({ $0.value })
    }
    
    var oneLeft: Double {
        calc(1, indexFrom: selectedIndex1, indexTo: selectedIndex2)
    }
    
    var oneRight: Double {
        calc(1, indexFrom: selectedIndex2, indexTo: selectedIndex1)
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
    
    private func calc(_ value: Double, indexFrom: Int? = nil, indexTo: Int? = nil) -> Double {
        var returnedResult: Double = 0

        if selectedIndex1 <= values.count - 1 &&
            selectedIndex2 <= values.count - 1 {
            let valueFrom = values[indexFrom ?? selectedIndex1]
            let valueTo = values[indexTo ?? selectedIndex2]
            
            switch unitType {
            case .money:
                returnedResult = (value * valueTo / valueFrom)
            default:
                returnedResult =  (value * valueFrom / valueTo)
            }

        }
        return returnedResult
    }
}

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
    
    @Published var selection1: String = ""
    @Published var selection2: String = ""
    
    @Published var inputValue: String = "0"
    @Published var resultValue: Double = 0
    
    @Published var operation: OperationType?
    @Published var operationValue: String = ""
    
    private func calc() {
//        var returnedRsult: Double = 0
//
//        if let value = Double(self.inputValue) {
//            guard let valueFrom = self.valuesDictionary[self.selection1] else {
//                return
//            }
//            guard let valueTo = self.valuesDictionary[self.selection2] else {
//                return
//            }
//
//            switch self.type {
//            case .money:
//                returnedRsult = (value * valueTo / valueFrom)
//            default:
//                returnedRsult =  (value * valueFrom / valueTo)
//            }
//
//            self.resultValue = returnedRsult
//        }
    }
    
    init() {
        $inputValue
            .receive(on: RunLoop.main)
            .sink { _ in
                self.calc()
            }
            .store(in: &subscriptions)
    }
}

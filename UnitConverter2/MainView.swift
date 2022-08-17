//
//  MainView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 12.06.2022.
//

import SwiftUI
import Combine

struct MainView: View {
    @StateObject var viewModel = ViewModel()
    @State var unitType: UnitType = .time
    @State var selectedIndex1: Int = 0
    @State var selectedIndex2: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            TypePickerView(selectedUnitType: $unitType)
                .frame(height: 82)
                .padding(.vertical)
            
            Divider()
                .background(Color("primaryColor"))
            
            HStack(spacing: 0) {
                ValuePicker(unitType: unitType, selectedIndex: $selectedIndex1)
                ValuePicker(unitType: unitType, selectedIndex: $selectedIndex2)
            }
            .clipped()
            
            Divider()
                .background(Color("primaryColor"))
            
            ResultView(viewModel: viewModel)
            
            InputView(value: $viewModel.inputValue,
                      operation: $viewModel.operation,
                      operationValue: $viewModel.operationValue)
            .padding(.horizontal)
        }
        .onAppear {
            getCurrencies()
        }
    }
    
    private func getCurrencies()  {
        NetworkManager.fetchData(urlAPI: NetworkManager.urlAPI) { (requestResult) in
            DispatchQueue.main.async {
                if let fetchingResult = requestResult {
                    UnitType.allValues.append(fetchingResult.conversionRates)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

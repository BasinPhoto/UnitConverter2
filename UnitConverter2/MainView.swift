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

    var body: some View {
        VStack(spacing: 0) {
            TypePickerView(selectedUnitType: $viewModel.unitType)
                .frame(height: 82)
                .padding(.vertical)
                .zIndex(1)
            
            HStack(spacing: 0) {
                ValuePicker(unitType: viewModel.unitType, selectedIndex: $viewModel.selectedIndex1, tempSelectedIndex: $viewModel.tempSelectedIndex1)
                ValuePicker(unitType: viewModel.unitType, selectedIndex: $viewModel.selectedIndex2, tempSelectedIndex: $viewModel.tempSelectedIndex2)
            }
            .overlay(content: {
                Button {
                    viewModel.spawValues()
                } label: {
                    Image(systemName: "arrow.left.arrow.right.circle.fill")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 32, height: 32)
                        .foregroundColor(.white)
                }

            })
            .clipped()
            
            Group {
                Divider()
                    .background(Color("primaryColor"))
                
                ResultView(viewModel: viewModel)
                
                InputView(value: $viewModel.inputValue,
                          operation: $viewModel.operation,
                          operationValue: $viewModel.operationValue)
            }
            .zIndex(2)
        }
        .onAppear {
            getCurrencies()
        }
        .ignoresSafeArea()
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

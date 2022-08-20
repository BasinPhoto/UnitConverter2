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
                    Image(systemName: "arrow.left.arrow.right")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }

            })
            .clipped()
            .zIndex(-1)
            
            ResultView(viewModel: viewModel)
                .shadow(radius: 12)
            
            InputView(value: $viewModel.inputValue,
                      operation: $viewModel.operation,
                      operationValue: $viewModel.operationValue)

        }
        .task {
            await viewModel.getCurrencies()
        }
        .ignoresSafeArea()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

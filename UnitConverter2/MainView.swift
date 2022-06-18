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
            TypePickerView(items: UnitType.allCases, selection: $viewModel.type, colorSelection: Color("primaryColor"))
                .frame(height: 82)
                .padding(.bottom)
            
            Divider()
                .background(Color("primaryColor"))
            
            ZStack {
                HStack(spacing: 0) {
                    ValuePicker(items: viewModel.labels, selection: $viewModel.selection1, colorSelection: Color("primaryColor"))
                    ValuePicker(items: viewModel.labels, selection: $viewModel.selection2, colorSelection: Color("primaryColor"))
                }
                
                Button {
                    viewModel.leftToRight.toggle()
                } label: {
                    Image(systemName: viewModel.leftToRight ? "chevron.right" : "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                }
            }
            
            Divider()
                .background(Color("primaryColor"))
            
            ResultView(inputValue: $viewModel.inputValue,
                       inputValueDescription: viewModel.selection1,
                       resultValue: $viewModel.resultValue,
                       resultValueDescription: viewModel.selection2)
        
            InputView(value: $viewModel.inputValue)
                .padding(.horizontal)
        }
        .onAppear {
            viewModel.getCurrencies()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

//
//  MainView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 12.06.2022.
//

import SwiftUI
import Combine

class ViewModel: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()
    @Published var leftToRight: Bool = true
    @Published var selection1: String = ""
    @Published var selection2: String = ""
    
    @Published var inputValue: String = "0"
    @Published var resultValue: Double = 0
    
    @Published var type: UnitType = .time {
        didSet {
            selection1 = ""
            selection2 = ""
        }
    }
    
    var labels: [String] {
        type.labels
    }
    
    func getCurrencies() {
        NetworkManager.fetchData(urlAPI: NetworkManager.urlAPI) { (requestResult) in
            DispatchQueue.main.async {
                if let fetchingResult = requestResult {
                    UnitType.allValues.append(fetchingResult.conversionRates)
                }
            }
        }
    }
    
    private var valuesDictionary: [String : Double] {
        return UnitType.allValues[type.rawValue]
    }
    
    private var keysArray: [String] {
        valuesDictionary.keys.sorted()
    }
    
    private func calc() {
        var returnedRsult: Double = 0
        
        if let value = Double(self.inputValue) {
            guard let valueFrom = self.valuesDictionary[self.selection1] else {
                return
            }
            guard let valueTo = self.valuesDictionary[self.selection2] else {
                return
            }
            
            switch self.type {
            case .money:
                returnedRsult = (value * valueTo / valueFrom)
            default:
                returnedRsult =  (value * valueFrom / valueTo)
            }
            
            self.resultValue = returnedRsult
        }
    }
    
    init() {
        $inputValue
            .receive(on: RunLoop.main)
            .sink { _ in
                self.calc()
            }
            .store(in: &subscriptions)
        
        $type
            .receive(on: RunLoop.main)
            .sink { _ in
                self.calc()
            }
            .store(in: &subscriptions)
        
        $selection1
            .receive(on: RunLoop.main)
            .sink { _ in
                self.calc()
            }
            .store(in: &subscriptions)
        
        $selection2
            .receive(on: RunLoop.main)
            .sink { _ in
                self.calc()
            }
            .store(in: &subscriptions)
        
        $leftToRight
            .receive(on: RunLoop.main)
            .sink { _ in
                let tmp = self.selection1
                self.selection1 = self.selection2
                self.selection2 = tmp
            }
            .store(in: &subscriptions)
    }
}

struct MainView: View {
    @StateObject var viewModel = ViewModel()

    var body: some View {
        VStack {
            TypePickerView(items: UnitType.allCases, selection: $viewModel.type, colorSelection: Color("primaryColor"))
                .frame(height: 76)
            
            ZStack {
                HStack(spacing: 0) {
                    ValuePicker(items: viewModel.labels, selection: $viewModel.selection1, colorSelection: Color("primaryColor"))
                    ValuePicker(items: viewModel.labels, selection: $viewModel.selection2, colorSelection: Color("primaryColor"))
                }
                .frame(height: UIScreen.main.bounds.height / 2)
                .clipped()
                
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
            
            ResultView(inputValue: $viewModel.inputValue,
                       inputValueDescription: viewModel.selection1,
                       resultValue: $viewModel.resultValue,
                       resultValueDescription: viewModel.selection2)
        
            InputView(value: $viewModel.inputValue)
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

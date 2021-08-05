//
//  ContentView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 30.11.2020.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showAllCategories: Bool = false
    @State private var showPicker = false
    @State private var numberOfPicker: PickerSide = .left
    
    @ObservedObject var unit: ConverterViewModel
    
    let clipboard = UIPasteboard.general
    let generator = UINotificationFeedbackGenerator()
    
    @State private var isPresented = false
    @AppStorage("onboard") var onboard = true

    fileprivate func onTap() {
        if unit.amountInString == "" {
            unit.amountInString = unit.temporaryValue
        }
        showAllCategories = false
        if unit.isBothValuesSelected {
            showPicker = false
            numberOfPicker = .both
        } else {
            showPicker = true
        }
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    fileprivate func DragHandle() -> _ChangedGesture<DragGesture> {
        return DragGesture().onChanged { value in
            // hide and show dropdown menu by swipe
            if value.translation.width < -100 && showAllCategories == false {
                showPicker = false
                showAllCategories = true
            } else if value.translation.width > 100 && showAllCategories == true {
                showAllCategories = false
            }
            
            if !showAllCategories && value.translation.height > 150 {
                if !showPicker {
                    numberOfPicker = .both
                    showPicker = true
                }
            }
        }
    }
    
    fileprivate func getCurrencies() {
        NetworkManager.fetchData(urlAPI: NetworkManager.urlAPI) { (requestResult) in
            DispatchQueue.main.async {
                if let fetchingResult = requestResult {
                    UnitType.allValues.append(fetchingResult.conversionRates)
                    unit.objectWillChange.send()
                }
            }
        }
        
        numberOfPicker = .both
        showAllCategories = true
        
        isPresented = onboard
    }
    
    var body: some View {
        
        ZStack {
            Group {
                
                //Background rectangles
                Background()
                
                // pickers
                VStack {
                    
                    TypePicker(toVar: $unit.selectedFrom, showPicker: $showPicker, numberOfPicker: $numberOfPicker, backgroundColor: Color("primaryColor"), accentColor: Color("secondaryColor"))
                        .environmentObject(unit)
                        .offset(x: !showPicker || numberOfPicker == .right ? -UIScreen.main.bounds.width : 0, y: -15)
                    
                    TypePicker(toVar: $unit.selectedTo, showPicker: $showPicker, numberOfPicker: $numberOfPicker, backgroundColor: Color("secondaryColor"), accentColor: Color("primaryColor"))
                        .environmentObject(unit)
                        .offset(x: !showPicker || numberOfPicker == .left ? UIScreen.main.bounds.width : 0, y: 0)
                    
                }
                
                //type picker buttons
                TypePickerButtonsView(showAllCategories: $showAllCategories, showPicker: $showPicker, numberOfPicker: $numberOfPicker)
                    .environmentObject(unit)
                    
                //SwapButton
                SwapButton(showPicker: $showPicker, numberOfPicker: $numberOfPicker)
                    .environmentObject(unit)
                
                //input and output value fields
                IOFieldsView(showAllCategories: $showAllCategories, showPicker: $showPicker, numberOfPicker: $numberOfPicker)
                    .environmentObject(unit)
            }
            .blur(radius: showAllCategories ? 4 : 0)
            .scaleEffect(showAllCategories ? 1.2 : 1)
            
            //info button
            InfoButton(showAllCategories: $showAllCategories, showPicker: $showPicker, isPresented: $isPresented)
            
            //dropdown menu button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    DropDownMenu(showAllCategories: $showAllCategories, showPicker: $showPicker, numberOfPicker: $numberOfPicker)
                        .environmentObject(unit)
                        .padding(.bottom, 45)
                }
            }
        }
        .animation(.default)
        .onTapGesture {
            onTap()
        }
        .gesture(
            DragHandle()
        )
        .onAppear(perform: {
            getCurrencies()
            if let _ = UIPasteboard.general.string {
                guard let clipboardDouble = Double(UIPasteboard.general.string!) else {return}
                print(">>> clipboardValue is \(clipboardDouble)")
                unit.amountInString = String(clipboardDouble)
            }
        })
        .sheet(isPresented: $isPresented) {
            OnBoardView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(unit: ConverterViewModel())
    }
}

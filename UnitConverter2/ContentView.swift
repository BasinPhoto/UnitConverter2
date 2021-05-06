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
    
    @StateObject var unit: ConverterViewModel
    
    let clipboard = UIPasteboard.general
    let generator = UINotificationFeedbackGenerator()
    
    @State private var isPresented = false
    @AppStorage("onboard") var onboard = true

    var body: some View {
        
        ZStack {
            Group {
                
                //Background rectangles
                Background()
                
                //input and output value fields
                IOFieldsView(showAllCategories: $showAllCategories, showPicker: $showPicker, numberOfPicker: $numberOfPicker, unit: unit)
                
                // pickers
                VStack {
                    
                    TypePicker(toVar: $unit.selectedFrom, showPicker: $showPicker, numberOfPicker: $numberOfPicker, unit: unit, backgroundColor: Color("primaryColor"), accentColor: Color("secondaryColor"))
                        .offset(x: !showPicker || numberOfPicker == .right ? -UIScreen.main.bounds.width : 0, y: -15)
                    
                    TypePicker(toVar: $unit.selectedTo, showPicker: $showPicker, numberOfPicker: $numberOfPicker, unit: unit, backgroundColor: Color("secondaryColor"), accentColor: Color("primaryColor"))
                        .offset(x: !showPicker || numberOfPicker == .left ? UIScreen.main.bounds.width : 0, y: 0)
                    
                }
                
                //type picker buttons
                TypePickerButtonsView(showAllCategories: $showAllCategories, showPicker: $showPicker, numberOfPicker: $numberOfPicker, unit: unit)
        
            }
            .blur(radius: showAllCategories ? 4 : 0)
            .scaleEffect(showAllCategories ? 1.2 : 1)
            
            //info button
            VStack {
                Spacer()
                
                HStack {
                    if !showAllCategories, !showPicker {
                        Button(action: {
                            isPresented.toggle()
                        }, label: {
                            Image(systemName: "info")
                                .font(.system(size: 46))
                                .frame(width: 45, height: 45)
                                .padding(10)
                                .foregroundColor(Color("secondaryColor"))
                                .background(Color("primaryColor"))
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color("secondaryColor"), lineWidth: 2))
                                .padding(.leading, 30)
                                .shadow(color: Color("shadowColor").opacity(0.7), radius: 10, x: 6, y: 6)
                        })
                        .padding(.bottom, 45)
                        .transition(.move(edge: .bottom))
                        
                        Spacer()
                    }
                }
            }
            
            //dropdown menu button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    DropDownMenu(showAllCategories: $showAllCategories, showPicker: $showPicker, numberOfPicker: $numberOfPicker ,unit: unit)
                        .padding(.bottom, 45)
                }
            }
        }
        .animation(.easeInOut)
        .onTapGesture {
            if unit.amountInString == "" {
                unit.amountInString = unit.temporaryValue
            }
            showAllCategories = false
            if unit.isBothValuesSelected {
                showPicker = false
            } else {
                showPicker = true
            }
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .gesture(
            DragGesture().onChanged { value in
                // hide and show dropdown menu by swipe
                if value.translation.width < -100 && showAllCategories == false {
                    showPicker = false
                    showAllCategories = true
                } else if value.translation.width > 100 && showAllCategories == true {
                    showAllCategories = false
                }
                
                // copy result to amount
                if !showAllCategories {
                    if let result = unit.result, value.translation.height < -150 && result > 0 {
                        if !showPicker {
                            unit.amountInString = result.description
                            unit.selectedFrom = unit.selectedTo
                            unit.selectedTo = nil
                            numberOfPicker = .right
                            showPicker = true
                            generator.prepare()
                            generator.notificationOccurred(.success)
                        }
                    } else if value.translation.height > 150 {
                        if !showPicker {
                            numberOfPicker = .both
                            showPicker = true
                        }
                    }
                }
            }
        )
        .onAppear(perform: {
            
            NetworkManager.fetchData(urlAPI: NetworkManager.urlAPI) { (requestResult) in
                DispatchQueue.main.async {
                    if let fetchingResult = requestResult {
                        UnitType.allValues.append(fetchingResult.conversionRates)
                    }
                }
            }
            
            numberOfPicker = .both
            showAllCategories = true
            
            isPresented = onboard
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

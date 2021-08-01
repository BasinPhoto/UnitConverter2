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
                if !showPicker {
                    Button(action: {
                        if unit.result != nil {
                            unit.swapValues()
                            numberOfPicker = .right
                            showPicker.toggle()
                        } else {
                            unit.swapValues()
                        }
                    }, label: {
                        HStack(spacing: -25, content: {
                            Image("arrow")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Color("secondaryColor"))
                                .frame(width: 35, height: 35)
                            
                            Image("arrow")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Color("primaryColor"))
                                .frame(width: 35, height: 35)
                                .rotationEffect(.degrees(180))
                        })
                    })
                    .rotationEffect(.degrees(-45))
                    .transition(.scale)
                }
                
                //input and output value fields
                IOFieldsView(showAllCategories: $showAllCategories, showPicker: $showPicker, numberOfPicker: $numberOfPicker)
                    .environmentObject(unit)
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
                        .transition(.move(edge: .leading))
                        Spacer()
                    }
                }
            }
            
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
        .gesture(
            DragGesture().onChanged { value in
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
        )
        .onAppear(perform: {
            
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

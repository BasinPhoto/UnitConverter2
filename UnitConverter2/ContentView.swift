//
//  ContentView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 30.11.2020.
//

import SwiftUI


struct ContentView: View {
    
    @State var showAllCategories: Bool = false
    @State var inFocus: Bool = false
    @State var showPicker = false
    @State private var numberOfPicker: Int = 1
    
    @StateObject var unit: ConverterViewModel

    var body: some View {
        
        ZStack{
            //Background rectangles
            VStack(spacing: 0){
                Color("ColorBack")
                Color.white
            }.ignoresSafeArea(.all)
            
            //All interface logic
            VStack {
                TextField(unit.amountInString, text: $unit.amountInString)
                    .padding(.horizontal)
                    .font(.system(size: 60, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(.white)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 100)
                    .offset(y: UIScreen.main.bounds.height / -5)
                    .disabled(showAllCategories)
                    .onTapGesture {
                        unit.temporaryValue = unit.amountInString
                        unit.amountInString = ""
                        inFocus = true
                        showAllCategories = false
                        showPicker = false
                    }
                
                HStack(spacing: 0) {
                    
                    if showPicker && numberOfPicker == 1 {
                        TypePicker(toVar: $unit.selectedFrom, showPicker: $showPicker, unit: unit)
                    } else {
                        Button(action: {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            if showPicker && numberOfPicker == 2 {
                                numberOfPicker = 1
                            } else {
                                numberOfPicker = 1
                                self.showPicker.toggle()
                            }
                        }, label: {
                            Text(unit.keysArray[unit.selectedFrom])
                                .font(Font.custom("Exo2", size: 24))
                                .lineLimit(1)
                                .minimumScaleFactor(0.3)
                        })
                        .padding()
                        .frame(width: UIScreen.main.bounds.width / 2)
                        .background(Color("ColorBack"))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    }
                    
                    if showPicker && numberOfPicker == 2 {
                        TypePicker(toVar: $unit.selectedTo, showPicker: $showPicker, unit: unit)
                    } else {
                        Button(action: {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            if showPicker && numberOfPicker == 1 {
                                numberOfPicker = 2
                            } else {
                                numberOfPicker = 2
                                self.showPicker.toggle()
                            }
                        }, label: {
                            Text(unit.keysArray[unit.selectedTo])
                                .font(.title2)
                                .lineLimit(1)
                                .minimumScaleFactor(0.3)
                        })
                        .padding()
                        .frame(width: UIScreen.main.bounds.width / 2)
                        .background(Color.white)
                        .foregroundColor(Color("ColorBack"))
                        .cornerRadius(15)
                    }
                }
                
                Text("\(unit.result, specifier: "%g")")
                    .padding(.horizontal)
                    .foregroundColor(Color("ColorBack"))
                    .font(.system(size: 60, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 100)
                    .offset(y: UIScreen.main.bounds.height / 7)
                    .disabled(showAllCategories)
            }
            
            //Dropdown menu
            VStack {
                Spacer()
                
                HStack {
                    if !showPicker {
                        Spacer()
                        DropDownMenu(showAllCategories: $showAllCategories, unit: unit)
                            .padding(35)
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onTapGesture {
            if unit.amountInString == "" {
                unit.amountInString = unit.temporaryValue
            }
            inFocus = false
            showPicker = false
            showAllCategories = false
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .gesture(
            DragGesture().onChanged { value in
                if value.translation.width < 0 {
                    showAllCategories = true
                } else {
                    showAllCategories = false
                }
                
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(unit: ConverterViewModel())
    }
}

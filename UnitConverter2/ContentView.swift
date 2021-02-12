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
    
    let clipboard = UIPasteboard.general

    var body: some View {
        
        ZStack{
            //Background rectangles
            VStack(spacing: 0){
                Color("ColorBack")
                Color.white
            }.ignoresSafeArea(.all)
            
            //input and output value fields
            VStack {
                if !showAllCategories {
                    if showPicker && numberOfPicker == 1 {
                        TypePicker(toVar: $unit.selectedFrom, showPicker: $showPicker, unit: unit, backgroungColor: Color("ColorBack"), accentColor: .white)
                            .offset(y: -150)
                    } else {
                        TextField(unit.amountInString, text: $unit.amountInString)
                            .padding(.horizontal)
                            .font(Font.custom("Exo 2", size: 60))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.white)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.main.bounds.width - 32, height: 100)
                            .offset(y: UIScreen.main.bounds.height / -7)
                            .accentColor(.white)
                            .onTapGesture {
                                unit.temporaryValue = unit.amountInString
                                unit.amountInString = ""
                                inFocus = true
                                showAllCategories = false
                                showPicker = false
                            }
                    }
                }
                
                if !showAllCategories {
                    if showPicker && numberOfPicker == 2 {
                        TypePicker(toVar: $unit.selectedTo, showPicker: $showPicker, unit: unit, backgroungColor: .white, accentColor: Color("ColorBack"))
                            .offset(y: 150)
                    } else {
                        Text("\(unit.result, specifier: "%g")")
                            .padding(.horizontal)
                            .foregroundColor(Color("ColorBack"))
                            .font(Font.custom("Exo 2", size: 60))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.main.bounds.width - 32, height: 100)
                            .offset(y: UIScreen.main.bounds.height / 7)
                            .onTapGesture(count: 2) {
                                if unit.result != 0 {
                                    clipboard.string = String(unit.result)
                                }
                            }
                    }
                }
            }
            
            // pickers
            
            //type picker buttons
            HStack(spacing: 0) {

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
                        .font(Font.custom("Exo 2", size: 24).bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.3)
                })
                .padding()
                .frame(width: UIScreen.main.bounds.width / 2, height: 60)
                .background(Color("ColorBack"))
                .foregroundColor(.white)
                .cornerRadius(25)

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
                        .font(Font.custom("Exo 2", size: 24).bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.3)
                })
                .padding()
                .frame(width: UIScreen.main.bounds.width / 2, height: 60)
                .background(Color.white)
                .foregroundColor(Color("ColorBack"))
                .cornerRadius(25)
            }
            
            //Dropdown menu
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    if !showPicker {
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
                    showPicker = false
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

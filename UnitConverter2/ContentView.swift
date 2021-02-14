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
    @State private var numberOfPicker: Int = 0
    
    @StateObject var unit: ConverterViewModel
    
    let clipboard = UIPasteboard.general

    var body: some View {
        
        ZStack{
            //Background rectangles
            VStack(spacing: 0){
                Color("primaryColor")
                Color.white
            }.ignoresSafeArea(.all)
            
            //input and output value fields
            VStack {
                TextField(unit.amountInString, text: $unit.amountInString)
                    .font(Font.custom("Exo 2", size: 60))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .foregroundColor(inFocus ? Color("primaryColor") : .white)
                    .accentColor(Color("primaryColor"))
                    .background(inFocus ? Color.white : Color("primaryColor"))
                    .cornerRadius(30)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 100)
                    .shadow(color: inFocus ? Color.black.opacity(0.2) : Color.black.opacity(0), radius: inFocus ? 10 : 0, y: inFocus ? 10 : 0)
                    .offset(x: showPicker && numberOfPicker == 1 ? UIScreen.main.bounds.width : 0 , y: UIScreen.main.bounds.height / -6)
                    .disabled(showAllCategories)
                    .onTapGesture {
                        unit.temporaryValue = unit.amountInString
                        unit.amountInString = ""
                        inFocus = true
                        showAllCategories = false
                        showPicker = false
                    }
                    .animation(.easeIn)
                
                Text("\(unit.result, specifier: "%g")")
                    .padding(.horizontal)
                    .foregroundColor(Color("primaryColor"))
                    .font(Font.custom("Exo 2", size: 60))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 100)
                    .offset(x: showPicker && numberOfPicker == 2 ? -UIScreen.main.bounds.width : 0 , y: UIScreen.main.bounds.height / 7)
                    .onTapGesture(count: 2) {
                        if unit.result != 0 {
                            clipboard.string = String(unit.result)
                        }
                    }
                    .animation(.easeIn)
            }
            
            // pickers
            VStack{
                
                TypePicker(toVar: $unit.selectedFrom, showPicker: $showPicker, unit: unit, backgroungColor: Color("primaryColor"), accentColor: .white)
                    .padding(.top, 50)
                    .offset(x: !showPicker || numberOfPicker == 2 ? -UIScreen.main.bounds.width : 0, y: -10)
                    .animation(.easeIn)
                
                TypePicker(toVar: $unit.selectedTo, showPicker: $showPicker, unit: unit, backgroungColor: .white, accentColor: Color("primaryColor"))
                    .offset(x: !showPicker || numberOfPicker == 1 ? UIScreen.main.bounds.width : 0, y: 0)
                    .animation(.easeIn)
            }
            
            //type picker buttons
            HStack(spacing: 0) {
                
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            numberOfPicker = 1
                            self.showPicker.toggle()
                    }, label: {
                        if !showPicker {
                        Text(unit.keysArray[unit.selectedFrom])
                            .font(Font.custom("Exo 2", size: 24).bold())
                            .lineLimit(1)
                            .minimumScaleFactor(0.3)
                        }
                    })
                    .padding()
                    .frame(width: showPicker && numberOfPicker == 1 ? UIScreen.main.bounds.width : UIScreen.main.bounds.width / 2, height: 60)
                    .background(Color("primaryColor"))
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    .animation(.easeIn)

                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            numberOfPicker = 2
                            self.showPicker.toggle()
                    }, label: {
                        if !showPicker {
                        Text(unit.keysArray[unit.selectedTo])
                            .font(Font.custom("Exo 2", size: 24).bold())
                            .lineLimit(1)
                            .minimumScaleFactor(0.3)
                        }
                    })
                    .padding()
                    .frame(width: showPicker && numberOfPicker == 2 ? UIScreen.main.bounds.width : UIScreen.main.bounds.width / 2, height: 60)
                    .background(Color.white)
                    .foregroundColor(Color("primaryColor"))
                    .cornerRadius(25)
                    .animation(.easeIn)
            }
            .offset(x: showPicker && numberOfPicker == 1 ? UIScreen.main.bounds.width / 4 : 0)
            .offset(x: showPicker && numberOfPicker == 2 ? UIScreen.main.bounds.width / -4 : 0)
            
            //dropdown menu
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    DropDownMenu(showAllCategories: $showAllCategories, unit: unit)
                        .padding(.trailing, 30)
                        .padding(.bottom, 90)
                        .animation(.easeIn)
                }
            }
            .offset(y: showPicker ? 100 : 0)
        }
        .ignoresSafeArea(.keyboard)
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
                    inFocus = false
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

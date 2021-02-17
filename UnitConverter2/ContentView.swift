//
//  ContentView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 30.11.2020.
//

import SwiftUI

enum PickerSide: Int {
    case both
    case left
    case right
}

struct ContentView: View {
    
    @State var showAllCategories: Bool = false
    @State var inFocus: Bool = false
    @State var showPicker = false
    @State var numberOfPicker: PickerSide = .left
    
    @StateObject var unit: ConverterViewModel
    
    let clipboard = UIPasteboard.general

    var body: some View {
        
        ZStack{
            Group {
                //Background rectangles
                VStack(spacing: 0){
                    Color("primaryColor")
                    Color.white
                }
                
                //input and output value fields
                VStack {
                    
                    Group {
                        if showPicker && numberOfPicker == .right {
                            Text("\(unit.keysArray[unit.selectedTo ?? 0])")
                        } else {
                            Text("\(unit.result, specifier: "%g")")
                                .padding(.horizontal)
                                .onTapGesture(count: 2) {
                                    let generator = UINotificationFeedbackGenerator()
                                    if unit.result != 0 {
                                        clipboard.string = String(unit.result)
                                        generator.prepare()
                                        generator.notificationOccurred(.success)
                                    } else {
                                        generator.notificationOccurred(.error)
                                    }
                                }
                        }
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 100)
                    .offset(x: showPicker && numberOfPicker == .left ? UIScreen.main.bounds.width : 0 , y: UIScreen.main.bounds.height / -6)
                    
                    Group {
                        if showPicker && numberOfPicker == .left {
                            Text("\(unit.keysArray[unit.selectedFrom ?? 0])")
                                .foregroundColor(Color("primaryColor"))
                        } else {
                            TextField(unit.amountInString, text: $unit.amountInString)
                                .keyboardType(.decimalPad)
                                .foregroundColor(Color("primaryColor"))
                                .accentColor(Color("primaryColor"))
                                .background(Color.white)
                                .cornerRadius(30)
                                .shadow(color: inFocus ? Color("primaryColor").opacity(0.8) : Color.black.opacity(0), radius: inFocus ? 20 : 0, y: inFocus ? 10 : 0)
                                .disabled(showAllCategories)
                                .onTapGesture {
                                    inFocus = true
                                    showAllCategories = false
                                    showPicker = false
                                    unit.temporaryValue = unit.amountInString
                                    unit.amountInString = ""
                                }
                            
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width - 32, height: 100)
                    .offset(x: showPicker && numberOfPicker == .right ? -UIScreen.main.bounds.width : 0 , y: UIScreen.main.bounds.height / 7)
                    
                }
                .font(Font.custom("Exo 2", size: 60))
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                
                // pickers
                VStack{
                    
                    TypePicker(toVar: $unit.selectedTo, showPicker: $showPicker, unit: unit, backgroungColor: Color("primaryColor"), accentColor: .white)
                        .padding(.top, 50)
                        .offset(x: !showPicker || numberOfPicker == .right ? -UIScreen.main.bounds.width : 0, y: -15)
                    
                    TypePicker(toVar: $unit.selectedFrom, showPicker: $showPicker, unit: unit, backgroungColor: .white, accentColor: Color("primaryColor"))
                        .offset(x: !showPicker || numberOfPicker == .left ? UIScreen.main.bounds.width : 0, y: 0)
                }
                
                //type picker buttons
                HStack(spacing: 0) {
                    
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        numberOfPicker = .left
                        self.showPicker.toggle()
                    }, label: {
                        if let selectedTo = unit.selectedTo {
                            Text(unit.keysArray[selectedTo])
                        } else {
                            EmptyView()
                        }
                    })
                    .padding()
                    .frame(width: showPicker && numberOfPicker == .left ? UIScreen.main.bounds.width : UIScreen.main.bounds.width / 2, height: 60)
                    .background(Color("primaryColor"))
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        numberOfPicker = .right
                        self.showPicker.toggle()
                    }, label: {
                        if let selectedFrom = unit.selectedFrom {
                            Text(unit.keysArray[selectedFrom])
                        } else {
                            EmptyView()
                        }
                    })
                    .padding()
                    .frame(width: showPicker && numberOfPicker == .right ? UIScreen.main.bounds.width : UIScreen.main.bounds.width / 2, height: 60)
                    .background(Color.white)
                    .foregroundColor(Color("primaryColor"))
                    .cornerRadius(25)
                }
                .font(Font.custom("Exo 2", size: 24).bold())
                .lineLimit(1)
                .minimumScaleFactor(0.3)
                .disabled(showAllCategories)
                .offset(x: showPicker && numberOfPicker == .left ? UIScreen.main.bounds.width / 4 : 0)
                .offset(x: showPicker && numberOfPicker == .right ? UIScreen.main.bounds.width / -4 : 0)
                
            }
            .blur(radius: showAllCategories ? 8 : 0)
            
            //dropdown menu
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    DropDownMenu(showAllCategories: $showAllCategories, showPicker: $showPicker, numberOfPicker: $numberOfPicker ,unit: unit)
                        .padding(.trailing, 30)
                        .padding(.bottom, 90)
                }
            }
            .offset(x: showPicker ? -100 : 0,y: showPicker ? 200 : 0)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .animation(.easeInOut(duration: 0.2))
        .onTapGesture {
            if unit.amountInString == "" {
                unit.amountInString = unit.temporaryValue
            }
            inFocus = false
            showAllCategories = false
            if unit.isBothValuesSelected {
                showPicker = false
            }
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .gesture(
            // hide and show dropdown menu by swipe
            DragGesture().onChanged { value in
                if value.translation.width < 0 && value.translation.width < -100 {
                    showPicker = false
                    inFocus = false
                    showAllCategories = true
                } else if value.translation.width > 0 && value.translation.width > 100 {
                    showAllCategories = false
                }
                
            }
        )
        .onAppear(perform: {
            showAllCategories = true
            numberOfPicker = .both
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(unit: ConverterViewModel())
    }
}

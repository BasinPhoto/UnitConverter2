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
    let generator = UINotificationFeedbackGenerator()

    var body: some View {
        
        ZStack {
            Group {
                
                //Background rectangles
                VStack(spacing: 0){
                    Color("primaryColor")
                        .ignoresSafeArea()
                    Color.white
                        .ignoresSafeArea()
                }
                
                //input and output value fields
                VStack {
                    
                    Group {
                        if showPicker && numberOfPicker == .right {
                            if let selectedFrom = unit.selectedFrom {
                                if let amount = Double(unit.amountInString), amount != 0 {
                                    Text("\(unit.amountInString) \n \"\(unit.keysArray[selectedFrom])\" \n конвертируем в...")
                                        .foregroundColor(.white)
                                        .lineLimit(3)
                                        .onTapGesture(count: 2) {
                                            guard let tmpValue = Double(unit.amountInString) else { return }
                                            unit.amountInString = String(Int(tmpValue))
                                            generator.prepare()
                                            generator.notificationOccurred(.success)
                                        }
                                } else {
                                    Text("\"\(unit.keysArray[selectedFrom])\" \n конвертируем в")
                                        .foregroundColor(.white)
                                        .lineLimit(2)
                                }
                            }
                        } else {
                            TextField(unit.amountInString, text: $unit.amountInString)
                                .keyboardType(.decimalPad)
                                .foregroundColor(inFocus ? Color("primaryColor") : .white)
                                .accentColor(Color("primaryColor"))
                                .background(inFocus ? Color.white : Color("primaryColor"))
                                .cornerRadius(30)
                                .shadow(color: inFocus ? Color.black.opacity(0.4) : Color.blue.opacity(0), radius: inFocus ? 20 : 0, y: inFocus ? 10 : 0)
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
                    .disabled(showAllCategories)
                    .frame(width: UIScreen.main.bounds.width - 32)
                    .offset(x: showPicker && (numberOfPicker == .left || numberOfPicker == .both) ? UIScreen.main.bounds.width : 0,
                            y: UIScreen.main.bounds.height / -6)
                    
                    Group {
                        if showPicker && numberOfPicker == .left {
                            if let selectedTo = unit.selectedTo {
                                Text("конвертируем в \n \"\(unit.keysArray[selectedTo])\"")
                                    .lineLimit(2)
                            }
                        } else {
                            Text("\(unit.result, specifier: "%g")")
                                .padding(.horizontal)
                                .onTapGesture(count: 2) {
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
                    .foregroundColor(Color("primaryColor"))
                    .frame(width: UIScreen.main.bounds.width - 32)
                    .offset(x: showPicker && (numberOfPicker == .right || numberOfPicker == .both) ? -UIScreen.main.bounds.width : 0 , y: UIScreen.main.bounds.height / 6)
                    
                }
                .font(Font.custom("Exo 2", size: 60))
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.3)
                
                // pickers
                VStack {
                    
                    TypePicker(toVar: $unit.selectedFrom, showPicker: $showPicker, unit: unit, backgroundColor: Color("primaryColor"), accentColor: .white)
                        .offset(x: !showPicker || numberOfPicker == .right ? -UIScreen.main.bounds.width : 0, y: -15)
                    
                    TypePicker(toVar: $unit.selectedTo, showPicker: $showPicker, unit: unit, backgroundColor: .white, accentColor: Color("primaryColor"))
                        .offset(x: !showPicker || numberOfPicker == .left ? UIScreen.main.bounds.width : 0, y: 0)
                    
                }
                
                //type picker buttons
                HStack(spacing: 0) {
                    
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        if unit.isBothValuesSelected {
                            numberOfPicker = .left
                            self.showPicker.toggle()
                        }
                    }, label: {
                        if let selectedFrom = unit.selectedFrom {
                            Text(unit.keysArray[selectedFrom])
                        } else {
                            Text("(Из...)")
                        }
                    })
                    .padding()
                    .frame(width: showPicker && numberOfPicker == .left ? UIScreen.main.bounds.width : UIScreen.main.bounds.width / 2, height: 60)
                    .background(Color("primaryColor"))
                    .foregroundColor(Color.white)
                    .cornerRadius(25)
                    
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        if unit.isBothValuesSelected {
                            numberOfPicker = .right
                            self.showPicker.toggle()
                        }
                    }, label: {
                        if let selectedTo = unit.selectedTo {
                            Text(unit.keysArray[selectedTo])
                        } else {
                            Text("(В...)")
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
            .blur(radius: showAllCategories ? 4 : 0)
            .scaleEffect(showAllCategories ? 1.2 : 1)
            
//            //dropdown menu
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    DropDownMenu(showAllCategories: $showAllCategories, showPicker: $showPicker, numberOfPicker: $numberOfPicker ,unit: unit)
                        .offset(y: -45)
                }
            }
        }
        .animation(.easeInOut)
        .onTapGesture {
            if unit.amountInString == "" {
                unit.amountInString = unit.temporaryValue
            }
            inFocus = false
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
                    inFocus = false
                    showAllCategories = true
                } else if value.translation.width > 100 && showAllCategories == true {
                    showAllCategories = false
                }
                
                // copy result to amount
                if !showAllCategories {
                    if value.translation.height < -200 && unit.result > 0 {
                        if !showPicker {
                            unit.amountInString = unit.result.description
                            unit.selectedFrom = unit.selectedTo
                            unit.selectedTo = nil
                            numberOfPicker = .right
                            showPicker = true
                            generator.prepare()
                            generator.notificationOccurred(.success)
                        }
                    }
                }
            }
        )
        .onAppear(perform: {
            
            NetworkManager.fetchData(urlAPI: NetworkManager.urlAPI) { (result) in
                DispatchQueue.main.async {
                    if let fetchingResult = result {
                        UnitType.allValues.append(fetchingResult.conversionRates)
                    }
                }
            }
            
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

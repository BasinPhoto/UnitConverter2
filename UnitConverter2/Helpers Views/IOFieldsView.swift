//
//  IOFieldsView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 01.03.2021.
//

import SwiftUI

struct IOFieldsView: View {
    
    @Binding var showAllCategories: Bool
    @Binding var inFocus: Bool
    @Binding var showPicker: Bool
    @Binding var numberOfPicker: PickerSide
    
    @StateObject var unit: ConverterViewModel
    
    let clipboard = UIPasteboard.general
    let generator = UINotificationFeedbackGenerator()

    var body: some View {
        VStack {
            
            Group {
                if showPicker && numberOfPicker == .right {
                    if let selectedFrom = unit.selectedFrom {
                        if let amount = Double(unit.amountInString), amount != 0 {
                            Text("\(unit.amountInString) \n \"\(unit.keysArray[selectedFrom])\" \n конвертируем в...")
                                .foregroundColor(Color("secondaryColor"))
                                .lineLimit(3)
                                .onTapGesture(count: 2) {
                                    guard let tmpValue = Double(unit.amountInString), tmpValue > 1 else { return }
                                    unit.amountInString = String(Int(tmpValue))
                                    generator.prepare()
                                    generator.notificationOccurred(.success)
                                }
                        } else {
                            Text("\"\(unit.keysArray[selectedFrom])\" \n конвертируем в")
                                .foregroundColor(Color("secondaryColor"))
                                .lineLimit(2)
                        }
                    }
                } else {
                    TextField(unit.amountInString, text: $unit.amountInString)
                        .keyboardType(.decimalPad)
                        .foregroundColor(inFocus ? Color("primaryColor") : Color("secondaryColor"))
                        .accentColor(Color("primaryColor"))
                        .background(inFocus ? Color("secondaryColor") : Color("primaryColor"))
                        .cornerRadius(30)
                        .shadow(color: Color("shadowColor").opacity(0.7), radius: inFocus ? 20 : 0, y: inFocus ? 10 : 0)
                        .disabled(showAllCategories)
                        .onTapGesture {
                            if !inFocus {
                                inFocus = true
                                showAllCategories = false
                                showPicker = false
                                unit.temporaryValue = unit.amountInString
                                unit.amountInString = ""
                            }
                        }
                        .onChange(of: unit.amountInString, perform: { _ in
                            unit.amountInString = unit.amountInString.replacingOccurrences(of: ",", with: ".")
                        })
                    
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
    }
}


struct IOFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        IOFieldsView(showAllCategories: .constant(false), inFocus: .constant(false), showPicker: .constant(false), numberOfPicker: .constant(.both), unit: ConverterViewModel())
    }
}

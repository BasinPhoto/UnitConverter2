//
//  IOFieldsView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 01.03.2021.
//

import SwiftUI

struct IOFieldsView: View {
    
    @Binding var showAllCategories: Bool
    @Binding var showPicker: Bool
    @Binding var numberOfPicker: PickerSide
    
    @StateObject var unit: ConverterViewModel
    
    let clipboard = UIPasteboard.general
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        GeometryReader { geoProxy in
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
                        if !showPicker {
                            TextField(unit.amountInString, text: $unit.amountInString)
                                .keyboardType(.decimalPad)
                                .accentColor(Color("primaryColor"))
                                .background(Color("secondaryColor"))
                                .foregroundColor(Color("primaryColor"))
                                .cornerRadius(15)
                                .disabled(showAllCategories)
                                .onTapGesture {
                                    showAllCategories = false
                                    showPicker = false
                                    unit.temporaryValue = unit.amountInString
                                    unit.amountInString = ""
                                }
                                .onChange(of: unit.amountInString, perform: { _ in
                                    unit.amountInString = unit.amountInString.replacingOccurrences(of: ",", with: ".")
                                })
                            
                        } else { Spacer() }
                    }
                }
                .disabled(showAllCategories)
                .frame(idealWidth: geoProxy.size.width, maxHeight: .infinity)
                .padding(.horizontal, 16)
                .transition(.move(edge: .top))
                
                Group {
                    if showPicker && numberOfPicker == .left {
                        if let selectedTo = unit.selectedTo {
                            Text("конвертируем в \n \"\(unit.keysArray[selectedTo])\"")
                                .lineLimit(2)
                        }
                    } else {
                        if !showPicker {
                            if let result = unit.result, result > 0 {
                                Text("\(result, specifier: "%g")")
                                    .padding(.horizontal)
                                    .lineLimit(1)
                                    .onTapGesture(count: 2) {
                                        if unit.result != 0 {
                                            clipboard.string = String(result)
                                            generator.prepare()
                                            generator.notificationOccurred(.success)
                                        } else {
                                            generator.notificationOccurred(.error)
                                        }
                                    }
                            } else {
                                Text("...")
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity)
                            }
                        } else { Spacer() }
                    }
                }
                .foregroundColor(Color("primaryColor"))
                .frame(idealWidth: geoProxy.size.width, maxHeight: .infinity)
                .padding(16)
                .transition(.move(edge: .bottom))
                
            }
            .font(Font.custom("Exo 2", size: 50))
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .minimumScaleFactor(0.3)
        }
    }
}


struct IOFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        IOFieldsView(showAllCategories: .constant(false), showPicker: .constant(false), numberOfPicker: .constant(.both), unit: ConverterViewModel())
    }
}

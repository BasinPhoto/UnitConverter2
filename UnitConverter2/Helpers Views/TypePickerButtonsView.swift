//
//  TypePickerButtonsView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 01.03.2021.
//

import SwiftUI

struct TypePickerButtonsView: View {
    
    @Binding var showAllCategories: Bool
    @Binding var showPicker: Bool
    @Binding var numberOfPicker: PickerSide
    
    @StateObject var unit: ConverterViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            if numberOfPicker == .left || numberOfPicker == .both {
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    if unit.isBothValuesSelected {
                        numberOfPicker = numberOfPicker == .left ? .both : .left
                        self.showPicker.toggle()
                    }
                }, label: {
                    if let selectedFrom = unit.selectedFrom {
                        Text(unit.keysArray[selectedFrom])
                            .transition(.identity)
                    } else {
                        Text("(Из...)")
                            .transition(.identity)
                    }
                })
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("primaryColor"))
                .foregroundColor(Color("secondaryColor"))
                .cornerRadius(25)
                .transition(.move(edge: .leading))
            }
            
            if numberOfPicker == .right || numberOfPicker == .both {
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    if unit.isBothValuesSelected {
                        numberOfPicker = numberOfPicker == .right ? .both : .right
                        self.showPicker.toggle()
                    }
                }, label: {
                    if let selectedTo = unit.selectedTo {
                        Text(unit.keysArray[selectedTo])
                            .transition(.identity)
                    } else {
                        Text("(В...)").transition(.identity)
                    }
                })
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("secondaryColor"))
                .foregroundColor(Color("primaryColor"))
                .cornerRadius(25)
                .transition(.move(edge: .trailing))
            }
            
        }
        .font(Font.custom("Exo 2", size: 24).bold())
        .lineLimit(1)
        .frame(maxWidth: .infinity)
        .minimumScaleFactor(0.3)
        .disabled(showAllCategories)
//        .offset(x: showPicker && numberOfPicker == .left ? UIScreen.main.bounds.width / 4 : 0)
//        .offset(x: showPicker && numberOfPicker == .right ? UIScreen.main.bounds.width / -4 : 0)
    }
}

struct TypePickerButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        TypePickerButtonsView(showAllCategories: .constant(true), showPicker: .constant(true), numberOfPicker: .constant(.both), unit: ConverterViewModel())
    }
}

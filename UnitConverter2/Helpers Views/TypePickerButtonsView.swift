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
            .foregroundColor(Color("secondaryColor"))
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
            .background(Color("secondaryColor"))
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
}

struct TypePickerButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        TypePickerButtonsView(showAllCategories: .constant(true), showPicker: .constant(true), numberOfPicker: .constant(.both), unit: ConverterViewModel())
    }
}

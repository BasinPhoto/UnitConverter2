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
    
    @EnvironmentObject var unit: ConverterViewModel
    
    fileprivate func resignResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var LeftButton: some View {
        Group {
            if numberOfPicker == .left || numberOfPicker == .both {
                Button(action: {
                    resignResponder()
                    if unit.isBothValuesSelected {
                        numberOfPicker = numberOfPicker == .left ? .both : .left
                        self.showPicker.toggle()
                    }
                }, label: {
                    if let selectedFrom = unit.selectedFrom {
                        Text(unit.keysArray[selectedFrom].localized())
                            .transition(.identity)
                    } else {
                        Text("(from...)".localized())
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
        }
    }
    
    var rightButton: some View {
        Group {
            if numberOfPicker == .right || numberOfPicker == .both {
                Button(action: {
                    resignResponder()
                    if unit.isBothValuesSelected {
                        numberOfPicker = numberOfPicker == .right ? .both : .right
                        self.showPicker.toggle()
                    }
                }, label: {
                    if let selectedTo = unit.selectedTo {
                        Text(unit.keysArray[selectedTo].localized())
                            .transition(.identity)
                    } else {
                        Text("(to...)".localized()).transition(.identity)
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
    }
    
    var body: some View {
        HStack(spacing: 0) {
            LeftButton
            
            rightButton
            
        }
        .font(Font.custom("Exo 2", size: 24).bold())
        .lineLimit(1)
        .frame(maxWidth: .infinity)
        .minimumScaleFactor(0.3)
        .disabled(showAllCategories)
    }
}

struct TypePickerButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        TypePickerButtonsView(showAllCategories: .constant(true), showPicker: .constant(true), numberOfPicker: .constant(.both))
            .environmentObject(ConverterViewModel())
    }
}

//
//  DropDownMenu.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 08.12.2020.
//

import SwiftUI

struct DropDownMenu: View {
    @Binding var showAllCategories: Bool
    @Binding var showPicker: Bool
    @Binding var numberOfPicker: PickerSide
    @StateObject var unit: ConverterViewModel
    
    var body: some View {

            VStack(alignment: .trailing) {
                if !showAllCategories {
                    HStack {
                        Button(action: {
                            withAnimation{
                                showAllCategories.toggle()
                            }
                        }, label: {
                            Image(unit.type.imageName)
                                .resizable()
                                .scaledToFit()
                                .colorInvert()
                                .frame(width: 45, height: 45)
                                .padding(10)
                        })
                        .background(Color("primaryColor"))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    }
                } else {
                    ForEach(UnitType.allCases) { type in
                        Button(action: {
                            if unit.type != type || unit.selectedFrom == nil || unit.selectedTo == nil {
                                if type == .money && UnitType.allValues.count < 10 {
                                    
                                } else {
                                    unit.type = type
                                    numberOfPicker = .both
                                    showPicker = true
                                }
                            }
                            withAnimation{
                                self.showAllCategories.toggle()
                            }
                        }, label: {
                            Text(type.description)
                                .font(Font.custom("Exo 2", size: 18))
                                .foregroundColor(.white)
                                .padding(.leading)
                            Image(type.imageName)
                                .resizable()
                                .scaledToFit()
                                .colorInvert()
                                .frame(width: 35, height: 35)
                                .padding(.trailing)
                        })
                        .padding(.vertical, 8)
                        .background(Color("primaryColor"))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.white, lineWidth: 2))
                        .transition(.move(edge: .trailing))
                    }
                }
            }
            .shadow(color: Color("primaryColor").opacity(0.7), radius: 10, x: 6, y: 6)
    }
}


struct DropDownMenu_Previews: PreviewProvider {
    static var previews: some View {
        DropDownMenu(showAllCategories: .constant(true), showPicker: .constant(false), numberOfPicker: .constant(.both), unit: ConverterViewModel())
    }
}

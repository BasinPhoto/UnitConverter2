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
    @EnvironmentObject var unit: ConverterViewModel
    
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        VStack(alignment: .trailing) {
            if !showAllCategories {
                if !showPicker {
                    Button(action: {
                        withAnimation{
                            showAllCategories.toggle()
                        }
                        generator.impactOccurred()
                    }, label: {
                        Image(unit.type.imageName)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .padding(10)
                    })
                    .background(Color("primaryColor"))
                    .foregroundColor(Color("secondaryColor"))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color("secondaryColor"), lineWidth: 2))
                    .padding(.trailing, 30)
                    .zIndex(1)
                    .transition(.move(edge: .trailing))
                }
            } else {
                ForEach(UnitType.allCases) { type in
                    if type == .money && UnitType.allValues.count < 11 {
                        EmptyView()
                    } else {
                        Button(action: {
                            if unit.type != type || unit.selectedFrom == nil || unit.selectedTo == nil {
                                unit.type = type
                                numberOfPicker = .both
                                showPicker = true
                            }
                            self.showAllCategories.toggle()
                            generator.impactOccurred()
                        }, label: {
                            Text(type.description)
                                .font(Font.custom("Exo 2", size: 18))
                                .padding(.leading)
                            Image(type.imageName)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .padding(.trailing)
                        })
                        .padding(.vertical, 8)
                        .background(Color("primaryColor"))
                        .foregroundColor(Color("secondaryColor"))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color("secondaryColor"), lineWidth: 2))
                        .transition(.move(edge: .trailing))
                        .zIndex(2)
                        .animation(Animation.easeOut(duration: 0.1).delay(Double(type.rawValue) * 0.02))
                    }
                }
                .padding(.vertical, 3)
                .padding(.trailing)
            }
        }
        .shadow(color: Color("shadowColor").opacity(0.7), radius: 10, x: 6, y: 6)
        .ignoresSafeArea()
    }
}


struct DropDownMenu_Previews: PreviewProvider {
    static var previews: some View {
        DropDownMenu(showAllCategories: .constant(true), showPicker: .constant(false), numberOfPicker: .constant(.both))
            .environmentObject(ConverterViewModel())
    }
}

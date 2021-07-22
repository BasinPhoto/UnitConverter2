//
//  TypePicker.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 11.12.2020.
//

import SwiftUI

struct TypePicker: View {
    @Binding var toVar: Int?
    @Binding var showPicker: Bool
    @Binding var numberOfPicker: PickerSide
    @StateObject var unit: ConverterViewModel
    
    var backgroundColor: Color
    var accentColor: Color
    
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    let columns = [
        GridItem(.fixed(UIScreen.main.bounds.width / 2)),
        GridItem(.fixed(UIScreen.main.bounds.width / 2))
    ]
    
    let columnsForCurrencys = [
        GridItem(.fixed(UIScreen.main.bounds.width / 3)),
        GridItem(.fixed(UIScreen.main.bounds.width / 3)),
        GridItem(.fixed(UIScreen.main.bounds.width / 3))
    ]
    
    var body: some View {
        
        ZStack {
            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: unit.type == .money ? columnsForCurrencys : columns, spacing: 16) {
                    ForEach(0..<unit.keysArray.count, id: \.self) { keyNumber in
                        Button (action: {
                            if !(keyNumber == unit.selectedFrom || keyNumber == unit.selectedTo) {
                                toVar = keyNumber
                                numberOfPicker = .both
                                if unit.isBothValuesSelected {
                                    if unit.selectedFrom != unit.selectedTo {
                                        showPicker.toggle()
                                        generator.impactOccurred()
                                    }
                                }
                            }
                        }, label: {
                            if toVar == keyNumber {
                                HStack (spacing: 0) {
                                    if let flag = UnitType.flags[unit.keysArray[keyNumber]] {
                                        Text(flag)
                                            .font(.system(size: 24))
                                            .frame(width: 40, height: 40)
                                            .background(accentColor)
                                            .clipShape(Circle())
                                    }
                                    Text(unit.keysArray[keyNumber])
                                        .font(Font.custom("Exo 2", size: 20).bold())
                                        .padding(.horizontal)
                                        .minimumScaleFactor(0.3)
                                }
                                .frame(height: 25)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(accentColor)
                                .foregroundColor(backgroundColor)
                                .clipShape(Capsule())
                                .shadow(color: Color("shadowColor").opacity(0.3), radius: 5, x: 0, y: 3)
                                .padding(.horizontal)
                            } else {
                                let disButton: Bool = keyNumber == unit.selectedFrom || keyNumber == unit.selectedTo
                                HStack (spacing: 0) {
                                    if let flag = UnitType.flags[unit.keysArray[keyNumber]] {
                                        Text(flag)
                                            .font(.system(size: 24))
                                            .frame(width: 40, height: 40)
                                            .background(accentColor)
                                            .clipShape(Circle())
                                    }
                                    Text(unit.keysArray[keyNumber])
                                        .font(Font.custom("Exo 2", size: 20).bold())
                                        .padding(.horizontal)
                                        .minimumScaleFactor(0.3)
                                        .lineLimit(1)
                                }
                                .opacity(disButton ? 0.3 : 1)
                                .frame(height: 25)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule().stroke(lineWidth: disButton ? 0 : 2)
                                )
                                .padding(.horizontal)
                            }
                        })
                    }
                }
                .padding(.vertical, 60)
                .padding(.bottom, 50)
                .padding(.horizontal, 16)
            }
            
            VStack {
                LinearGradient(gradient: Gradient(colors: [backgroundColor, backgroundColor, backgroundColor.opacity(0)]), startPoint: .top, endPoint: .bottom)
                    .frame(height: 60)
                    .ignoresSafeArea()
                    .disabled(true)
                Spacer()
                LinearGradient(gradient: Gradient(colors: [backgroundColor, backgroundColor, backgroundColor.opacity(0)]), startPoint: .bottom, endPoint: .top)
                    .frame(height: 60)
                    .ignoresSafeArea()
                    .disabled(true)
            }
        
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
        .background(Color.clear)
        .foregroundColor(accentColor)


    }
}

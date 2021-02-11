//
//  TypePicker.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 11.12.2020.
//

import SwiftUI

struct TypePicker: View {
    @Binding var toVar: Int
    @Binding var showPicker: Bool
    @StateObject var unit: ConverterViewModel
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 15){
            ScrollView(showsIndicators: false){
                ForEach(0..<unit.keysArray.count, id: \.self) { keyNumber in
                    Button {
                        toVar = keyNumber
                        showPicker.toggle()
                    } label: {
                        if toVar == keyNumber {
                            Text(unit.keysArray[keyNumber])
                                .font(Font.custom("Exo 2", size: 22).bold())
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .foregroundColor(Color("ColorBack"))
                                .cornerRadius(10)
                        } else {
                            Text(unit.keysArray[keyNumber])
                                .font(Font.custom("Exo 2", size: 20))
                                .opacity(0.5)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                        }
                    }
                    .multilineTextAlignment(.center)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width / 2 - 32)
        .padding()
        .background(Color("ColorBack"))
        .foregroundColor(.white)
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white, lineWidth: 3))
    }
}


//
//  SwapButton.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 04.08.2021.
//

import SwiftUI

struct SwapButton: View {
    @EnvironmentObject var unit: ConverterViewModel
    @Binding var showPicker: Bool
    @Binding var numberOfPicker: PickerSide
    
    var body: some View {
        if !showPicker {
            Button(action: {
                if unit.result != nil {
                    unit.swapValues()
                    numberOfPicker = .right
                    showPicker.toggle()
                } else {
                    unit.swapValues()
                }
            }, label: {
                HStack(spacing: -25, content: {
                    Image("arrow")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color("secondaryColor"))
                        .frame(width: 35, height: 35)
                    
                    Image("arrow")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color("primaryColor"))
                        .frame(width: 35, height: 35)
                        .rotationEffect(.degrees(180))
                })
            })
            .rotationEffect(.degrees(-45))
            .transition(.scale)
        }
    }
}

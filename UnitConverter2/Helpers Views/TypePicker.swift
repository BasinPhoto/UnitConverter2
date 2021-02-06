//
//  TypePicker.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 11.12.2020.
//

import SwiftUI

struct TypePicker: View {
    @Binding var toVar: Int
    @StateObject var unit: ConverterViewModel
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 15){
                ForEach(0..<unit.keysArray.count, id: \.self) { keyNumber in
                    Button {
                        toVar = keyNumber
                    } label: {
                        if toVar == keyNumber {
                            Text(unit.keysArray[keyNumber])
                                .font(.title3)
                                .bold()
                        } else {
                            Text(unit.keysArray[keyNumber]).opacity(0.5)
                        }
                    }

                }
            }
        }
    }
}

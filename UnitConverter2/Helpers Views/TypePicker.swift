//
//  TypePicker.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 11.12.2020.
//

import SwiftUI

struct TypePicker: View {
    @Binding var toVar: Int
    @ObservedObject var unit: ConverterViewModel
    
    var body: some View {
        Picker(selection: $toVar, label: Text(""), content: {
            ForEach(0..<unit.keysArray.count, id: \.self) {
                Text(unit.keysArray[$0]).tag($0)
            }
        })
    }
}

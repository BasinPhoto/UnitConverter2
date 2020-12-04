//
//  ContentView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 30.11.2020.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var unit: ConverterViewModel
    
    var body: some View {
        VStack {
            Picker(selection: $unit.type, label: Text("Type"), content: {
                ForEach(0..<unitTypeName.count) {
                    Text(unitTypeName[$0])
                }
            })
            Picker(selection: $unit.selectedFrom , label: Text("From"), content: {
                ForEach(unit.keysArray, id: \.self) { key in
                    Text(key)
                }
            })
            Picker(selection: $unit.selectredTo , label: Text("To"), content: {
                ForEach(unit.keysArray, id: \.self) { key in
                    Text(key)
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(unit: ConverterViewModel())
    }
}

//
//  ContentView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 30.11.2020.
//

import SwiftUI


struct ContentView: View {
    @State public var inFocus: Bool = false
    @ObservedObject var unit: ConverterViewModel

    var body: some View {
        
        ZStack{
            VStack(spacing: 0){
                
                ZStack{
                    Rectangle()
                        .foregroundColor(.blue)
                    HStack{
                        TextField(unit.amountInString, text: $unit.amountInString)
                            .font(.system(size: 30, weight: .bold))
                            .keyboardType(.decimalPad)
                            .background(inFocus ? Color.white : Color.blue)
                            .cornerRadius(8)
                            .onTapGesture {
                                unit.temporaryValue = unit.amountInString
                                unit.amountInString = ""
                                inFocus = true
                            }
                        Spacer()
                        TypePicker(toVar: $unit.selectedFrom, unit: unit)
                            .frame(width: 250)
                    }
                    .foregroundColor(inFocus ? .blue : .white)
                    .padding()
                }
                
                ZStack{
                    Rectangle()
                        .foregroundColor(.white)
                    HStack{
                        Text("\(unit.result, specifier: "%g")")
                            .foregroundColor(.blue)
                            .font(.system(size: 30, weight: .bold))
                            .multilineTextAlignment(.center)
                        Spacer()
                        TypePicker(toVar: $unit.selectedTo, unit: unit)
                            .frame(width: 250)
                    }
                    .padding()
                }
            }.ignoresSafeArea(.all)
    
            VStack{
            DropDownMenu(unit: unit)
                Spacer()
            }
        }.onTapGesture {
            if unit.amountInString == "" {
                unit.amountInString = unit.temporaryValue
            }
            inFocus = false
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(unit: ConverterViewModel())
    }
}

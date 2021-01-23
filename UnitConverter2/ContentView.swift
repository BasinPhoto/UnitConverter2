//
//  ContentView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 30.11.2020.
//

import SwiftUI


struct ContentView: View {
    @StateObject var unit: ConverterViewModel

    var body: some View {
        
        ZStack{
            VStack(spacing: 0){
                
                ZStack{
                    Rectangle()
                        .foregroundColor(.blue)
                    HStack{
                        TextField(unit.amountInString, text: $unit.amountInString)
                            .font(.system(size: 30, weight: .bold))
                            .lineLimit(0)
                            .multilineTextAlignment(.center)
                            .keyboardType(.decimalPad)
                            .onTapGesture {
                                unit.temporaryValue = unit.amountInString
                                unit.amountInString = ""
                            }
                        Spacer()
                        TypePicker(toVar: $unit.selectedFrom, unit: unit)
                            .frame(width: 250)
                    }
                    .foregroundColor(.white)
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
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(unit: ConverterViewModel())
    }
}

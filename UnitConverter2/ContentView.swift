//
//  ContentView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 30.11.2020.
//

import SwiftUI


struct ContentView: View {
    @State public var inFocus: Bool = false
    @StateObject var unit: ConverterViewModel

    var body: some View {
        
        GeometryReader { geo in
            ZStack{
                VStack(spacing: 0){
                    Color("ColorBack")
                    Color.white
                }.ignoresSafeArea(.all)
                
                VStack {
                    TextField(unit.amountInString, text: $unit.amountInString)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                        .cornerRadius(8)
                        .offset(y: geo.size.width / -2.2)
                        .onTapGesture {
                            unit.temporaryValue = unit.amountInString
                            unit.amountInString = ""
                            inFocus = true
                        }
                    
                    HStack(spacing: 0) {
                        
                        Button(action: {
                            
                        }, label: {
                            Text(unit.keysArray[unit.selectedFrom])
                        })
                        .padding()
                        .frame(width: geo.size.width / 2)
                        .background(Color("ColorBack"))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        
                        Button(action: {
                            
                        }, label: {
                            Text(unit.keysArray[unit.selectedTo])
                        })
                        .padding()
                        .frame(width: geo.size.width / 2)
                        .background(Color.white)
                        .foregroundColor(Color("ColorBack"))
                        .cornerRadius(20)
                    }
                    
                    Text("\(unit.result, specifier: "%g")")
                        .frame(width: geo.size.width / 2)
                        .foregroundColor(Color("ColorBack"))
                        .font(.system(size: 30, weight: .bold))
                        .multilineTextAlignment(.center)
                        .offset(y: geo.size.width / 2.2)
                }
                
                VStack(alignment: .trailing){
                    Spacer()
                    
                    HStack {
                        Spacer()
                        DropDownMenu(unit: unit)
                            .padding(35)
                    }
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onTapGesture {
                if unit.amountInString == "" {
                    unit.amountInString = unit.temporaryValue
                }
                inFocus = false
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(unit: ConverterViewModel())
    }
}

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
    
    var backgroungColor: Color
    var accentColor: Color
    
    let columns = [
        GridItem(.adaptive(minimum: 100)),
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        
        ZStack {
            ScrollView(showsIndicators: false){
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<unit.keysArray.count, id: \.self) { keyNumber in
                        Button {
                            toVar = keyNumber
                            showPicker.toggle()
                        } label: {
                            if toVar == keyNumber {
                                Text(unit.keysArray[keyNumber])
                                    .font(Font.custom("Exo 2", size: 22).bold())
                                    .lineLimit(0)
                                    .minimumScaleFactor(0.3)
                                    .frame(height: 25)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(accentColor)
                                    .foregroundColor(backgroungColor)
                                    .clipShape(Capsule())
                            } else {
                                Text(unit.keysArray[keyNumber])
                                    .font(Font.custom("Exo 2", size: 20))
                                    .lineLimit(0)
                                    .minimumScaleFactor(0.3)
                                    .opacity(0.5)
                                    .frame(height: 25)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .overlay(
                                        Capsule().stroke(lineWidth: 2)
                                    )
                            }
                        }
                    }
                }
                .padding(.vertical, 40)
                .padding(.bottom, 50)
            }
            
            VStack {
                LinearGradient(gradient: Gradient(colors: [backgroungColor, backgroungColor.opacity(0)]), startPoint: .top, endPoint: .bottom)
                    .frame(height: 40)
                    .ignoresSafeArea()
                    .disabled(true)
                Spacer()
                LinearGradient(gradient: Gradient(colors: [backgroungColor, backgroungColor.opacity(0)]), startPoint: .bottom, endPoint: .top)
                    .frame(height: 45, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .offset(y: -35)
                    .ignoresSafeArea()
                    .disabled(true)
            }
        
        }
        .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height / 2)
        .background(backgroungColor)
        .foregroundColor(accentColor)


    }
}

struct TypePicker_Previews: PreviewProvider {
    static var previews: some View {
        TypePicker(toVar: .constant(1), showPicker: .constant(true), unit: ConverterViewModel(), backgroungColor: Color("primaryColor"), accentColor: .white)
    }
}

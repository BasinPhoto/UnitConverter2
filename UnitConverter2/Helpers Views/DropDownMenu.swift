//
//  DropDownMenu.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 08.12.2020.
//

import SwiftUI

struct DropDownMenu: View {
    @State var showAllCategories = false
    @StateObject var unit: ConverterViewModel
    
    var body: some View {
        
        VStack(alignment: .trailing) {
            if !showAllCategories {
                HStack {
                    Button(action: {
                        withAnimation{
                            showAllCategories.toggle()
                        }
                    }, label: {
                        Image(unit.type.imageName)
                            .resizable()
                            .scaledToFit()
                            .colorInvert()
                            .frame(width: 35, height: 35)
                            .padding(10)
                    }).background(Color("ColorBack"))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                }
            } else {
                ForEach(UnitType.allCases) { type in
                        Button(action: {
                            self.unit.type = type
                            withAnimation{
                                self.showAllCategories.toggle()
                            }
                        }, label: {
                            Text(type.description)
                                .foregroundColor(.white)
                                .padding()
                            Image(type.imageName)
                                .resizable()
                                .scaledToFit()
                                .colorInvert()
                                .frame(width: 35, height: 35)
                                .padding(.horizontal)
                        }).background(Color("ColorBack"))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.white, lineWidth: 2))
                        .transition(.move(edge: .trailing))
                }
            }
        }
        .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 3, y: 3)
        .animation(.easeIn)
    }
}

struct DropDownMenu_Previews: PreviewProvider {
    static var previews: some View {
        DropDownMenu(unit: ConverterViewModel())
    }
}

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
        
        VStack {
                if !showAllCategories {
                    Button(unit.type.description) {
                        showAllCategories.toggle()
                    }
                } else {
                    ForEach(UnitType.allCases) { type in
                        Button(type.description) {
                            self.unit.type = type
                            showAllCategories.toggle()
                        }.padding(2)
                    }
                }
        }
        .padding()
        .frame(width: 250)
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color(#colorLiteral(red: 0.3833849887, green: 0.6668031643, blue: 1, alpha: 1))]), startPoint: .top, endPoint: .bottom))
        .foregroundColor(.white)
        .cornerRadius(15)
        .shadow(color: Color(#colorLiteral(red: 0.02715317465, green: 0.4165905732, blue: 0.8183051986, alpha: 1)),
                radius: showAllCategories ? 5 : 0,
                x: 0.0,
                y: showAllCategories ? 10 : 0)
        .animation(.easeIn)
    }
}

struct DropDownMenu_Previews: PreviewProvider {
    static var previews: some View {
        DropDownMenu(unit: ConverterViewModel())
    }
}

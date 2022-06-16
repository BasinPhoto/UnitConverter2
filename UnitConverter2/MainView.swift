//
//  MainView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 12.06.2022.
//

import SwiftUI

struct MainView: View {
    @State private var leftToRight: Bool = true
    @State private var selection1: String = ""
    @State private var selection2: String = ""

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ValuePicker(items: UnitType.length.labels, selection: $selection1, colorSelection: Color("primaryColor"))
                ValuePicker(items: UnitType.length.labels, selection: $selection2, colorSelection: Color("primaryColor"))
            }
            .frame(height: UIScreen.main.bounds.height / 2)
            .clipped()
            
            Button {
                leftToRight.toggle()
            } label: {
                Image(systemName: leftToRight ? "chevron.right" : "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
            }
        }
        .onChange(of: selection1) { newValue in
            print("1 ->", selection1)
        }
        .onChange(of: selection2) { newValue in
            print("2 ->", selection2)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

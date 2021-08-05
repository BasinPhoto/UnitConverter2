//
//  InfoButton.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 04.08.2021.
//

import SwiftUI

struct InfoButton: View {
    @Binding var showAllCategories: Bool
    @Binding var showPicker: Bool
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                if !showAllCategories, !showPicker {
                    Button(action: {
                        isPresented.toggle()
                    }, label: {
                        Image(systemName: "info")
                            .font(.system(size: 46))
                            .frame(width: 45, height: 45)
                            .padding(10)
                            .foregroundColor(Color("secondaryColor"))
                            .background(Color("primaryColor"))
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color("secondaryColor"), lineWidth: 2))
                            .padding(.leading, 30)
                            .shadow(color: Color("shadowColor").opacity(0.7), radius: 10, x: 6, y: 6)
                    })
                    .padding(.bottom, 45)
                    .transition(.move(edge: .leading))
                    Spacer()
                }
            }
        }
    }
}

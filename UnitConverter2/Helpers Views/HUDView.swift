//
//  HUDView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 01.08.2021.
//

import SwiftUI

import SwiftUI

struct HUDView: View {
    @Binding var showHUD: Bool
    @Binding var textHUD: String
    
    var body: some View {
        if showHUD {
            Text(textHUD)
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(10)
                .background(
                    Capsule()
                        .foregroundColor(.accentColor)
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 10)
                )
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showHUD = false
                    }
                })
        }
    }
}

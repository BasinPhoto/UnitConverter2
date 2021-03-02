//
//  BackgroundView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 01.03.2021.
//

import SwiftUI


struct Background: View {
    var body: some View {
        VStack(spacing: 0){
            Color("primaryColor")
                .ignoresSafeArea()
            Color("secondaryColor")
                .ignoresSafeArea()
        }
    }
}

struct Background_Previews: PreviewProvider {
    static var previews: some View {
        Background()
    }
}

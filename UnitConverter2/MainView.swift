//
//  MainView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 12.06.2022.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        ValuePicker(type: .length)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

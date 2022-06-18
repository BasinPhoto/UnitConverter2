//
//  ResultView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 18.06.2022.
//

import SwiftUI

struct ResultView: View {
    @Binding var inputValue: String
    let inputValueDescription: String
    
    @Binding var resultValue: Double
    let resultValueDescription: String
    
    var body: some View {
        HStack {
            VStack(alignment: .trailing) {
                Text("\(inputValue)")
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Text(inputValueDescription)
                    .lineLimit(1)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            Text("=")
                .font(.largeTitle)
                .bold()
            VStack(alignment: .leading) {
                Text("\(resultValue.removeZerosFromEnd())")
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                Text(resultValueDescription)
                    .lineLimit(1)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical)
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(inputValue: .constant("100"),
                   inputValueDescription: "meters",
                   resultValue: .constant(30),
                   resultValueDescription: "feets")
    }
}

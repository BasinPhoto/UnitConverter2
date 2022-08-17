//
//  ResultView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 18.06.2022.
//

import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
            HStack {
                if let operationType = viewModel.operation {
                    VStack(alignment: .trailing) {
                        Text("\(viewModel.inputValue) \(operationType.rawValue) \(viewModel.operationValue)")
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Text(viewModel.selection1)
                            .lineLimit(1)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                } else {
                    VStack(alignment: .trailing) {
                        Text("\(viewModel.inputValue)")
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Text(viewModel.selection1)
                            .lineLimit(1)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                
                Text("=>")
                    .font(.largeTitle)
                    .bold()
                VStack(alignment: .leading) {
                    Text("\(viewModel.resultValue.removeZerosFromEnd())")
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(viewModel.selection2)
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
        ResultView(viewModel: ViewModel())
    }
}

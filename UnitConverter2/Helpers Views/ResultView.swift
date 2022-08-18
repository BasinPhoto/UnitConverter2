//
//  ResultView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 18.06.2022.
//

import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: ViewModel
    
    private var keys: [String] {
        let dict = UnitType.allValues[viewModel.unitType.rawValue].sorted(by: {$0.key < $1.key})
        return dict.map({ $0.key })
    }
    
    var body: some View {
            HStack {
                if let operationType = viewModel.operation {
                    VStack(alignment: .trailing) {
                        Text("\(viewModel.inputValue) \(operationType.rawValue) \(viewModel.operationValue)")
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Text(keys[viewModel.selectedIndex1])
                            .lineLimit(1)
                            .font(.footnote)
                            .foregroundColor(.white)
                    }
                } else {
                    VStack(alignment: .trailing) {
                        Text("\(viewModel.inputValue)")
                            .bold()
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(.white)
                        if keys.count - 1 >= viewModel.selectedIndex1 {
                            Text(keys[viewModel.selectedIndex1])
                                .lineLimit(1)
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                }
                
                Text("=")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                VStack(alignment: .leading) {
                    Text("\(viewModel.resultValue.removeZerosFromEnd())")
                        .bold()
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                    
                    if keys.count - 1 >= viewModel.selectedIndex2 {
                        Text(keys[viewModel.selectedIndex2])
                            .lineLimit(1)
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.vertical)
            .background {
                Color.accentColor
            }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(viewModel: ViewModel())
    }
}

//
//  ResultView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 18.06.2022.
//

import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: ViewModel
    let pasteboard = UIPasteboard.general
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    @State private var isShowCopyLabel: Bool = false
    
    private var keys: [String] {
        let dict = UnitType.allValues[viewModel.unitType.rawValue].sorted(by: {$0.key < $1.key})
        return dict.map({ $0.key })
    }
    
    var body: some View {
            HStack {
                if let operationType = viewModel.operation {
                    VStack(alignment: .trailing) {
                        Text("\(viewModel.inputValue) \(operationType.rawValue) \(viewModel.operationValue)")
                            .bold()
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(.white)
                        Text(keys[viewModel.selectedIndex1])
                            .lineLimit(1)
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .onTapGesture(count: 2) {
                        if let _ = Double(pasteboard.string ?? "") {
                            viewModel.operationValue = pasteboard.string ?? "0"
                            feedbackGenerator.impactOccurred()
                        }
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
                    .onTapGesture(count: 2) {
                        if let _ = Double(pasteboard.string ?? "") {
                            viewModel.inputValue = pasteboard.string ?? "0"
                            feedbackGenerator.impactOccurred()
                        }
                    }
                }
                
                Image(systemName: "equal")
                    .foregroundColor(.white)
                if isShowCopyLabel {
                    Text("Copied")
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .transition(.scale)
                } else {
                    VStack(alignment: .leading) {
                        Text("\(viewModel.resultValue.formattedWithSeparator)")
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
                    .transition(.scale)
                    .onLongPressGesture {
                        if viewModel.resultValue.removeZerosFromEnd() != "0" {
                            pasteboard.string = viewModel.resultValue.removeZerosFromEnd()
                            feedbackGenerator.impactOccurred()
                            withAnimation(.default) {
                                isShowCopyLabel.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation(.default) {
                                        isShowCopyLabel.toggle()
                                    }
                                }
                            }
                        }
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

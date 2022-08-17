//
//  TypePickerView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 17.06.2022.
//

import SwiftUI
import Combine

struct TypePickerView: View {
    @Binding var selectedUnitType: UnitType {
        willSet {
            if newValue.rawValue > selectedUnitType.rawValue {
                scrolledRight = true
            } else {
                scrolledRight = false
            }
        }
    }
    @State private var tempSelectedIndex: UnitType = .time
    @State private var scrolledRight: Bool = true
    
    var beforeSelectionLabels: [UnitType] {
        Array(UnitType.allCases.prefix(selectedUnitType.rawValue))
    }
    
    var afterSelectionLabels: [UnitType] {
        Array(UnitType.allCases.suffix(UnitType.allCases.count - selectedUnitType.rawValue - 1))
    }
    
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
    
    var body: some View {
        VStack {
            Text(selectedUnitType.description)
            
            HStack(spacing: 0) {
                Color.clear
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .trailing) {
                        HStack {
                            ForEach(beforeSelectionLabels, id:\.self) { item in
                                Image(item.imageName)
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.accentColor)
                                    .padding(4)
                                    .transition(.move(edge: .trailing))
                        }
                    }
                }
                
                ZStack {
                    Color.accentColor
                        .cornerRadius(16)
                    
                    Image(selectedUnitType.imageName)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                        .padding()
                        .transition(.asymmetric(insertion: scrolledRight ? .move(edge: .trailing) : .move(edge: .leading),
                                                removal: .scale.combined(with: .opacity)))
                        .id(selectedUnitType.imageName)
                }
                .zIndex(1)
                
                Color.clear
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading) {
                        HStack {
                            ForEach(afterSelectionLabels, id:\.self) { item in
                                Image(item.imageName)
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.accentColor)
                                    .padding(4)
                                    .transition(.move(edge: .leading))
                        }
                    }
                }
            }
            .fixedSize()
            .gesture(
                DragGesture()
                    .onChanged{ value in
                        let preparedValue = Int(-value.translation.width / 10)
                        let newIndex = tempSelectedIndex.rawValue + preparedValue
                        
                        if newIndex >= 0 &&
                            newIndex <= (UnitType.allCases.count - 1) {
                            withAnimation(.easeOut.speed(2)) {
                                selectedUnitType = UnitType(rawValue: newIndex) ?? tempSelectedIndex
                            }
                            feedbackGenerator.impactOccurred()
                        }
                    }
                    .onEnded{ _ in
                        tempSelectedIndex = selectedUnitType
                    }
            )
        }
    }
}

struct TypePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TypePickerView(selectedUnitType: .constant(.length))
    }
}

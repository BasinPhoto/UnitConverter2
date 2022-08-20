//
//  ValuePicker.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 12.06.2022.
//

import SwiftUI
import Combine

struct ValuePicker: View {
    let unitType: UnitType
    
    @Binding var selectedIndex: Int {
        willSet {
            if newValue > selectedIndex {
                scrolledDown = true
            } else {
                scrolledDown = false
            }
        }
    }
    
    @Binding var tempSelectedIndex: Int
    
    @State private var scrolledDown: Bool = true
    
    var beforeSelectionLabels: [String] {
        if unitType.labels.count - 1 >= selectedIndex {
            return Array(unitType.labels.prefix(selectedIndex))
        } else {
            return []
        }
    }
    
    var afterSelectionLabels: [String] {
        if unitType.labels.count - 1 >= selectedIndex {
            return Array(unitType.labels.suffix(unitType.labels.count - selectedIndex - 1))
        } else {
            return []
        }
    }
    
    var selection: String {
        if unitType.labels.count - 1 >= selectedIndex {
            return unitType.labels[selectedIndex]
        } else {
            return ""
        }
    }
    
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
    
    var body: some View {
        VStack(spacing: 0) {
            Color.clear
                .overlay(alignment: .bottom) {
                    VStack {
                        ForEach(beforeSelectionLabels, id:\.self) { label in
                            Text(label)
                                .lineLimit(1)
                                .padding(4)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .bottom)
                                                .combined(with: .scale)
                                                .combined(with: .opacity),
                                    removal: .move(edge: .bottom)
                                                .combined(with: .scale)
                                                .combined(with: .opacity)))
                        }
                    }
                }
            .frame(maxHeight: .infinity)

            ZStack {
                Color.accentColor
                
                Text(selection)
                    .bold()
                    .foregroundColor(.white)
                    .frame(height: 40)
                    .lineLimit(1)
                    .padding(.horizontal)
                    .minimumScaleFactor(0.2)
                    .transition(scrolledDown ? .move(edge: .bottom).combined(with: .opacity) : .move(edge: .top).combined(with: .opacity))
                    .id(selection)
            }
            .fixedSize(horizontal: false, vertical: true)
            .zIndex(1)
            
            Color.clear
                .overlay(alignment: .top) {
                    VStack {
                        ForEach(afterSelectionLabels, id:\.self) { label in
                            Text(label)
                                .lineLimit(1)
                                .padding(4)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .top)
                                                .combined(with: .scale)
                                                .combined(with: .opacity),
                                    removal: .move(edge: .top)
                                                .combined(with: .scale)
                                                .combined(with: .opacity)))
                        }
                    }
                }
            .frame(maxHeight: .infinity)
            

        }
        .gesture(
            DragGesture()
                .onChanged{ value in
                    let preparedValue = Int(-value.translation.height / 10)
                    let newIndex = tempSelectedIndex + preparedValue
                    
                    if newIndex >= 0 &&
                        newIndex <= (unitType.labels.count - 1) {
                        withAnimation(.easeOut.speed(2)) {
                            selectedIndex = newIndex
                        }
                        feedbackGenerator.impactOccurred()
                    }
                }
                .onEnded{ _ in
                    tempSelectedIndex = selectedIndex
                }
        )
    }
}

struct ValuePickerPreview: PreviewProvider {
    static var previews: some View {
        ValuePicker(unitType: .time, selectedIndex: .constant(0), tempSelectedIndex: .constant(0))
    }
}

//
//  TypePickerView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 17.06.2022.
//

import SwiftUI
import Combine
import AVFoundation

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
    @State private var tempSelectedIndex: UnitType = .length
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
            Text(LocalizedStringKey(selectedUnitType.description))
                .bold()
                .font(.title2)
                .foregroundColor(.white)
                .padding(.top, 88)
                .transition(.scale)
                .id(selectedUnitType.description)
            
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
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .transition(.move(edge: .trailing))
                                    .onTapGesture {
                                        withAnimation(.linear.speed(2)) {
                                            selectedUnitType = item
                                            AudioServicesPlaySystemSound(1103)
                                        }
                                    }
                        }
                    }
                }
                
                ZStack {
                    Image(selectedUnitType.imageName)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.accentColor)
                        .padding()
                        .transition(.asymmetric(insertion: scrolledRight ? .move(edge: .trailing) : .move(edge: .leading),
                                                removal: .scale.combined(with: .opacity)))
                        .id(selectedUnitType.imageName)
                }
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .foregroundColor(Color.white))
                .fixedSize()
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
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .transition(.move(edge: .leading))
                                    .onTapGesture {
                                        withAnimation(.linear.speed(2)) {
                                            selectedUnitType = item
                                            AudioServicesPlaySystemSound(1103)
                                        }
                                    }
                        }
                    }
                }
            }
            .padding(.bottom)
            .gesture(
                DragGesture()
                    .onChanged{ value in
                        let preparedValue = Int(-value.translation.width / 10)
                        let newIndex = tempSelectedIndex.rawValue + preparedValue
                        
                        if newIndex >= 0 &&
                            newIndex <= (UnitType.allCases.count - 1) &&
                            selectedUnitType.rawValue != newIndex {
                            withAnimation(.linear.speed(2)) {
                                selectedUnitType = UnitType(rawValue: newIndex) ?? tempSelectedIndex
                            }
                            feedbackGenerator.impactOccurred()
                            AudioServicesPlaySystemSound(1103)
                        }
                    }
                    .onEnded { _ in
                        tempSelectedIndex = selectedUnitType
                    }
            )
        }
        .background {
            Color.accentColor
        }
        .clipped()
        .shadow(radius: 12)
    }
}

struct InnerShadowModifier: ViewModifier {
    @State var radius: CGFloat = 10
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(Color("bgColor"), lineWidth: 4)
                    .shadow(color: Color("darkShadow"), radius: 4, x: 5, y: 5)
                    .clipShape(RoundedRectangle(cornerRadius: radius))
                    .shadow(color: Color("lightShadow"), radius: 4, x: -5, y: -5)
                    .clipShape(RoundedRectangle(cornerRadius: radius)
                              ))
    }
}

struct TypePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TypePickerView(selectedUnitType: .constant(.length))
    }
}

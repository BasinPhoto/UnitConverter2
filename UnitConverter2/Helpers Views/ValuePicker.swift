//
//  ValuePicker.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 12.06.2022.
//

import SwiftUI
import Combine

struct ValuePicker: View {
    @State private var labelPublisher = PassthroughSubject<String, Never>()
    @State private var offsetCorrectionPublisher = PassthroughSubject<CGFloat, Never>()
    
    @Binding var selection: String
    @State private var subscriptions = Set<AnyCancellable>()
    
    @State private var dragLocation: CGFloat = 0
    @State private var offset: CGFloat = 0
    
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
    let colorSelection: Color
    
    private var items: [String]
    
    init(items: [String], selection: Binding<String>, colorSelection: Color) {
        self.items = items
        self._selection = selection
        self.colorSelection = colorSelection
    }
    
    var body: some View {
        ZStack {
            GeometryReader { scrollGeo in
                VStack {
                    ForEach(items, id:\.self) { item in
                        if let flag = UnitType.flags[item] {
                            Text(flag + item)
                                .lineLimit(1)
                                .padding(4)
                                .foregroundColor(.gray)
                        } else {
                            Text(item)
                                .lineLimit(1)
                                .padding(4)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .position(x: scrollGeo.size.width / 2, y: scrollGeo.size.height / 2)
                .offset(y: dragLocation)
                
                ZStack {
                    VStack {
                        ForEach(items, id:\.self) { item in
                            if let flag = UnitType.flags[item] {
                                Text(flag + item)
                                    .bold()
                                    .lineLimit(1)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(
                                        GeometryReader { itemGeo in
                                            scrollObserver(itemProxy: itemGeo,
                                                           scrollProxy: scrollGeo,
                                                           selectedLabel: item)
                                        }
                                    )
                            } else {
                                Text(item)
                                    .bold()
                                    .lineLimit(1)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(
                                        GeometryReader { itemGeo in
                                            scrollObserver(itemProxy: itemGeo,
                                                           scrollProxy: scrollGeo,
                                                           selectedLabel: item)
                                        }
                                    )
                            }
                        }
                    }
                    .offset(y: dragLocation)
                }
                .frame(width: scrollGeo.size.width, height: 30)
                .background(colorSelection)
                .clipShape(Rectangle())
                .position(x: scrollGeo.size.width / 2, y: scrollGeo.size.height / 2)
            }
        }
        .clipShape(Rectangle())
        .coordinateSpace(name: "scroll")
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .onChanged { value in
                    withAnimation(.spring()) {
                        dragLocation = value.translation.height + offset
                    }
                }
                .onEnded { offset += $0.translation.height}
        )
        .task {
            subscribe()
        }
    }
    
    private func scrollObserver(itemProxy: GeometryProxy,
                                scrollProxy: GeometryProxy,
                                selectedLabel: String) -> some View {
        let itemCenter = itemProxy.frame(in: .named("scroll")).midY
        let selectionZoneMin = scrollProxy.frame(in: .named("scroll")).midY - 30
        let selectionZoneMax = scrollProxy.frame(in: .named("scroll")).midY + 30
        let inScroll = itemCenter > selectionZoneMin && itemCenter < selectionZoneMax
        
        if inScroll {
            labelPublisher.send(selectedLabel)
            offsetCorrectionPublisher.send(scrollProxy.frame(in: .named("scroll")).midY - itemCenter)
        }
        
        if (selectedLabel == items.first && itemCenter > selectionZoneMax) ||
            (selectedLabel == items.last && itemCenter < selectionZoneMin) {
            offsetCorrectionPublisher.send(scrollProxy.frame(in: .named("scroll")).midY - itemCenter)
        }
        
        return Rectangle().fill(Color.clear)
    }
    
    private func subscribe() {
        labelPublisher
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { item in
                if item != selection {
                    if item == items.first || item == items.last {
                        feedbackGenerator.impactOccurred(intensity: 1)
                    } else {
                        feedbackGenerator.impactOccurred(intensity: 0.7)
                    }
                    selection = item
                }
            }
            .store(in: &subscriptions)
        
        offsetCorrectionPublisher
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { correctionValue in
                withAnimation(.spring()) {
                    dragLocation = dragLocation + correctionValue
                    offset = offset + correctionValue
                }
            }
            .store(in: &subscriptions)
    }
}

struct ValuePicker_Previews: PreviewProvider {
    static var previews: some View {
        ValuePicker(items: ["one", "two", "three"], selection: .constant("two"), colorSelection: .blue)
    }
}

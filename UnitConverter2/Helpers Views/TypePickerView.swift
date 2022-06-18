//
//  TypePickerView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 17.06.2022.
//

import SwiftUI
import Combine

struct TypePickerView: View {
    @State private var labelPublisher = PassthroughSubject<UnitType, Never>()
    @State private var offsetCorrectionPublisher = PassthroughSubject<CGFloat, Never>()
    
    @Binding var selection: UnitType
    @State private var subscriptions = Set<AnyCancellable>()
    
    @State private var dragLocation: CGFloat = 0
    @State private var offset: CGFloat = 0
    
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
    let colorSelection: Color
    
    private var items: [UnitType]
    
    init(items: [UnitType], selection: Binding<UnitType>, colorSelection: Color) {
        self.items = items
        self._selection = selection
        self.colorSelection = colorSelection
    }
    
    var body: some View {
        VStack {
            Text(selection.description)
            
            ZStack {
                GeometryReader { scrollGeo in
                    HStack {
                        ForEach(items, id:\.self) { item in
                            Image(item.imageName)
                                .renderingMode(.template)
                                .foregroundColor(.gray)
                                .padding(4)
                                .foregroundColor(.gray)
                        }
                    }
                    .position(x: scrollGeo.size.width / 2, y: scrollGeo.size.height / 2)
                    .offset(x: dragLocation)
                    
                    ZStack {
                        HStack {
                            ForEach(items, id:\.self) { item in
                                Image(item.imageName)
                                    .renderingMode(.template)
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
                        .offset(x: dragLocation)
                    }
                    .frame(width: 60, height: 60)
                    .background(colorSelection)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .position(x: scrollGeo.size.width / 2, y: scrollGeo.size.height / 2)
                }
            }
            .coordinateSpace(name: "scroll")
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                    .onChanged { value in
                        withAnimation(.spring()) {
                            dragLocation = value.translation.width + offset
                        }
                    }
                    .onEnded { offset += $0.translation.width}
            )
            .task {
                subscribe()
            }
        }
    }
    
    private func scrollObserver(itemProxy: GeometryProxy,
                                scrollProxy: GeometryProxy,
                                selectedLabel: UnitType) -> some View {
        let itemCenter = itemProxy.frame(in: .named("scroll")).midX
        let selectionZoneMin = scrollProxy.frame(in: .named("scroll")).midX - 30
        let selectionZoneMax = scrollProxy.frame(in: .named("scroll")).midX + 30
        let inScroll = itemCenter > selectionZoneMin && itemCenter < selectionZoneMax
        
        if inScroll {
            labelPublisher.send(selectedLabel)
            offsetCorrectionPublisher.send(scrollProxy.frame(in: .named("scroll")).midX - itemCenter)
        }
        
        if (selectedLabel == items.first && itemCenter > selectionZoneMax) ||
            (selectedLabel == items.last && itemCenter < selectionZoneMin) {
            offsetCorrectionPublisher.send(scrollProxy.frame(in: .named("scroll")).midX - itemCenter)
        }
        
        return Rectangle().fill(Color("primaryColor"))
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

struct TypePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TypePickerView(items: [.time, .energy, .flatAngle], selection: .constant(.time), colorSelection: .blue)
    }
}

//
//  ValuePicker.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 12.06.2022.
//

import SwiftUI
import Combine

class ViewModel: ObservableObject {
    
}

struct ValuePicker: View {
    let type: UnitType
    
    private var labelPublisher = PassthroughSubject<String, Never>()
    @State var selectedLabel: String = ""
    @State private var subscriptions = Set<AnyCancellable>()
    
    @State private var dragLocation: CGFloat = 0
    @State private var offset: CGFloat = 0
    
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    private var labels: [String] {
        type.labels
    }
    
    init(type: UnitType, itemHeight: CGFloat = 28, padding: CGFloat = 8) {
        self.type = type
    }
    
    var body: some View {
        ZStack {
            GeometryReader { scrollGeo in
                VStack {
                    ForEach(labels, id:\.self) {
                        Text($0).padding()
                            .foregroundColor(.gray)
                    }
                }
                .position(x: scrollGeo.size.width / 2, y: scrollGeo.size.height / 2)
                .offset(y: dragLocation)
                
                ZStack {
                    VStack {
                        ForEach(labels, id:\.self) { label in
                            Text(label)
                                .bold()
                                .foregroundColor(.primary)
                                .padding()
                                .background(
                                    GeometryReader { itemGeo in
                                        scrollObserver(itemProxy: itemGeo,
                                                       scrollProxy: scrollGeo,
                                                       selectedLabel: label)
                                    }
                                )
                        }
                    }
                    .offset(y: dragLocation)
                }
                .frame(width: 200, height: 60)
                .background(Color.white)
                .clipShape(Capsule())
                .position(x: scrollGeo.size.width / 2, y: scrollGeo.size.height / 2)
                .shadow(color: .gray.opacity(0.5),
                        radius: 5,
                        y: 7)
            }
        }
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
        .onAppear {
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
        
//        let aligned = scrollProxy.frame(in: .global).midY == itemProxy.frame(in: .global).midY
        
        if selectedLabel != self.selectedLabel {
            feedbackGenerator.prepare()
            feedbackGenerator.impactOccurred()
        }
        
        if inScroll {
            labelPublisher.send(selectedLabel)
        }
        
        return Rectangle().fill(Color.clear)
    }
    
    private func subscribe() {
        labelPublisher
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { label in
                self.selectedLabel = label
                print(">>> selected:", label)
            }
            .store(in: &subscriptions)
    }
}

struct ValuePicker_Previews: PreviewProvider {
    static var previews: some View {
        ValuePicker(type: .length)
    }
}

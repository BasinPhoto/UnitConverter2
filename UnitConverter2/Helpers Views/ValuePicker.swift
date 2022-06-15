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
    @State private var scrollHeight: CGFloat = 0
    @State private var scrollOffset: CGRect = CGRect()
    @State private var scrollReaderProxy: ScrollViewProxy!
    
    private var labelPublisher = PassthroughSubject<String, Never>()
    @State var selectedLabel: String = ""
    @State private var subscriptions = Set<AnyCancellable>()
    
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    private var labels: [String] {
        type.labels
    }
    
    @State private var topItems: [String] = []
    @State private var bottomItems: [String] = []
    
    let itemHeight: CGFloat
    let padding: CGFloat
    
    init(type: UnitType, itemHeight: CGFloat = 28, padding: CGFloat = 8) {
        self.type = type
        self.itemHeight = itemHeight
        self.padding = padding
    }
    
    var body: some View {
        ZStack {
            VStack {
                ForEach(topItems, id:\.self) { label in
                    Text(label)
                        .frame(height: itemHeight)
                        .padding(padding)
                        .foregroundColor(.gray)
                        .id(label)
                }
            }
            .offset(y: -CGFloat(topItems.count) * itemHeight)
            
            ScrollViewReader { scrollReaderProxy in
                GeometryReader { scrollProxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            ForEach(type.labels, id:\.self) { label in
                                Text(label)
                                    .frame(height: itemHeight)
                                    .padding(.vertical, padding)
                                    .background (
                                        GeometryReader { proxy in
                                            scrollObserver(scrollReaderProxy: scrollReaderProxy,
                                                           itemProxy: proxy,
                                                           scrollProxy: scrollProxy,
                                                           selectedLabel: label)
                                        }
                                    )
                                    .id(label)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width / 2)
                    }
                    .onAppear {
                        self.scrollReaderProxy = scrollReaderProxy
                        bottomItems = labels
                        subscribe()
                    }
                }
                .frame(width: UIScreen.main.bounds.width / 2,
                       height: itemHeight + padding * 2)
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(Capsule())
            }
            
            VStack {
                ForEach(bottomItems, id:\.self) { label in
                    Text(label)
                        .frame(height: itemHeight)
                        .padding(padding)
                        .foregroundColor(.gray)
                        .id(label)
                }
            }
            .offset(y: CGFloat(bottomItems.count) * itemHeight)
        }
    }
    
    private func scrollObserver(scrollReaderProxy: ScrollViewProxy,
                                itemProxy: GeometryProxy,
                                scrollProxy: GeometryProxy,
                                selectedLabel: String) -> some View {
        let itemVerticalCenter = itemProxy.frame(in: .global).midY
        let inScroll = itemVerticalCenter >= scrollProxy.frame(in: .global).minY &&
        itemVerticalCenter <= scrollProxy.frame(in: .global).maxY
        
        let aligned = itemVerticalCenter == scrollProxy.frame(in: .global).minY
        
        if selectedLabel != self.selectedLabel {
            feedbackGenerator.prepare()
            feedbackGenerator.impactOccurred()
        }
        
        if inScroll && !aligned {
            labelPublisher.send(selectedLabel)
        }
        
        return Rectangle().fill(Color.clear)
    }
    
    private func subscribe() {
        labelPublisher
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { label in
                self.selectedLabel = label
                if let index = labels.firstIndex(of: label) {
                    topItems = Array(labels[0...index].dropLast())
                    bottomItems = Array(labels[index...(labels.count - 1)].dropFirst())
                }
                withAnimation {
                    scrollReaderProxy!.scrollTo(label, anchor: .center)
                }
            }
            .store(in: &subscriptions)
    }
}

struct ValuePicker_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ValuePicker(type: .length)        }
    }
}

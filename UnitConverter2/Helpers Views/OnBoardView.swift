//
//  OnBoardView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 13.03.2021.
//

import SwiftUI

struct OnBoardView: View {
    
    let images: [String] = ["onb1", "onb2", "onb2"]
    let description: [String] = [
        "Свайп влево для выбора категории",
        "Свайп снизу вверх переносит результат в поле ввода",
        "Двойной тап по результату копирует его в буфер обмена"
    ]
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        
        ScrollView(.init()) {
            TabView {
                ForEach(images.indices, id: \.self) { index in
                    VStack{
                        if index == 0 {
                            Image(images[index])
                                .overlay(
                                    GeometryReader { proxy -> Color in
                                        let midX = proxy.frame(in: .global).midX
                                        DispatchQueue.main.async {
                                            withAnimation(.default) {
                                                self.offset = -midX + (getWidth()/2)
                                            }
                                        }
                                        return Color.clear
                                    }
                                    .frame(width: 0, height: 0)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .scaleEffect(0.7)
                                .shadow(color: Color.black.opacity(0.2), radius: 20, y: 20)
                                .offset(y: -20)
                        } else {
                            Image(images[index])
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .scaleEffect(0.7)
                                .shadow(color: Color.black.opacity(0.2), radius: 20, y: 20)
                                .offset(y: -20)
                        }
                        
                        Text(description[index])
                            .foregroundColor(Color("primaryColor"))
                            .font(Font.custom("Exo 2", size: 24))
                            .fontWeight(.bold)
                            .frame(height: 100)
                            .offset(y: -150)
                            .multilineTextAlignment(.leading)
                            .padding()
                    }
                    .frame(width: .infinity, height: UIScreen.main.bounds.height)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .overlay(
                
                HStack(spacing: 15) {
                    
                    ForEach(images.indices, id: \.self) {index in
                        Capsule()
                            .fill(Color("primaryColor"))
                            .frame(width: getIndex() == index ? 20 : 7, height: 7)
                    }
                }
                .overlay(
                    Capsule()
                        .fill(Color("primaryColor"))
                        .frame(width: 20, height: 7)
                        .offset(x: getOffset())
                    , alignment: .leading
                )
                .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                .padding(.bottom, 10)
                
                , alignment: .bottom
            )
        }
        .ignoresSafeArea()
    }
    
    func getIndex() -> Int {
        let index = Int(round(Double(offset / getWidth())))
        return index
    }
    
    func getOffset() -> CGFloat {
        let progress = offset / getWidth()
        return progress * 22
    }
}

extension View {
    func getWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}

struct OnBoardView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardView()
    }
}

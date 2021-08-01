//
//  OnBoardView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 13.03.2021.
//

import SwiftUI

struct OnBoardView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let images: [String] = ["onb1", "onb2", "onb3", "onb4", "onb5", "onb6"]
    let description: [String] = [
        "Swipe left to select a category".localized(),
        "Choose from what and what to convert".localized(),
        "Enter the value at the top and the result will be displayed at the bottom".localized(),
        "Swipe from below copies the result into the input field".localized(),
        "Double tap rounds the value to the nearest integer".localized(),
        "Double tap on the result copies it to the clipboard".localized()
    ]
    
    @State private var offset: CGFloat = 0
    @State private var selectedIndex = 0
    
    var body: some View {
        
        TabView(selection: $selectedIndex) {
            ForEach(images.indices, id: \.self) { index in
                VStack{
                    Image(images[index])
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .padding(40)
                        .shadow(color: Color.black.opacity(0.2), radius: 20, y: 20)
                    
                    Text(description[index])
                        .foregroundColor(Color("primaryColor"))
                        .font(Font.custom("Exo 2", size: 20))
                        .fontWeight(.bold)
                        .frame(height: 100)
                        .offset(y: -60)
                        .multilineTextAlignment(.leading)
                        .padding()
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .overlay(

            HStack(spacing: 15) {

                ForEach(images.indices, id: \.self) {index in
                    Capsule()
                        .fill(index == selectedIndex ? Color("primaryColor") : Color("primaryColor").opacity(0.5))
                        .frame(width: 7, height: 7)
                }
            }
            , alignment: .bottom
        )
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        .padding(.bottom, 10)
        .onDisappear {
            UserDefaults.standard.setValue(false, forKey: "onboard")
        }
        .ignoresSafeArea()
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

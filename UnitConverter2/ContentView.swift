//
//  ContentView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 30.11.2020.
//

import SwiftUI


struct ContentView: View {
    
    @State var showAllCategories: Bool = false
    @State var inFocus: Bool = false
    @State var showPicker = false
    @State private var numberOfPicker: Int = 0
    
    @StateObject var unit: ConverterViewModel
    
    let clipboard = UIPasteboard.general

    var body: some View {
        
        ZStack{
            //Background rectangles
            VStack(spacing: 0){
                Color("primaryColor")
                Color.white
            }
            .animation(.easeIn)
            
            //input and output value fields
            VStack {
                
                if showPicker && numberOfPicker == 2 {
                    Text("\(unit.keysArray[unit.selectedFrom])")
                        .font(Font.custom("Exo 2", size: 60)).fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 100)
                        .offset(x: showPicker && numberOfPicker == 1 ? UIScreen.main.bounds.width : 0 , y: UIScreen.main.bounds.height / -6)
                        .animation(.easeIn)
                } else {
                    TextField(unit.amountInString, text: $unit.amountInString)
                        .font(Font.custom("Exo 2", size: 60))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .foregroundColor(inFocus ? Color("primaryColor") : .white)
                        .accentColor(Color("primaryColor"))
                        .background(inFocus ? Color.white : Color("primaryColor"))
                        .cornerRadius(30)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 100)
                        .shadow(color: inFocus ? Color.black.opacity(0.2) : Color.black.opacity(0), radius: inFocus ? 10 : 0, y: inFocus ? 10 : 0)
                        .offset(x: showPicker && numberOfPicker == 1 ? UIScreen.main.bounds.width : 0 , y: UIScreen.main.bounds.height / -6)
                        .disabled(showAllCategories)
                        .onTapGesture {
                            inFocus = true
                            showAllCategories = false
                            showPicker = false
                            unit.temporaryValue = unit.amountInString
                            unit.amountInString = ""
                        }
                        .animation(.easeIn)
                }
                
                if showPicker && numberOfPicker == 1 {
                    Text("\(unit.keysArray[unit.selectedTo])")
                        .font(Font.custom("Exo 2", size: 60)).fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("primaryColor"))
                        .frame(width: UIScreen.main.bounds.width - 32, height: 100)
                        .offset(x: showPicker && numberOfPicker == 2 ? -UIScreen.main.bounds.width : 0 , y: UIScreen.main.bounds.height / 7)
                        .animation(.easeIn)
                } else {
                    Text("\(unit.result, specifier: "%g")")
                        .padding(.horizontal)
                        .foregroundColor(Color("primaryColor"))
                        .font(Font.custom("Exo 2", size: 60))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 100)
                        .offset(x: showPicker && numberOfPicker == 2 ? -UIScreen.main.bounds.width : 0 , y: UIScreen.main.bounds.height / 7)
                        .onTapGesture(count: 2) {
                            if unit.result != 0 {
                                clipboard.string = String(unit.result)
                            }
                        }
                        .animation(.easeIn)
                }
                
            }
            
            //arrows
            Group{
                Image(systemName: "arrow.down")
                    .font(Font.system(size: 100, weight: .black))
                    .foregroundColor(Color("primaryColor"))
                    .scaleEffect(showPicker && numberOfPicker == 1 ? 1 : 0)
                    .offset(y: showPicker && numberOfPicker == 1 ? 40 : 0)
                    .animation(Animation.easeOut(duration: 0.2).delay(showPicker ? 0.2 : 0))
                
                Image(systemName: "arrow.up")
                    .font(Font.system(size: 100, weight: .black))
                    .foregroundColor(.white)
                    .scaleEffect(showPicker && numberOfPicker == 2 ? 1 : 0)
                    .offset(y: showPicker && numberOfPicker == 2 ? -40 : 0)
                    .animation(Animation.easeOut(duration: 0.2).delay(showPicker ? 0.2 : 0))
            }
            
            // pickers
            VStack{
                
                TypePicker(toVar: $unit.selectedFrom, showPicker: $showPicker, unit: unit, backgroungColor: Color("primaryColor"), accentColor: .white)
                    .padding(.top, 50)
                    .offset(x: !showPicker || numberOfPicker == 2 ? -UIScreen.main.bounds.width : 0, y: -10)
                    .animation(.easeIn)
                
                TypePicker(toVar: $unit.selectedTo, showPicker: $showPicker, unit: unit, backgroungColor: .white, accentColor: Color("primaryColor"))
                    .offset(x: !showPicker || numberOfPicker == 1 ? UIScreen.main.bounds.width : 0, y: 0)
                    .animation(.easeIn)
            }
            
            
            //type picker buttons
            HStack(spacing: 0) {
                
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    numberOfPicker = 1
                    self.showPicker.toggle()
                }, label: {
                    Text(unit.keysArray[unit.selectedFrom])
                        .font(Font.custom("Exo 2", size: 24).bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.3)
                })
                .padding()
                .frame(width: showPicker && numberOfPicker == 1 ? UIScreen.main.bounds.width : UIScreen.main.bounds.width / 2, height: 60)
                .background(Color("primaryColor"))
                .foregroundColor(.white)
                .cornerRadius(25)
                .animation(.easeIn)
                .disabled(showAllCategories)
                
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    numberOfPicker = 2
                    self.showPicker.toggle()
                }, label: {
                    Text(unit.keysArray[unit.selectedTo])
                        .font(Font.custom("Exo 2", size: 24).bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.3)
                })
                .padding()
                .frame(width: showPicker && numberOfPicker == 2 ? UIScreen.main.bounds.width : UIScreen.main.bounds.width / 2, height: 60)
                .background(Color.white)
                .foregroundColor(Color("primaryColor"))
                .cornerRadius(25)
                .animation(.easeIn)
                .disabled(showAllCategories)
            }
            .offset(x: showPicker && numberOfPicker == 1 ? UIScreen.main.bounds.width / 4 : 0)
            .offset(x: showPicker && numberOfPicker == 2 ? UIScreen.main.bounds.width / -4 : 0)
            
            //dropdown menu
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    DropDownMenu(showAllCategories: $showAllCategories, unit: unit)
                        .padding(.trailing, 30)
                        .padding(.bottom, 90)
                        .animation(.easeIn)
                }
            }
            .offset(x: showPicker ? -100 : 0,y: showPicker ? 200 : 0)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onTapGesture {
            if unit.amountInString == "" {
                unit.amountInString = unit.temporaryValue
            }
            inFocus = false
            showPicker = false
            showAllCategories = false
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .gesture(
            // hide and show dropdown menu by swipe
            DragGesture().onChanged { value in
                if value.translation.width < 0 && value.translation.width < -50 {
                    showPicker = false
                    inFocus = false
                    showAllCategories = true
                } else if value.translation.width > 0 && value.translation.width > 50 {
                    showAllCategories = false
                }
                
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(unit: ConverterViewModel())
    }
}

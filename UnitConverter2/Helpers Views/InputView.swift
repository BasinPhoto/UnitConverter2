//
//  InputView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 18.06.2022.
//

import SwiftUI

struct InputView: View {
    @Binding var value: String
    
    private func handleTap(value: String) {
        if let tmpValue = Double(self.value), tmpValue != 0 {
            self.value += value
        } else {
            self.value = value
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Group{
                    Button {
                        handleTap(value: "1")
                    } label: {
                        Text("1")
                            
                    }
                    Button {
                        handleTap(value: "2")
                    } label: {
                        Text("2")
                    }
                    Button {
                        handleTap(value: "3")
                    } label: {
                        Text("3")
                    }
                    Button {
                        handleTap(value: "4")
                    } label: {
                        Text("4")
                    }
                    Button {
                        handleTap(value: "5")
                    } label: {
                        Text("5")
                    }
                    Button {
                        handleTap(value: ".")
                    } label: {
                        Text(".")
                    }

                }
                .font(.title)
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
                .background(Color("primaryColor"))
                .cornerRadius(16)
            }
            
            HStack {
                Group{
                    Button {
                        handleTap(value: "6")
                    } label: {
                        Text("6")
                            
                    }
                    Button {
                        handleTap(value: "7")
                    } label: {
                        Text("7")
                    }
                    Button {
                        handleTap(value: "8")
                    } label: {
                        Text("8")
                    }
                    Button {
                        handleTap(value: "9")
                    } label: {
                        Text("9")
                    }
                    Button {
                        handleTap(value: "0")
                    } label: {
                        Text("0")
                    }
                    Button {
                        if value.count > 1 {
                            value = String(value.dropLast())
                        } else {
                            value = "0"
                        }
                    } label: {
                        Image(systemName: "delete.left")
                    }

                }
                .font(.title)
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
                .background(Color("primaryColor"))
                .cornerRadius(16)
            }
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(value: .constant("12"))
    }
}

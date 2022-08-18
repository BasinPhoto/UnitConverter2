//
//  InputView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 18.06.2022.
//

import SwiftUI

struct InputView: View {
    
    @Binding var value: String
    @Binding var operation: OperationType?
    @Binding var operationValue: String
    
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    
    private func handleTap(value: String) {
        feedbackGenerator.prepare()
        if let _ = operation {
            if let tmpValue = Double(self.value), tmpValue != 0 {
                self.operationValue += value
            } else {
                self.operationValue = value
            }
        } else {
            if let tmpValue = Double(self.value), tmpValue != 0 {
                self.value += value
            } else {
                self.value = value
            }
        }
        feedbackGenerator.impactOccurred()
    }
    
    private func calculate() {
        if let operationValue = Double(operationValue),
            let valueNumber = Double(value) {
            switch operation {
            case .plus:
                value = (valueNumber + operationValue).removeZerosFromEnd().description
            case .minus:
                value = (valueNumber - operationValue).removeZerosFromEnd().description
            case .multiply:
                value = (valueNumber * operationValue).removeZerosFromEnd().description
            case .divide:
                guard operationValue != 0 else { return }
                value = (valueNumber / operationValue).removeZerosFromEnd().description
            default:
                return
            }
            
            operation = nil
            self.operationValue = ""
            feedbackGenerator.impactOccurred()
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
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .foregroundColor(.accentColor)
                .background(Color.white)
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
                    
                    Image(systemName: "delete.left.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .scaledToFit()
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .onTapGesture {
                            if value.count > 1 {
                                value = String(value.dropLast())
                            } else {
                                value = "0"
                            }
                            feedbackGenerator.impactOccurred()
                        }
                        .onLongPressGesture {
                            value = "0"
                            feedbackGenerator.impactOccurred()
                        }

                }
                .font(.title)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .foregroundColor(.accentColor)
                .background(Color.white)
                .cornerRadius(16)
            }
            
            HStack {
                Button {
                    if let unwrappedValue = Double(value), unwrappedValue > 0 {
                        operation = .plus
                        feedbackGenerator.impactOccurred()
                    }
                } label: {
                    Text("+")
                        .font(.title)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(operation == .plus ? Color("primaryColor") : Color.orange)
                        .cornerRadius(16)
                }
                
                Button {
                    if let unwrappedValue = Double(value), unwrappedValue > 0 {
                        operation = .minus
                        feedbackGenerator.impactOccurred()
                    }
                } label: {
                    Text("-")
                        .font(.title)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(operation == .minus ? Color("primaryColor") : Color.orange)
                        .cornerRadius(16)
                }
                
                Button {
                    if let unwrappedValue = Double(value), unwrappedValue > 0 {
                        operation = .multiply
                        feedbackGenerator.impactOccurred()
                    }
                } label: {
                    Text("*")
                        .font(.title)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(operation == .multiply ? Color("primaryColor") : Color.orange)
                        .cornerRadius(16)
                }
                
                Button {
                    if let unwrappedValue = Double(value), unwrappedValue > 0 {
                        operation = .divide
                        feedbackGenerator.impactOccurred()
                    }
                } label: {
                    Text("/")
                        .font(.title)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(operation == .divide ? Color("primaryColor") : Color.orange)
                        .cornerRadius(16)
                }
                
                Button {
                    self.calculate()
                } label: {
                    Text("=")
                        .font(.title)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(16)
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 32)
        .background {
            Color.accentColor
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(value: .constant("12"),
                  operation: .constant(nil),
                  operationValue: .constant(""))
    }
}

//
//  InputView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 18.06.2022.
//

import SwiftUI
import AVFoundation

struct InputView: View {
    
    @Binding var value: String
    @Binding var operation: OperationType?
    @Binding var operationValue: String
    
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    
    private func handleTap(value: String) {
        feedbackGenerator.prepare()
        
        if value == "." && (operationValue.contains(".") || self.value.contains(".")) {
            return
        }
        
        if self.value.count == 1 && self.value == "0" {
            if let _ = operation {
                self.operationValue = value
            } else {
                self.value = value
            }
        } else {
            if let _ = operation {
                self.operationValue += value
            } else {
                self.value += value
            }
        }
        
        feedbackGenerator.impactOccurred()
        AudioServicesPlaySystemSound(1104)
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
                Group {
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
                .cornerRadius(8)
                .contentShape(Rectangle())
            }
            
            HStack {
                Group {
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
                        .cornerRadius(8)
                        .onTapGesture {
                            if operationValue.count >= 1 {
                                operationValue = String(operationValue.dropLast())
                            } else if operationValue.isEmpty && operation != nil {
                                operation = nil
                            } else if value.count > 1 {
                                value = String(value.dropLast())
                            } else {
                                value = "0"
                            }
                            feedbackGenerator.impactOccurred()
                            AudioServicesPlaySystemSound(1104)
                        }
                        .onLongPressGesture {
                            value = "0"
                            feedbackGenerator.impactOccurred()
                            AudioServicesPlaySystemSound(1104)
                        }

                }
                .font(.title)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .foregroundColor(.accentColor)
                .background(Color.white)
                .cornerRadius(8)
                .contentShape(Rectangle())
            }
            
            Group {
                HStack {
                    Button {
                        if let unwrappedValue = Double(value), unwrappedValue > 0 {
                            operation = .plus
                            feedbackGenerator.impactOccurred()
                            AudioServicesPlaySystemSound(1104)
                        }
                    } label: {
                        Image(systemName: "plus")
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(operation == .plus ? Color.accentColor : Color.orange)
                            .cornerRadius(8)
                            .overlay {
                                if operation == .plus {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.white, lineWidth: 4)
                                }
                            }
                    }
                    
                    Button {
                        if let unwrappedValue = Double(value), unwrappedValue > 0 {
                            operation = .minus
                            feedbackGenerator.impactOccurred()
                            AudioServicesPlaySystemSound(1104)
                        }
                    } label: {
                        Image(systemName: "minus")
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(operation == .minus ? Color.accentColor : Color.orange)
                            .cornerRadius(8)
                            .overlay {
                                if operation == .minus {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.white, lineWidth: 4)
                                }
                            }
                    }
                    
                    Button {
                        if let unwrappedValue = Double(value), unwrappedValue > 0 {
                            operation = .multiply
                            feedbackGenerator.impactOccurred()
                            AudioServicesPlaySystemSound(1104)
                        }
                    } label: {
                        Image(systemName: "multiply")
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(operation == .multiply ? Color.accentColor : Color.orange)
                            .cornerRadius(8)
                            .overlay {
                                if operation == .multiply {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.white, lineWidth: 4)
                                }
                            }
                    }
                    
                    Button {
                        if let unwrappedValue = Double(value), unwrappedValue > 0 {
                            operation = .divide
                            feedbackGenerator.impactOccurred()
                            AudioServicesPlaySystemSound(1104)
                        }
                    } label: {
                        Image(systemName: "divide")
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(operation == .divide ? Color.accentColor : Color.orange)
                            .cornerRadius(8)
                            .overlay {
                                if operation == .divide {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.white, lineWidth: 4)
                                }
                            }
                    }
                    
                    Button {
                        self.calculate()
                        feedbackGenerator.impactOccurred()
                        AudioServicesPlaySystemSound(1104)
                    } label: {
                        Image(systemName: "equal")
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                }
            }
            .contentShape(Rectangle())
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

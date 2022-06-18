//
//  InputView.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 18.06.2022.
//

import SwiftUI

struct InputView: View {
    enum OperationType {
        case plus
        case minus
        case multiply
        case divide
    }
    
    @Binding var value: String
    @State var operation: OperationType?
    @State var operationValue: String = ""
    
    private func handleTap(value: String) {
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
    }
    
    private func calculate() {
        if let operationValue = Double(operationValue),
            let valueNumber = Double(value) {
            switch operation {
            case .plus:
                value = (valueNumber + operationValue).description
            case .minus:
                value = (valueNumber - operationValue).description
            case .multiply:
                value = (valueNumber * operationValue).description
            case .divide:
                guard operationValue != 0 else { return }
                value = (valueNumber / operationValue).description
            default:
                return
            }
            
            operation = nil
            self.operationValue = ""
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
                    
                    Image(systemName: "delete.left.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .background(Color.red)
                        .cornerRadius(16)
                        .onTapGesture {
                            if value.count > 1 {
                                value = String(value.dropLast())
                            } else {
                                value = "0"
                            }
                        }
                        .onLongPressGesture {
                            value = "0"
                        }

                }
                .font(.title)
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
                .background(Color("primaryColor"))
                .cornerRadius(16)
            }
            
            HStack {
                Button {
                    if let unwrappedValue = Double(value), unwrappedValue > 0 {
                        operation = .plus
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
                        .background(Color.orange)
                        .cornerRadius(16)
                }
            }
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(value: .constant("12"))
    }
}

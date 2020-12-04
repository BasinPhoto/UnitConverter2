//
//  UnitConverterModel.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 30.11.2020.
//

import Foundation

let values = [
    ["Метр" : 1, "Фут" : 0.3, "Ярд" : 0.91],
    ["Объем1" : 1, "Объем2" : 0.25, "Объем3" : 0.66],
    ["Килограмм" : 1, "Фунт" : 0.33, "Унция" : 0.12]
]

let unitTypeName: [String] = ["Длина", "Объем", "Вес"]

enum UnitType: Int {
    case length
    case volume
    case weight
}

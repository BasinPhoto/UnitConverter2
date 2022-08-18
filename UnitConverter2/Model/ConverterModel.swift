//
//  UnitConverterModel.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 30.11.2020.
//

import Foundation

enum UnitType: Int, CaseIterable, Identifiable {
    
    static var allValues: [[String : Double]] = [
        //Длина
        ["Meter" : 1, "Kilometer" : 1000, "Centimeter" : 0.01, "Millimeter" : 0.001, "Mile" : 1609.34, "Yard" : 0.9144, "Feet" : 0.3048, "Inch" : 0.0254, "Admiralty Mile" : 1852],
        //Объем
        ["Liter" : 1, "American Gallon" : 3.78541, "American Liquid Quart" : 0.946353, "American Liquid Pint" : 0.473176, "American Cup" : 0.24, "American Fluid Ounce" : 0.0295735, "American Table Spoon" : 0.0147868, "American Teaspoon" : 0.00492892, "Cubic Meter" : 1000, "Milliliter" : 0.001, "Imp. Gallon" : 4.54609, "Imp. Quart" : 1.13652, "Imp. Pint" : 0.568261, "Imp. Fluid Ounce" : 0.0284131, "British Tablespoon" : 0.0177582, "British Teaspoon" : 0.00591939, "Cubic Feet" : 28.3168, "Cubic Inch" : 0.0163871],
        //Масса
        ["Kilogram" : 1, "Ton" : 1000, "Gram" : 0.001, "English Ton" : 1016.05, "American Ton" : 907.185, "Stone" : 6.35029, "Pound" : 0.453592, "Ounce" : 0.0283495],
        //Время
        ["Second" : 1, "Millisecond" : 0.001, "Minute" : 60, "Hour" : 3600, "Day" : 86400, "Week" : 604800, "Month" : 2.628e+6, "Year" : 3.154e+7, "Decade" : 3.154e+8, "Century" : 3.154e+9],
        //Давление
        ["Atmosphere" : 1, "Bar" : 0.986923, "Pascal" : 9.8692e-6, "Torr" : 0.00131579, "Pound Force Per Square Inch" : 0.068046],
        //Объем информации
        ["Byte" : 1, "Bit" : 0.125, "Kilobit" : 125, "Kibibit" : 128, "Megabit" : 125000, "Mebibit" : 131072, "Gigabit" : 1.25e+8, "Gibibit" : 1.342e+8, "Terabit" : 1.25e+11, "Tebibit" : 1.374e+11, "Petabit" : 1.25e+14, "Pebibit" : 1.407e+14, "Kilobyte" : 1000, "Kibibyte" : 1024, "Megabyte" : 1e+6, "Mebibyte" : 1.049e+6, "Gigabyte" : 1e+9, "Gibibyte" : 1.074e+9, "Terabyte" : 1e+12, "Tebibayt" : 1.1e+12, "Petabyte" : 1e+15, "Pebibyte" : 1.126e+15],
        //Плоский угол
        ["Degree" : 1, "Radian" : 57.2958, "Grad" : 0.9, "ArcMinute" : 0.0166667, "Thousandth" : 0.0572958, "Angular Second" : 0.000277778],
        //Площадь
        ["Square Meter" : 1, "Square Kilometer" : 1e+6, "Square Mile" : 2.59e+6, "Square Yard" : 0.836127, "Square Feet" : 0.092903, "Square Inch" : 0.00064516, "Hectare" : 10000, "Acre" : 4046.86],
        //Скорость
        ["Meter Per Second" : 1, "Km Per Hour" : 0.277778, "Knot" : 0.514444, "Feet Per Second" : 0.3048, "Mile Per Hour" : 0.44704],
        //Энергия
        ["Kilowatt-Hour" : 1, "Joule" : 2.7778e-7, "Kilojoule" : 0.000277778, "Gram-Calorie" : 1.1622e-6, "Kilocalorie" : 0.00116222, "Watt-Hour" : 0.001, "Electron-Volt" : 4.4505e-26, "British Thermal Unit" : 0.000293071, "American Therm" : 23.3001, "Feet-Pound" : 3.7662e-7]
    ]
    
    static let flags = [
        "USD" : "🇺🇸", "AED" : "🇦🇪", "AFN" : "🇦🇫", "ALL" : "🇦🇱", "AMD" : "🇦🇲", "ANG" : "🇳🇱", "AOA" : "🇦🇴", "ARS" : "🇦🇷", "AUD" : "🇦🇺", "AWG" : "🇦🇼", "AZN" : "🇦🇿", "BAM" : "🇧🇦", "BBD" : "🇧🇧", "BDT" : "🇧🇩", "BGN" : "🇧🇬", "BHD" : "🇧🇭", "BIF" : "🇧🇮", "BMD" : "🇧🇲", "BND" : "🇧🇳", "BOB" : "🇧🇴", "BRL" : "🇧🇷", "BSD" : "🇧🇸", "BTN" : "🇧🇹", "BWP" : "🇧🇼", "BYN" : "🇧🇾", "BZD" : "🇧🇿", "CAD" : "🇨🇦", "CDF" : "🇨🇩", "CHF" : "🇨🇭", "CLP" : "🇨🇱", "CNY" : "🇨🇳", "COP" : "🇨🇴", "CRC" : "🇨🇷", "CUC" : "🇨🇺", "CUP" : "🇨🇺", "CVE" : "🇨🇻", "CZK" : "🇨🇿", "DJF" : "🇩🇯", "DKK" : "🇩🇰", "DOP" : "🇩🇴", "DZD" : "🇩🇿", "EGP" : "🇪🇬", "ERN" : "🇪🇷", "ETB" : "🇪🇹", "EUR" : "🇪🇺", "FJD" : "🇫🇯", "FKP" : "🇫🇰", "FOK" : "🇫🇴", "GBP" : "🇬🇧", "GEL" : "🇬🇪", "GGP" : "🇬🇬", "GHS" : "🇬🇭", "GIP" : "🇬🇮", "GMD" : "🇬🇲", "GNF" : "🇬🇳", "GTQ" : "🇬🇹", "GYD" : "🇬🇾", "HKD" : "🇭🇰", "HNL" : "🇭🇳", "HRK" : "🇭🇷", "HTG" : "🇭🇹", "HUF" : "🇭🇺", "IDR" : "🇮🇩", "ILS" : "🇮🇱", "IMP" : "🇮🇲", "INR" : "🇮🇳", "IQD" : "🇮🇶", "IRR" : "🇮🇷", "ISK" : "🇮🇸", "JMD" : "🇯🇲", "JOD" : "🇯🇴", "JPY" : "🇯🇵", "KES" : "🇰🇪", "KGS" : "🇰🇬", "KHR" : "🇰🇭", "KID" : "🇰🇮", "KMF" : "🇰🇲", "KRW" : "🇰🇷", "KWD" : "🇰🇼", "KYD" : "🇰🇾", "KZT" : "🇰🇿", "LAK" : "🇱🇦", "LBP" : "🇱🇧", "LKR" : "🇱🇰", "LRD" : "🇱🇷", "LSL" : "🇱🇸", "LYD" : "🇱🇾", "MAD" : "🇲🇦", "MDL" : "🇲🇩", "MGA" : "🇲🇬", "MKD" : "🇲🇰", "MMK" : "🇲🇲", "MNT" : "🇲🇳", "MOP" : "🇲🇴", "MRU" : "🇲🇷", "MUR" : "🇲🇺", "MVR" : "🇲🇻", "MWK" : "🇲🇼", "MXN" : "🇲🇽", "MYR" : "🇲🇾", "MZN" : "🇲🇿", "NAD" : "🇳🇦", "NGN" : "🇳🇬", "NIO" : "🇳🇮", "NOK" : "🇳🇴", "NPR" : "🇳🇵", "NZD" : "🇳🇿", "OMR" : "🇴🇲", "PAB" : "🇵🇦", "PEN" : "🇵🇪", "PGK" : "🇵🇬", "PHP" : "🇵🇭", "PKR" : "🇵🇰", "PLN" : "🇵🇱", "PYG" : "🇵🇾", "QAR" : "🇶🇦", "RON" : "🇷🇴", "RSD" : "🇷🇸", "RUB" : "🇷🇺", "RWF" : "🇷🇼", "SAR" : "🇸🇦", "SBD" : "🇸🇧", "SCR" : "🇸🇨", "SDG" : "🇸🇩", "SEK" : "🇸🇪", "SGD" : "🇸🇬", "SHP" : "🇸🇭", "SLL" : "🇸🇱", "SOS" : "🇸🇴", "SRD" : "🇸🇷", "SSP" : "🇸🇸", "STN" : "🇸🇹", "SYP" : "🇸🇾", "SZL" : "🇸🇿", "THB" : "🇹🇭", "TJS" : "🇹🇯", "TMT" : "🇹🇲", "TND" : "🇹🇳", "TOP" : "🇹🇴", "TRY" : "🇹🇷", "TTD" : "🇹🇹", "TVD" : "🇹🇻", "TWD" : "🇹🇼", "TZS" : "🇹🇿", "UAH" : "🇺🇦", "UGX" : "🇺🇬", "UYU" : "🇺🇾", "UZS" : "🇺🇿", "VES" : "🇻🇪", "VND" : "🇻🇳", "VUV" : "🇻🇺", "WST" : "🇼🇸", "XAF" : "🇬🇶", "XCD" : "🇩🇲", "XDR" : "🪙", "XOF" : "🇳🇪", "XPF" : "🇵🇫", "YER" : "🇾🇪", "ZAR" : "🇿🇦", "ZMW" : "🇿🇲"
    ]
    
    var id: String {
        description
    }
    
    case length
    case volume
    case weight
    case time
    case pressure
    case information
    case flatAngle
    case square
    case speed
    case energy
    case money
    
    var description: String {
        switch self {
        case .length:
            return "Lenth"
        case .volume:
            return "Volume"
        case .weight:
            return "Weight"
        case .time:
            return "Time"
        case .pressure:
            return "Pressure"
        case .information:
            return "Information"
        case .flatAngle:
            return "FlatAngle"
        case .square:
            return "Square"
        case .speed:
            return "Speed"
        case .energy:
            return "Energy"
        case .money:
            return "Currency"
        }
    }
    
    var imageName: String {
        switch self {
        case .length:
            return "length"
        case .volume:
            return "volume"
        case .weight:
            return "weight"
        case .time:
            return "time"
        case .pressure:
            return "pressure"
        case .information:
            return "information"
        case .flatAngle:
            return "flatAngle"
        case .square:
            return "square"
        case .speed:
            return "speed"
        case .energy:
            return "energy"
        case .money:
            return "money"
        }
    }
    
    var labels: [String] {
        switch self {
        case .length:
            return Self.allValues[0].keys.sorted()
        case .volume:
            return Self.allValues[1].keys.sorted()
        case .weight:
            return Self.allValues[2].keys.sorted()
        case .time:
            return Self.allValues[3].keys.sorted()
        case .pressure:
            return Self.allValues[4].keys.sorted()
        case .information:
            return Self.allValues[5].keys.sorted()
        case .flatAngle:
            return Self.allValues[6].keys.sorted()
        case .square:
            return Self.allValues[7].keys.sorted()
        case .speed:
            return Self.allValues[8].keys.sorted()
        case .energy:
            return Self.allValues[9].keys.sorted()
        case .money:
            if Self.allValues.count > 10 {
                return Self.allValues[10].keys.sorted().map { element in
                    return element + (Self.flags[element] ?? "")
                }
            } else {
                return []
            }
        }
    }
}

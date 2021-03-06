//
//  UnitConverterModel.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 30.11.2020.
//

import Foundation

enum UnitType: Int, CaseIterable, Identifiable {
    
    static var allValues = [
        //Длина
        ["Метр" : 1, "Километр" : 1000, "Сантиметр" : 0.01, "Миллиметр" : 0.001, "Миля" : 1609.34, "Ярд" : 0.9144, "Фут" : 0.3048, "Дюйм" : 0.0254, "Морская миля" : 1852],
        //Объем
        ["Литр" : 1, "Амер.галлон" : 3.78541, "Амер.жидкая кварта" : 0.946353, "Амер.жидкая пинта" : 0.473176, "Амер.чашка" : 0.24, "Амер.жидкая унция" : 0.0295735, "Амер.столовая ложка" : 0.0147868, "Амер.чайная ложка" : 0.00492892, "Куб.метр" : 1000, "Миллилитр" : 0.001, "Имп.галлон" : 4.54609, "Имп.кварта" : 1.13652, "Имп.пинта" : 0.568261, "Имп.жидкая унция" : 0.0284131, "Брит.столовая ложка" : 0.0177582, "Брит.чайная ложка" : 0.00591939, "Куб.фут" : 28.3168, "Куб.дюйм" : 0.0163871],
        //Масса
        ["Килограмм" : 1, "Тонна" : 1000, "Грамм" : 0.001, "Англ.тонна" : 1016.05, "Амер.тонна" : 907.185, "Стон" : 6.35029, "Фунт" : 0.453592, "Унция" : 0.0283495],
        //Время
        ["Секунда" : 1, "Миллисекунда" : 0.001, "Минута" : 60, "Час" : 3600, "Сутки" : 86400, "Неделя" : 604800, "Месяц" : 2.628e+6, "Год" : 3.154e+7, "Десятилетие" : 3.154e+8, "Век" : 3.154e+9],
        //Давление
        ["Атмосфера" : 1, "Бар" : 0.986923, "Паскаль" : 9.8692e-6, "Торр" : 0.00131579, "Фунт-сила на кв.дюйм" : 0.068046],
        //Объем информации
        ["Байт" : 1, "Бит" : 0.125, "Килобит" : 125, "Кибибит" : 128, "Мегабит" : 125000, "Мебибит" : 131072, "Гигабит" : 1.25e+8, "Гибибит" : 1.342e+8, "Терабит" : 1.25e+11, "Тебибит" : 1.374e+11, "Петабит" : 1.25e+14, "Пебибит" : 1.407e+14, "Килобайт" : 1000, "Кибибайт" : 1024, "Мегабайт" : 1e+6, "Мебибайт" : 1.049e+6, "Гигабайт" : 1e+9, "Гибибайт" : 1.074e+9, "Терабайт" : 1e+12, "Тебибайт" : 1.1e+12, "Петабайт" : 1e+15, "Пебибайт" : 1.126e+15],
        //Плоский угол
        ["Градус" : 1, "Радиан" : 57.2958, "Град" : 0.9, "Минута дуги" : 0.0166667, "Тысячная" : 0.0572958, "Угловая секунда" : 0.000277778],
        //Площадь
        ["Квад.метр" : 1, "Квад.километр" : 1e+6, "Квад.миля" : 2.59e+6, "Квад.ярд" : 0.836127, "Квад.фут" : 0.092903, "Квад.дюйм" : 0.00064516, "Гектар" : 10000, "Акр" : 4046.86],
        //Скорость
        ["Метр в сек." : 1, "Км в час" : 0.277778, "Узел" : 0.514444, "Фут в сек." : 0.3048, "Миля в час" : 0.44704],
        //Энергия
        ["Киловатт-час" : 1, "Джоуль" : 2.7778e-7, "Килоджоуль" : 0.000277778, "Грамм-калория" : 1.1622e-6, "Килокалория" : 0.00116222, "Ватт-час" : 0.001, "Электронвольт" : 4.4505e-26, "Брит.тепловая ед." : 0.000293071, "Амер.терм" : 23.3001, "Фут-фунт" : 3.7662e-7]
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
            return "Длина"
        case .volume:
            return "Объем"
        case .weight:
            return "Масса"
        case .time:
            return "Время"
        case .pressure:
            return "Давление"
        case .information:
            return "Информация"
        case .flatAngle:
            return "Угол"
        case .square:
            return "Площадь"
        case .speed:
            return "Скорость"
        case .energy:
            return "Энергия"
        case .money:
            return "Валюта"
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
}

struct CurrencyRates: Codable {
    let result: String
    let timeLastUpdateUnix: Int
    let timeLastUpdateUTC: String
    let timeNextUpdateUnix: Int
    let timeNextUpdateUTC, baseCode: String
    let conversionRates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case result
        case timeLastUpdateUnix = "time_last_update_unix"
        case timeLastUpdateUTC = "time_last_update_utc"
        case timeNextUpdateUnix = "time_next_update_unix"
        case timeNextUpdateUTC = "time_next_update_utc"
        case baseCode = "base_code"
        case conversionRates = "conversion_rates"
    }
}

enum PickerSide: Int {
    case both
    case left
    case right
}

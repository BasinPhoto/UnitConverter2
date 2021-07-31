//
//  StringExtension.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 31.07.2021.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self,
                                 tableName: "Localization",
                                 bundle: .main,
                                 value: self,
                                 comment: self)
    }
}

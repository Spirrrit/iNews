//
//  Date + Ext.swift
//  iNews MVVM+C
//
//  Created by Слава on 09.08.2024.
//

import Foundation

extension Date {
    var toRusString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("E, dd MMMM HH:mm")
        return dateFormatter.string(from: self)
    }
}

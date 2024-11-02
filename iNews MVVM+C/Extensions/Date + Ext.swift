//
//  Date + Ext.swift
//  iNews MVVM+C
//
//  Created by Слава on 09.08.2024.
//

import Foundation

struct CustomDateFormator {
    let dateFormatter = DateFormatter()
}

extension Date {
    var toRusString: String {
        let dateFormatter = CustomDateFormator()
        dateFormatter.dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormatter.setLocalizedDateFormatFromTemplate("E, dd MMMM HH:mm")
        return dateFormatter.dateFormatter.string(from: self)
    }
}

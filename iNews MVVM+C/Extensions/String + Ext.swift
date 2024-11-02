//
//  String + Ext.swift
//  iNews MVVM+C
//
//  Created by Слава on 22.07.2024.
//

import Foundation
import UIKit

extension String {
    
    func getDate() -> Date? {
        let dateFormatter = CustomDateFormator()
        dateFormatter.dateFormatter.dateFormat = "E, d MM yyyy HH:mm:ss Z"
        return dateFormatter.dateFormatter.date(from: self)
    }
    
    func deleteHtmlSymbol() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: "&laquo;", with: "«").replacingOccurrences(of: "&raquo;", with: "»").replacingOccurrences(of: "&nbsp;", with: " ").replacingOccurrences(of: "<p>", with: "\n").replacingOccurrences(of: "</p>", with: "\n").replacingOccurrences(of: "&mdash;", with: " — ").replacingOccurrences(of: "&ndash;", with: " — ").replacingOccurrences(of: "&lt;", with: "<").replacingOccurrences(of: "&gt;", with: ">").replacingOccurrences(of: "&hellip;", with: "...").replacingOccurrences(of: "&euro;", with: "€").replacingOccurrences(of: "//", with: ".").replacingOccurrences(of: "&#34;", with: "'")
    }
}

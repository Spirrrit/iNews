//
//  String + Ext.swift
//  iNews MVVM+C
//
//  Created by Слава on 22.07.2024.
//

import Foundation
import UIKit

extension String {
    
    func getImage() -> UIImage? {
        var currentImage: UIImage?
        guard let url = URL(string: self) else { return UIImage(named: "") }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) -> Void in
            guard let data = data , error == nil, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { () -> Void in
                currentImage = image
            }
        }).resume()
        return currentImage
    }
    
    
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MM yyyy HH:mm:ss Z"
        return dateFormatter.date(from: self)
    }
    
    func deleteHtmlSymbol() -> String{
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: "&laquo;", with: "«").replacingOccurrences(of: "&raquo;", with: "»").replacingOccurrences(of: "&nbsp;", with: " ").replacingOccurrences(of: "<p>", with: "\n").replacingOccurrences(of: "</p>", with: "\n").replacingOccurrences(of: "&mdash;", with: " — ").replacingOccurrences(of: "&ndash;", with: " — ").replacingOccurrences(of: "&lt;", with: "<").replacingOccurrences(of: "&gt;", with: ">").replacingOccurrences(of: "&hellip;", with: "...").replacingOccurrences(of: "&euro;", with: "€").replacingOccurrences(of: "//", with: ".").replacingOccurrences(of: "&#34;", with: "'")
    }
}

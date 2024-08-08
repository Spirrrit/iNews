//
//  Data + Ext.swift
//  iNews MVVM+C
//
//  Created by Слава on 24.07.2024.
//

import Foundation
import UIKit

extension Data? {
    func getImageFromData() -> UIImage? { 
        guard let data = self else { return nil }
        return UIImage(data: data)
    }
}






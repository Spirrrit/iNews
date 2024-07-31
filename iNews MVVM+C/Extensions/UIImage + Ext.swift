//
//  UIImage + Ext.swift
//  iNews MVVM+C
//
//  Created by Слава on 31.07.2024.
//

import Foundation
import UIKit

extension UIImage {
    func cropped(to size: CGSize) -> UIImage? {
        let originalWidth = self.size.width
        let originalHeight = self.size.height
        
        // Вычисляем масштаб
        let widthRatio  = size.width / originalWidth
        let heightRatio = size.height / originalHeight
        
        // Находим минимальный масштаб, чтобы сохранить пропорции
        let scale = min(widthRatio, heightRatio)
        
        // Вычисляем размеры обрезанного изображения
        let newWidth  = originalWidth * scale
        let newHeight = originalHeight * scale
        
        // Вычисляем точки начала обрезки
        let xOffset = (newWidth - size.width) / 2
        let yOffset = (newHeight - size.height) / 2
        
        // Создаем графический контекст для рисования
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        
        // Рисуем обрезанное изображение
        self.draw(in: CGRect(x: -xOffset, y: -yOffset, width: newWidth, height: newHeight))
        
        // Получаем обрезанное изображение
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return croppedImage
    }
}

//// Пример использования:
//if let originalImage = UIImage(named: "your_image_name") {
//    let targetSize = CGSize(width: 300, height: 300)
//    if let croppedImage = originalImage.cropped(to: targetSize) {
//        // Используйте croppedImage по вашему усмотрению
//    }
//}

//
//  DetailsModel.swift
//  iNews MVVM+C
//
//  Created by Слава on 21.07.2024.
//

import Foundation
import UIKit

class DetailsModel {
    
    let title: String
    let description: String
    let pubData: Date
    let image: ImageRecord
    let source: String
    let link: String
    
    init(news: MainCellModel) {
        self.title = news.title
        self.description = news.description
        self.pubData = news.pubData
        self.image = news.image
        self.source = news.source
        self.link = news.link
    }
    
}

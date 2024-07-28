//
//  DetailsModel.swift
//  iNews MVVM+C
//
//  Created by Слава on 21.07.2024.
//

import Foundation
import UIKit

class DetailsModel {
    
    var title: String
    var description: String
    var pubData: Date
    var image: UIImage?
    var source: String
    var link: String
    
    init(news: MainCellViewModel) {
        self.title = news.title
        self.description = news.description
        self.pubData = news.pubData
        self.image = news.image
        self.source = news.source
        self.link = news.link
    }
    
}

//
//  MainCellViewModel.swift
//  iNews MVVM+C
//
//  Created by Слава on 22.07.2024.
//

import Foundation
import UIKit

class MainCellViewModel {
    
    var title: String
    var description: String
    var pubData: Date
    var image: UIImage?
    var source: String
    var link: String
    
    init(_ news: NewCoreData){
        self.title = news.rssTitle ?? ""
        self.description = news.rssDescription ?? ""
        self.pubData = news.rssPubDate ?? Date()
        self.image = news.rssImage.getImageFromData() ?? UIImage(named: "emptyPhoto")
        self.source = news.rssSource ?? ""
        self.link = news.rssLink ?? ""
    }
}

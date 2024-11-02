//
//  MainCellModel.swift
//  iNews MVVM+C
//
//  Created by Слава on 22.07.2024.
//

import Foundation
import UIKit

struct MainCellModel {
    
    let title: String
    let description: String
    let pubData: Date
    let image: ImageRecord
    let source: String
    let link: String
    
    init(_ news: NewCoreData){
        self.title = news.rssTitle ?? ""
        self.description = news.rssDescription ?? ""
        self.pubData = news.rssPubDate ?? Date()
        self.image = ImageRecord(str: news.rssImage ?? "")
        self.source = news.rssSource ?? ""
        self.link = news.rssLink ?? ""
    }
}

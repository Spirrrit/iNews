//
//  URLs URLResources.swift
//  iNews MVVM+C
//
//  Created by Слава on 22.07.2024.
//

import Foundation

struct URLResources {
    var rssItem: [String : String]
    
    enum NewsResours: String {
        case rbk = "РБК"
        case rambler = "Рамблер"
        case mk = "Московский комсомолец"
        case komersant = "Комерсант"
        case ria = "Риа Новости"
    }
    
}

extension URLResources {
    // Вычисляемое свойство создает словарь состоящий из:  URL ресурса(URL Type) и название ресурса(String Type)
    var news: [URL : String] {
        
        var currentUrls = [URL : String]()
        
        for urls in rssItem {
            let url = URL(string: urls.key)
            guard let url = url else {
                preconditionFailure("Involid URL")
            }
            currentUrls.updateValue(urls.value, forKey: url)
        }
        return currentUrls
    }

}
extension URLResources {
    //Вычисляемое свойство создает словарь(rssItem Type) из ссылок на RSS ресурс (String Type) и название ресурса(String Type)
    static var newsSource: Self {
        URLResources(rssItem: [
            "https://rssexport.rbc.ru/rbcnews/news/30/full.rss" : URLResources.NewsResours.rbk.rawValue ,
//            "https://news.rambler.ru/rss/world/" : URLResources.NewsResours.rambler.rawValue ,
//            "https://www.mk.ru/rss/index.xml" : URLResources.NewsResours.mk.rawValue ,
//            "https://www.kommersant.ru/RSS/news.xml" : URLResources.NewsResours.komersant.rawValue ,
//            "https://ria.ru/export/rss2/archive/index.xml" : URLResources.NewsResours.ria.rawValue ,
        ])
    }
}

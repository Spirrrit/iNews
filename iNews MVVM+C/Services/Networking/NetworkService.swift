//
//  NetworkFetchData.swift
//  iNews MVVM+C
//
//  Created by Слава on 21.07.2024.
//

import Foundation

final class NetworkService {
    
    var xmlParser: NetworkXMLParser
    
    init(xmlParser: NetworkXMLParser) {
        self.xmlParser = xmlParser
    }
    
    func fetchNews(completionHandler: @escaping (([New]?, NetworkError?) -> Void)){
        xmlParser.parserCompletionHandler = completionHandler
        
        NetworkRequest.shared.getData(urls: URLResources.newsSource) { result, source   in
            switch result {
            case .success(let data):
                let parser = XMLParser(data: data)
                parser.delegate = self.xmlParser
                self.xmlParser.currentResource = source
                parser.parse()
            case .failure(_):
                completionHandler(nil, .canNotParse)
            }
        }
    }
    
}


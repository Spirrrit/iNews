//
//  ServicesData.swift
//  iNews MVVM+C
//
//  Created by Слава on 21.07.2024.
//

import Foundation

//Сервис по работе с сетью и базой данных

struct AppDependency : NetworkServicesProtocol, CoreDataServiceProtocol {
    var networkService: NetworkService
    var coreDataService: CoreDataService
}



//final class ServicesData:  {
//
//    var xmlParser: NetworkXMLParser
//    
//    init(xmlParser: NetworkXMLParser) {
//        self.xmlParser = xmlParser
//    }
//    
//    
//    func fetchNews(completionHandler: @escaping (([New]?, NetworkError?) -> Void)) {
//        
//        xmlParser.parserCompletionHandler = completionHandler
//        
//        NetworkRequest.shared.getData(urls: URLResources.newsSource) { result, source   in
//            switch result {
//            case .success(let data):
//                let parser = XMLParser(data: data)
//                parser.delegate = self.xmlParser
//                self.xmlParser.currentResource = source
//                parser.parse()
//            case .failure(_):
//                completionHandler(nil, .canNotParse)
//            }
//        }
//    }
//
//    var networkService: NetworkService
//    
//    init(networkService: NetworkService) {
//        self.networkService = networkService
//    }
//    
//    //MARK: - Get data and save in DB
//    //Функция делает запрос и сохраняет уникальные объекты в базу данных
//    
//    func loadNewData() {
//        networkService.fetchNews(completionHandler: { [weak self] news, error in
//            guard self != nil else { return }
//            if let news {
//                news.forEach {
//                    CoreDataService.shared.createItem(title: $0.title, description: $0.description, pubDate: $0.pubData , imageUrl: $0.image, source: $0.source, link: $0.link)
//                }
//            }
//        })
//    }
//    
//    //MARK: - READ
//    //Функция делает запрос в БД и возвращает все объекты
//    func getData() -> [NewCoreData] {
//        return CoreDataService.shared.fetchAllItems()
//    }
//    
//    //MARK: - UPDATE
//    
//    func updateData() {
//        print("Update data in the network")
//    }
//
//    //MARK: - DELETE
//    //Функция удаляет все объекты из БД
//    func removeData() {
//        CoreDataService.shared.removeAllItems()
//        print("Delete")
//    }
//
//    
//}





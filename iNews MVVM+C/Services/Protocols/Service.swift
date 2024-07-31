//
//  Service.swift
//  iNews MVVM+C
//
//  Created by Слава on 22.07.2024.
//

import Foundation

protocol NetworkServicesProtocol {
//    func fetchNews(completionHandler: @escaping (([New]?, NetworkError?) -> Void))
    var networkService: NetworkService { get }
}

protocol CoreDataServiceProtocol {
//    func createItem(title: String, description: String, pubDate: Date, imageUrl: String, source: String, link: String)
//    func fetchAllItems() -> [NewCoreData]
//    func removeAllItems()
    var coreDataService: CoreDataService { get }
}







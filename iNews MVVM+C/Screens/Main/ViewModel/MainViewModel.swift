//
//  MainViewModel.swift
//  iNews MVVM+C
//
//  Created by Слава on 21.07.2024.
//

import Foundation

class MainViewModel {
    weak var appCordinator : AppCoordinator?
    
    typealias Dependency = NetworkServicesProtocol 

    var networkService: NetworkService
    var coreDataService: CoreDataService
    
    var cellDataSource: Observable<[MainCellViewModel]> = Observable(nil)
    var countLoadNews: Observable<Int> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(false)
    
    var dataSource = [NewCoreData]()


    init(conteiner: Services) {
        self.networkService = conteiner.networkService
        self.coreDataService = conteiner.coreDataService
    }
    
    
    
    func loading() {
        
        isLoading.value = true
        countLoadNews.value = 0
        dataSource = coreDataService.fetchAllItems()
        
        self.networkService.fetchNews { [weak self] news, error in
            guard self != nil else { return }
            if let news {
                
                news.forEach {
                    self?.coreDataService.createItem(title: $0.title, description: $0.description, pubDate: $0.pubData , imageUrl: $0.image, source: $0.source, link: $0.link)
                }
                
                self?.countNews()
                
                if self?.countLoadNews.value == 1 {
                    self?.dataSource = self?.coreDataService.fetchAllItems() ?? []
                    self?.mapCellData()
                }
                
                if self?.countLoadNews.value == URLResources.newsSource.rssItem.count {
                    self?.dataSource = self?.coreDataService.fetchAllItems() ?? []
                    self?.mapCellData()
                    self?.isLoading.value = false
                }
                
            }
        }
        
        
    }
    
    func updating(){
        
        countLoadNews.value = 0
        
        self.networkService.fetchNews { [weak self] news, error in
            guard self != nil else { return }
            if let news {

                    news.forEach {
                        self?.coreDataService.createItem(title: $0.title, description: $0.description, pubDate: $0.pubData , imageUrl: $0.image, source: $0.source, link: $0.link)
                        
                    }
                
                self?.countNews()
    
                if self?.countLoadNews.value == URLResources.newsSource.rssItem.count {
                    self?.dataSource = self?.coreDataService.fetchAllItems() ?? []
                    self?.mapCellData()
                }
                
            }
        }
        
    }
    
    func updateNews(){
        let isConnect = NetworkConnection.isInternetAvailable()
        isConnect ?  updating() : loading()
    }
    
    func deleteAllNews(){
        coreDataService.removeAllItems()
        dataSource = coreDataService.fetchAllItems()
        mapCellData()
    }
    
    func countNews(){
        countLoadNews.value? += 1
    }
    
    func mapCellData(){
        cellDataSource.value = dataSource.compactMap({ MainCellViewModel($0) })
    }
    
    //MARK: - User action and alerts
    
    func noInternetConnection(){
        let isConnect = NetworkConnection.isInternetAvailable()
        if !isConnect {
            appCordinator?.showInternetConnectionAlert()
        }
    }
    
    func userDidPressClearCashes(){
        appCordinator?.userDidPressClearCashes()
    }
    
    func goToDetailsScreen(item: MainCellViewModel) {
        
        appCordinator?.goToDetailsScreen(item: item)
    }
    
}

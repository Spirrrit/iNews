//
//  MainViewModel.swift
//  iNews MVVM+C
//
//  Created by Слава on 21.07.2024.
//

import Foundation

class MainViewModel {
    weak var appCordinator : AppCoordinator?
    
    let services = Services()
    
    var cellDataSource: Observable<[MainCellModel]> = Observable(nil)
    var countLoadNews: Observable<Int> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(false)
    
    var dataSource = [NewCoreData]()
    var imageDataSource = [ImageRecord]()
    
    
    //MARK: - Load and Delete
    func loading() {
        
        isLoading.value = true
        countLoadNews.value = 0
        dataSource = services.coreDataService.fetchAllItems()
        
        if !NetworkConnection.isInternetAvailable() {
            mapCellData()
        }
        
        self.services.networkService.fetchNews { [weak self] news, error in
            guard self != nil else { return }
            if let error {
                print(error.localizedDescription)
            }
            if let news {
                news.forEach {
                    self?.services.coreDataService.createItem(title: $0.title, description: $0.description, pubDate: $0.pubData , imageUrl: $0.image, source: $0.source, link: $0.link)
                }
                self?.countNews()
                
                if self?.countLoadNews.value == URLResources.newsSource.rssItem.count {
                    self?.dataSource = self?.services.coreDataService.fetchAllItems() ?? []
                    self?.dataSource.sort(by: { $0.rssPubDate ?? Date() > $1.rssPubDate ?? Date() })
                    self?.mapCellData()
                    self?.isLoading.value = false
                }
            }
            
        }
    }
    
    func deleteAllNews(){
        services.coreDataService.removeAllItems()
        dataSource = services.coreDataService.fetchAllItems()
        mapCellData()
    }
    
    //MARK: - Support func
    func countNews(){
        countLoadNews.value? += 1
    }
    
    func mapCellData(){
        cellDataSource.value = dataSource.compactMap({ MainCellModel($0) })
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
    
    func goToDetailsScreen(item: MainCellModel) {
        
        appCordinator?.goToDetailsScreen(item: item)
    }
    
    
}

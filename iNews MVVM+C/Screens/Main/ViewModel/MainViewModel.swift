//
//  MainViewModel.swift
//  iNews MVVM+C
//
//  Created by Слава on 21.07.2024.
//

import Foundation

class MainViewModel {
    weak var appCordinator : AppCoordinator?
    
    typealias Dependency = NetworkServicesProtocol & CoreDataServiceProtocol

    var networkService: NetworkService
    var coreDataService: CoreDataService
    
    var cellDataSource: Observable<[MainCellViewModel]> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(false)
    
    var dataSource = [NewCoreData]()


    init(conteiner: AppDependency) {
        self.networkService = conteiner.networkService
        self.coreDataService = conteiner.coreDataService
    }
    

    
    func loadNews() {
        isLoading.value = false
        networkService.fetchNews { [weak self] news, error in
            guard self != nil else { return }
            if let news {
                news.forEach {
                    CoreDataService.shared.createItem(title: $0.title, description: $0.description, pubDate: $0.pubData , imageUrl: $0.image, source: $0.source, link: $0.link)
                }
                
                self?.dataSource = self?.coreDataService.fetchAllItems() ?? []
                self?.mapCellData()
            }
        }
        
    }

    
    func getAllNews(){
        dataSource = coreDataService.fetchAllItems()
        mapCellData()
    }
    
    func deleteAllNews(){
        coreDataService.removeAllItems()
        dataSource = coreDataService.fetchAllItems()
        mapCellData()
    }
    
    func mapCellData(){
        cellDataSource.value = dataSource.compactMap({ MainCellViewModel($0) })
    }
    
//    func clearCashes(){
//        deleteAllNews()
//        getAllNews()
//        mapCellData()
//    }
    
    //MARK: - User action
    func userDidPressClearCashes(){
        appCordinator?.userDidPressClearCashes()
    }
    
    func goToDetailsScreen(item: MainCellViewModel) {
        
        appCordinator?.goToDetailsScreen(item: item)
    }
    
}

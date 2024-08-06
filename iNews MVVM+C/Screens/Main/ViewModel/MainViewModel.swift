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
    var countLoadNews: Observable<Int> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(false)
    
    var dataSource = [NewCoreData]()


    init(conteiner: AppDependency) {
        self.networkService = conteiner.networkService
        self.coreDataService = conteiner.coreDataService
    }
    
    
    
    func loadNews() {
        let queue = OperationQueue()
        
        isLoading.value = true
        countLoadNews.value = 0
        queue.cancelAllOperations()
        
        let loadOperation = BlockOperation {
            self.networkService.fetchNews { [weak self] news, error in
                guard self != nil else { return }
                if let news {
                    news.forEach {
                        CoreDataService.shared.createItem(title: $0.title, description: $0.description, pubDate: $0.pubData , imageUrl: $0.image, source: $0.source, link: $0.link)
                    }
                    self?.dataSource = self?.coreDataService.fetchAllItems() ?? []
                    self?.mapCellData()
                    self?.countNews()
                } else {
                    self?.getAllNews()
                }
            }
        }
        queue.addOperation(loadOperation)
        
    }

    
    func getAllNews(){
        isLoading.value = true
        dataSource = coreDataService.fetchAllItems()
        mapCellData()
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2){
            self.isLoading.value = false
        }
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
    
//    func clearCashes(){
//        deleteAllNews()
//        getAllNews()
//        mapCellData()
//        
//    }
    
    //MARK: - User action
    func userDidPressClearCashes(){
        appCordinator?.userDidPressClearCashes()
    }
    
    func goToDetailsScreen(item: MainCellViewModel) {
        
        appCordinator?.goToDetailsScreen(item: item)
    }
    
}

//
//  DetailsViewModel.swift
//  iNews MVVM+C
//
//  Created by Слава on 21.07.2024.
//

import Foundation
import UIKit

class DetailsViewModel {
    
    weak var appCordinator : AppCoordinator?
    typealias Dependency =  CoreDataServiceProtocol
    let coreDataService: CoreDataService

    init(conteiner: Services) {
        self.coreDataService = conteiner.coreDataService
    }

//MARK: - User Action
    func userDidPressGoToBrowser(link: String){
        appCordinator?.userDidPressGoToBrowser(link: link)
    }
    func userDidPressShare(link: String){
        appCordinator?.userDidPressShare(link: link)
    }
    
}

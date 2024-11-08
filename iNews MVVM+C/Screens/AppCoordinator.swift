//
//  AppCoordinator.swift
//  iNews MVVM+C
//
//  Created by Слава on 21.07.2024.
//

import UIKit

protocol Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}

class AppCoordinator : Coordinator {
    
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToMainScreen()
    }
    
    //MARK: - Go to main screen
    
    func goToMainScreen() {
        
        let mainView = MainView()
        let mainViewModel = MainViewModel()
        mainView.viewModel = mainViewModel
        mainViewModel.appCordinator = self
        
        navigationController.pushViewController(mainView, animated: true)
        
    }
    
    //MARK: - Go to details screen
    
    func goToDetailsScreen(item: MainCellModel) {
        
        let detailViewModel = DetailsViewModel()
        let detailView = DetailsView(detailViewModel: detailViewModel, dataSource: DetailsModel(news: item))
        detailViewModel.appCordinator = self
        navigationController.pushViewController(detailView, animated: true)
    }
    
    //MARK: - User did press button "Go to browser"
    
    func userDidPressGoToBrowser(link: String) {
        let urladdress = link
        if let url = URL(string: urladdress ) {
            print(url)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    //MARK: - User did press button "Share"
    
    func userDidPressShare(link: String) {
        let urladdress = link
        let items: [String] = [urladdress]
        let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        navigationController.present(avc, animated: true)
    }
    
    
    //MARK: - User did press button "Clear cashes"
    
    func userDidPressClearCashes() {
        
        let mainView = MainView()
        let mainViewModel = MainViewModel()
        mainView.viewModel = mainViewModel
        mainViewModel.appCordinator = self
        
        let alert = UIAlertController(title: "Очистка кеша", message: "Действительно хотите очистить кэш?", preferredStyle: .alert)
        let okAtertAction = UIAlertAction(title: "Да", style: .destructive) { action in
            
            mainViewModel.deleteAllNews()

            let resultAlert = UIAlertController(title: "Очистка кеша", message: "Память успешно очищена", preferredStyle: .alert)
            let celcelresultAlert = UIAlertAction(title: "Закрыть", style: .cancel)
            resultAlert.addAction(celcelresultAlert)
            
            self.navigationController.present(resultAlert, animated: true)
        }
        let celcelAtertAction = UIAlertAction(title: "Нет", style: .cancel)
        alert.addAction(okAtertAction)
        alert.addAction(celcelAtertAction)
        
        navigationController.present(alert, animated: true)
    }
    
    //MARK: - Show internet connection alert
    
    func showInternetConnectionAlert(){
        let mainView = MainView()
        let mainViewModel = MainViewModel()
        mainView.viewModel = mainViewModel
        mainViewModel.appCordinator = self
        
        let alert = UIAlertController(title: "Что то пошло не так. Проверьте интернет соединение", message: "", preferredStyle: .alert)
        let celcelAtertAction = UIAlertAction(title: "Закрыть", style: .cancel)
        alert.addAction(celcelAtertAction)
        
        navigationController.present(alert, animated: true)
    }
}

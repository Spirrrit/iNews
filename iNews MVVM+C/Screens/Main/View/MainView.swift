//
//  ViewController.swift
//  iNews MVVM+C
//
//  Created by Слава on 21.07.2024.
//

import UIKit

class MainView: UIViewController {
    
    var viewModel: MainViewModel?
    var tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView()
    var cellDataSource = [MainCellViewModel]()
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupView()
        viewModel?.loadNews()
        viewModel?.getAllNews()
        bindViewModel()

    }

    
    // Binding Model
    
     private func bindViewModel(){
        viewModel?.isLoading.bind { [weak self] isLoading in
            guard let self, let isLoading else { return }
            DispatchQueue.main.async {
                isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            }
        }
        
        viewModel?.cellDataSource.bind { [weak self] news in
            guard let self, let news else { return }
            self.cellDataSource = news
            self.cellDataSource.sort(by: { $0.pubData > $1.pubData  })
            reloadTableView()
        }
        
        
    }
    
    func setupView(){
        view.backgroundColor = .white
        
        title = "Главная"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(remove))
        refreshControl.addTarget(self, action: #selector(endRefresh), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Загрузка...")
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        
        
        

        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            
            
        ])
    }
    
    @objc func remove(){
        viewModel?.userDidPressClearCashes()
    }
    
    @objc func endRefresh(){

        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            
            self.refreshControl.endRefreshing()
        }
    }

}


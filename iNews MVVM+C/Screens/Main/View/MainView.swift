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
    var cellDataSource = [MainCellModel]()
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var imageDataSource = [ImageRecord]()
    let pendingOperations = PendingOperations()
    lazy var cacheDataSource: NSCache<AnyObject, UIImage> = {
        let cache = NSCache<AnyObject, UIImage>()
        return cache
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupView()
        viewModel?.loading()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.noInternetConnection()
    }
    
    //MARK: - Binding
    
    private func bindViewModel(){
        
        // следим за состояние лоадинг и вкл/вкл рефрешь контрол
        viewModel?.isLoading.bind { [weak self] isLoading in
            guard let self, let isLoading else { return }
            DispatchQueue.main.async {
                isLoading ? self.refreshControl.beginRefreshing() : self.refreshControl.endRefreshing()
            }
        }
        
        // следим за появлением новых новостей в modelview
        viewModel?.cellDataSource.bind { [weak self] news in
            guard let self, let news else { return }
            
            self.cellDataSource = news
            self.cellDataSource.sort(by: { $0.pubData > $1.pubData  })
            reloadTableViewBasic()
            
        }
    }
    
    
    //MARK: - Setup View
    
    func setupView(){
        view.backgroundColor = .systemBackground
        
        title = "Главная"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(remove))
        navigationController?.navigationBar.tintColor = .darkGray
        navigationController?.navigationBar.backgroundColor = .systemBackground
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Загрузка...")
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    //MARK: - @Objc funcs
    
    @objc func remove(){
        viewModel?.userDidPressClearCashes()
    }
    
    @objc func refresh(){
        viewModel?.loading()
    }
}


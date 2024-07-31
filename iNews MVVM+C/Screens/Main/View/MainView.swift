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
    var timer: Timer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        setupTableView()
        setupView()
        viewModel?.loadNews()
        viewModel?.getAllNews()
        bindViewModel()
    }

    
    func startTimer() {
        // Создаем таймер, который будет срабатывать каждые 15 секунд
        timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(loadData), userInfo: nil, repeats: true)
    }

    
    // Binding Model
    
    private func bindViewModel(){
        
        viewModel?.isLoading.bind { [weak self] isLoading in
            guard let self, let isLoading else { return }
            DispatchQueue.main.async {
                isLoading ? self.refreshControl.beginRefreshing() : self.refreshControl.endRefreshing()
//                isLoading ? self.activityIndicator.startAnimating() :  self.activityIndicator.stopAnimating()
            }
        }
        
        viewModel?.cellDataSource.bind { [weak self] news in
            guard let self, let news else { return }
            self.cellDataSource = news
            self.cellDataSource.sort(by: { $0.pubData > $1.pubData  })
        }
        
        viewModel?.countLoadNews.bind { [weak self] count in
            guard let self, let count else { return }
            if count == 1 {
                self.reloadTableView()
            }
            
            if count == URLResources.newsSource.rssItem.count {
                viewModel?.isLoading.value = false
                self.reloadTableView()
//                refreshControl.endRefreshing()
            }
        }
    }
    
    func setupView(){
        view.backgroundColor = .systemBackground
        
        title = "Главная"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(remove))
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Загрузка...")
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        
        
        

        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            
            
        ])
    }
    
    @objc func remove(){
        viewModel?.userDidPressClearCashes()
    }
    
    @objc func refresh(){
            self.viewModel?.getAllNews()
        
            
    }
    @objc func loadData(){
        viewModel?.loadNews()
        print("Обновлено")
    }

}


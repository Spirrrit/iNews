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
        bindViewModel()
    }

    //MARK: - Timer
    
    //Timer that asks for updates on the network every 30 seconds
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(updateNews), userInfo: nil, repeats: true)
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
        
        viewModel?.cellDataSource.bind { [weak self] news in
            guard let self, let news else { return }
            
            // Если появились новые элементы и лоадер не крутится, то обновляем таблицу
            if cellDataSource.count < news.count && viewModel?.isLoading.value == false {
                print("Новый элемент")
                reloadTableViewBasic()
            }
           
            self.cellDataSource = news
            self.cellDataSource.sort(by: { $0.pubData > $1.pubData  })
            
            // обновляем таблицу пока лоаддер активен
            if viewModel?.isLoading.value == true {
                reloadTableViewBasic()
            }
        }
    }
    
    //MARK: - Setup View
    
    func setupView(){
        view.backgroundColor = .systemBackground
        
        title = "Главная"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(remove))
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Загрузка...")
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        
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
        
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func updateNews(){
        
        viewModel?.updateNews()
        print("Обновлено с таймером")
        
    }
}


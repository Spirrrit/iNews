//
//  MainView + TableView.swift
//  iNews MVVM+C
//
//  Created by Слава on 22.07.2024.
//

import Foundation
import UIKit

extension MainView: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView(){
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        
        self.tableView.register(MainCell.self, forCellReuseIdentifier: MainCell.identifier)
    }
    
    func reloadTableView(){
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainCell.identifier, for: indexPath) as? MainCell else { return UITableViewCell() }

        let cellViewModel = cellDataSource[indexPath.row]
        cell.title.text = cellViewModel.title
        cell.discription.text = cellViewModel.description
        cell.image.image = UIImage(named: "emptyPhoto")
        cell.date.text = cellViewModel.pubData.toRusString
        cell.source.text = cellViewModel.source
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let customCell = cell as? MainCell else { return }
        let cellViewModel = cellDataSource[indexPath.row]
        
        DispatchQueue.main.async {
            if let cell = tableView.cellForRow(at: indexPath) {
                customCell.image.image = cellViewModel.image
                cell.setNeedsLayout() //
            }
        }
        

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellViewModel = cellDataSource[indexPath.row]
        
        viewModel?.goToDetailsScreen(item: cellViewModel)
    }
    
}


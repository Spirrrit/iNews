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
    func reloadTableViewBasic(){
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
    
    func reloadTableView(newItem: [MainCellViewModel], oldItem: [MainCellViewModel]){

        var resultIndexPath: [IndexPath] = []
        let delta = abs(newItem.count - oldItem.count)
        let indexPath = (0..<delta).map { IndexPath(row: $0, section: 0) }
        
        if newItem.count >= oldItem.count {
            tableView.insertRows(at: indexPath, with: .fade)
            resultIndexPath = makeUpdateIndexes(bigger: newItem, lower: oldItem)
        } else {
            tableView.deleteRows(at: indexPath, with: .fade)
            resultIndexPath = makeUpdateIndexes(bigger: oldItem, lower: newItem)
        }
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: resultIndexPath, with: .fade)
            print("Обновлено")
        }
        
        
    }
    
    func makeUpdateIndexes(bigger: [MainCellViewModel], lower: [MainCellViewModel]) -> [IndexPath] {
        let indexPath = bigger.indices.map { IndexPath(row: $0, section: 0) }
        return indexPath.filter { index in
            guard index.row < lower.count else { return false }
            return bigger[index.row] !== lower[index.row]
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellDataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainCell.identifier, for: indexPath) as? MainCell else { return UITableViewCell() }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let customCell = cell as? MainCell else { return }
        let cellViewModel = cellDataSource[indexPath.row]
        
        customCell.title.text = cellViewModel.title
        customCell.discription.text = cellViewModel.description
        customCell.date.text = cellViewModel.pubData.toRusString
        customCell.source.text = cellViewModel.source
        
        
        DispatchQueue.main.async {
            if let cell = tableView.cellForRow(at: indexPath) {
                    customCell.image.image = cellViewModel.image
                    cell.setNeedsLayout()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellViewModel = cellDataSource[indexPath.row]
        
        viewModel?.goToDetailsScreen(item: cellViewModel)
    }
    
}


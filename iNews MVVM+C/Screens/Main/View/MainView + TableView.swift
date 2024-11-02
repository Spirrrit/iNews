//
//  MainView + TableView.swift
//  iNews MVVM+C
//
//  Created by Слава on 22.07.2024.
//

import Foundation
import UIKit

//MARK: - Setup TableView
extension MainView: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView(){
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        
        self.tableView.register(MainCell.self, forCellReuseIdentifier: MainCell.identifier)
    }
    
    func reloadTableViewBasic(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellDataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainCell.identifier, for: indexPath) as? MainCell else { return UITableViewCell() }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let customCell = cell as? MainCell else { return }
        
        let cellViewModel = cellDataSource[indexPath.row]
        let image = cellDataSource[indexPath.row].image
        
        customCell.title.text = cellViewModel.title
        customCell.discription.text = cellViewModel.description
        customCell.date.text = cellViewModel.pubData.toRusString
        customCell.source.text = cellViewModel.source
        customCell.image.image = image.image
        
        if let image = cacheDataSource.object(forKey: indexPath as AnyObject) {
            customCell.image.image = image
        } else {
            switch (image.state){
            case .Failed:
                break
            case .New, .Downloaded:
                if (!tableView.isDragging && !tableView.isDecelerating) {
                    self.startOperationsForPhotoRecord(photoDetails: image, indexPath: indexPath)
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellViewModel = cellDataSource[indexPath.row]
        
        viewModel?.goToDetailsScreen(item: cellViewModel)
    }
   
}
//MARK: -  Setup Operation
extension MainView {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        suspendAllOperations()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForOnscreenCells()
            resumeAllOperations()
        }
        
    }

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForOnscreenCells()
        resumeAllOperations()
    }
    
    
    
    func startOperationsForPhotoRecord(photoDetails: ImageRecord, indexPath: IndexPath){
        switch (photoDetails.state) {
        case .New:
            startDownloadForRecord(photoDetails: photoDetails, indexPath: indexPath)
        case .Downloaded:
            break
        default:
            break
        }
    }
    
    func startDownloadForRecord(photoDetails: ImageRecord, indexPath: IndexPath){
        
        
        if let _ = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        let downloader = ImageDownloader(photoRecord: photoDetails)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            self.cacheDataSource.setObject((photoDetails.image ?? UIImage(named: "emptyPhoto"))!, forKey: indexPath as AnyObject)
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func suspendAllOperations () {
        pendingOperations.downloadQueue.isSuspended = true
    }
    
    func resumeAllOperations () {
        pendingOperations.downloadQueue.isSuspended = false
    }
    
    func loadImagesForOnscreenCells () {
        
        if let pathsArray = tableView.indexPathsForVisibleRows {
            
            let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
            
            
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray)
            toBeCancelled.subtract(visiblePaths)
            
            
            let toBeStarted = visiblePaths
            toBeCancelled.subtract(allPendingOperations)
            
            
            for indexPath in toBeCancelled {
                if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            }
            
            
            for indexPath in toBeStarted {
                let indexPath = indexPath as NSIndexPath
                let recordToProcess = self.cellDataSource[indexPath.row].image
                startOperationsForPhotoRecord(photoDetails: recordToProcess, indexPath: indexPath as IndexPath)
                
            }
        }
    }
    
    
}


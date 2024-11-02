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
    
    let service = Services()
    
    //MARK: - User Action
    
    func userDidPressGoToBrowser(link: String){
        appCordinator?.userDidPressGoToBrowser(link: link)
    }
    func userDidPressShare(link: String){
        appCordinator?.userDidPressShare(link: link)
    }
    
    //MARK: - DownloadImage
    func downloadImage(url: String, completion: @escaping ((UIImage?) -> Void)) {
        
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url ) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            if let data = data {
                let image = UIImage(data: data)
                completion(image)
            }
            
        }.resume()
        
    }
}

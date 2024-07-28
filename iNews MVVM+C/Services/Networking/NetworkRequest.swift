//
//  NetworkRequest.swift
//  iNews MVVM+C
//
//  Created by Слава on 21.07.2024.
//

import Foundation

extension URLSession {
    typealias Handler = (Data?, URLResponse?, Error?) -> Void
    
    @discardableResult
    func request(_ endPoint: URL, handler: @escaping Handler) -> URLSessionDataTask {
        let task = dataTask(with: endPoint, completionHandler: handler)
        task.resume()
        return task
    }
}


final class NetworkRequest {
    static let shared = NetworkRequest()
    private init() {}
    
    func getData(urls: URLResources,  complitionHandler: @escaping (Result<Data, NetworkError>, _ source: String) -> Void) {
        for url in urls.news {
            
            URLSession.shared.request(url.key) { data, _, error in
                if error != nil {
                    complitionHandler(.failure(.urlError), url.value)
                } else {
                    guard let data else { return }
                    complitionHandler(.success(data), url.value)
                }
            }
        }
    }
    
}

//
//  NetworkFetchData.swift
//  iNews MVVM+C
//
//  Created by Слава on 21.07.2024.
//

import Foundation


final class NetworkService {
    
    let xmlParser = NetworkXMLParser()
    let networkRequest = NetworkRequest()
    
    func fetchNews(completionHandler: @escaping (([New]?, NetworkError?) -> Void)) {
        
        xmlParser.parserCompletionHandler = completionHandler
        NetworkRequest.getData(urls: URLResources.newsSource) { [weak self] result, source   in
            switch result {
            case .success(let data):
                let parser = XMLParser(data: data)
                parser.delegate = self?.xmlParser
                self?.xmlParser.currentResource = source
                parser.parse()
            case .failure(_):
                completionHandler(nil, .canNotParse)
            }
        }
        
    }
    
}

final class NetworkRequest {
    
    static func getData(urls: URLResources,  complitionHandler: @escaping (Result<Data, NetworkError>, _ source: String) -> Void) {
        
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

extension URLSession {
    typealias Handler = (Data?, URLResponse?, Error?) -> Void
    
    @discardableResult
    func request(_ endPoint: URL, handler: @escaping Handler) -> URLSessionDataTask {
        let task = dataTask(with: endPoint, completionHandler: handler)
        task.resume()
        return task
    }
}


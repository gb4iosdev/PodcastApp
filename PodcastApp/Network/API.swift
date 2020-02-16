//
//  API.swift
//  PodcastApp
//
//  Created by Gavin Butler on 09-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

//Data Fetcher that simply fetches asynchronously, determines if result is a success or fail, and passes back according.  Type agnostic – no parsing here.
protocol API {
    var decoder: JSONDecoder { get }
}

extension API {
    
    @discardableResult
    func fetchData(from url: URL, completion: @escaping (Result<Data, APIError>) -> Void) -> URLSessionDataTask {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                completion(.success(data))
            } else if let error = error {
                //Terminate this fetch without calling the completion handler if the error code is related to cancellation:
                if let error = error as NSError?, error.domain == NSURLErrorDomain, error.code == NSURLErrorCancelled {
                    return
                }
                completion(.failure(.networkingError(error)))
            }
        }
        task.resume()
        return task
    }
    
    func parseJSON<T: Decodable>(apiResult: Result<Data, APIError>, completion: @escaping (Result<T, APIError>) -> Void) {
        switch apiResult {
        case .success(let data):
            do {
                let result = try self.decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch let error {
                completion(.failure(.decodingError(error)))
            }
        case .failure(let error):
            completion(.failure(.networkingError(error)))
        }
    }
}

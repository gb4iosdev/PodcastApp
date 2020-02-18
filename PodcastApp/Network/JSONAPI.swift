//
//  JSONAPI.swift
//  PodcastApp
//
//  Created by Gavin Butler on 17-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

protocol JSONAPI: API {
    var decoder: JSONDecoder { get }
}

extension JSONAPI {
    
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

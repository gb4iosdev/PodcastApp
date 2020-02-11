//
//  TopPodcastsAPI.swift
//  PodcastApp
//
//  Created by Gavin Butler on 09-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

class TopPodcastsAPI {
    
    let decoder = JSONDecoder()
    
    func fetchTopPodcasts(limit: Int = 50, completion: @escaping (Result<Response, APIError>) -> Void) {
        
        //Create the endoint:
        guard let endpointURL = PodcastEndpoint.topPodcasts(limit: limit).request.url else { return }
        
        API.request(url: endpointURL) { apiResult in
            switch apiResult {
            case .success(let data):
                do {
                    let result = try self.decoder.decode(Response.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                } catch let error {
                    completion(.failure(.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(.networkingError(error)))
            }
        }
    }
}


extension TopPodcastsAPI {
 
    struct Response: Decodable {
        let feed: Feed
    }

    struct Feed: Decodable {
        let results: [PodcastResult]
    }

    struct PodcastResult: Decodable {
        let id: String
        let artistName: String
        let name: String
        let artworkUrl100: String
        let genres: [Genre]
    }
               
    struct Genre:  Decodable {
        let name: String
        let genreId: String
    }
}

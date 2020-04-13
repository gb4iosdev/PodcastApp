//
//  PodcastSearchAPI.swift
//  PodcastApp
//
//  Created by Gavin Butler on 15-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

class PodcastSearchAPI: JSONAPI {
    
    let decoder = JSONDecoder()
    
    private var activeSearchTask: URLSessionDataTask?   //Supports cancellation due to the changes in search bar text
    
    func search(for term: String, completion: @escaping (Result<Response, APIError>) -> Void) {
        
        //Create the endoint:
        guard let endpointURL = PodcastEndpoint.search(searchTerm: term).request.url else { return }
        
        //Cancel any currently active search task
        activeSearchTask?.cancel()
        
        //Perform the low level call (request) then pass the results to the JSON fetcher
        activeSearchTask = fetchData(from: endpointURL) { result in
            self.parseJSON(apiResult: result, completion: completion)
        }
    }
    
    func lookup(id: String, completion: @escaping (Result<SearchResult?, APIError>) -> Void) {
        
        //Create the endoint:
        guard let endpointURL = PodcastEndpoint.lookup(id: id).request.url else { return }
        
        fetchData(from: endpointURL) { result in
            self.parseJSON (apiResult: result) { (result: Result<Response, APIError>) in
                switch result {
                case .success(let response):
                    let result = response.results.first.flatMap(SearchResult.init)
                    completion(.success(result))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

extension PodcastSearchAPI {
    
    struct Response: Decodable {
        let resultCount: Int
        let results: [PodcastSearchResult]
    }

    struct PodcastSearchResult: Decodable {
        let artistName: String
        let collectionId: Int       //This is the pdocast ID
        let collectionName: String
        let artworkUrl100: String
        let genreIds: [String]
        let genres: [String]
        let feedUrl: String
    }
}

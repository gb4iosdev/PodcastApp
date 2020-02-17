//
//  PodcastSearchAPI.swift
//  PodcastApp
//
//  Created by Gavin Butler on 15-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

class PodcastSearchAPI: API {
    
    let decoder = JSONDecoder()
    
    private var activeSearchTask: URLSessionDataTask?
    
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
}

extension PodcastSearchAPI {
    
    struct Response: Decodable {
        let resultCount: Int
        let results: [PodcastSearchResult]
    }

    struct PodcastSearchResult: Decodable {
        let artistName: String
        let collectionName: String
        let artworkUrl100: String
        let genreIds: [String]
        let genres: [String]
    }
}
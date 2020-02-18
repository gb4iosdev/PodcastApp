//
//  TopPodcastsAPI.swift
//  PodcastApp
//
//  Created by Gavin Butler on 09-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

class TopPodcastsAPI: JSONAPI {
    
    var decoder = JSONDecoder()
    
    func fetchTopPodcasts(limit: Int = 50, completion: @escaping (Result<Response, APIError>) -> Void) {
        
        //Create the endoint:
        guard let endpointURL = PodcastEndpoint.topPodcasts(limit: limit).request.url else { return }
        
        //Perform the low level call (request) then pass the results to the JSON fetcher
        fetchData(from: endpointURL) { result in
            self.parseJSON(apiResult: result, completion: completion)
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

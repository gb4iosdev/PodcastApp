//
//  TopPodcastsAPI.swift
//  PodcastApp
//
//  Created by Gavin Butler on 09-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

class TopPodcastsAPI {
    
    func fetchTopPodcasts(limit: Int = 50, completion: @escaping (Result<Data, Error>) -> Void) {
        
        //Create the endoint:
        guard let endpointURL = PodcastEndpoint.topPodcasts(limit: limit).request.url?.absoluteString else { return }
        
        API.request(url: endpointURL,completion: completion)
    }
}

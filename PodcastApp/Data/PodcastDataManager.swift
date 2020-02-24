//
//  PodcastDataManager.swift
//  PodcastApp
//
//  Created by Gavin Butler on 23-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

class PodcastDataManager {
    
    private let recommendedPodcastsClient = TopPodcastsAPI()
    
    func recommendedPodcasts(completion: @escaping (Result<[SearchResult], PodcastLoadingError>) -> Void) {
        
        recommendedPodcastsClient.fetchTopPodcasts(limit: <#T##Int#>, completion: <#T##(Result<TopPodcastsAPI.Response, APIError>) -> Void#>)
    }
}

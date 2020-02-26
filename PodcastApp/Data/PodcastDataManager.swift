//
//  PodcastDataManager.swift
//  PodcastApp
//
//  Created by Gavin Butler on 23-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

class PodCastDataManager {
 
    private let topPodcastsAPI = TopPodcastsAPI()
    private let searchClient = PodcastSearchAPI()

    func recommendedPodcasts(completion: @escaping (Result<[SearchResult], PodcastLoadingError>) -> Void) {
        topPodcastsAPI.fetchTopPodcasts(limit: 50) { result in
            switch result {
                case .success(let response):
                    let searchResults = response.feed.results.map(SearchResult.init)
                    completion(.success(searchResults))
                case .failure(let error):
                    completion(.failure(PodcastLoadingError.convert(from: error)))
            }
        }
    }
    
    func search(for term: String, completion: @escaping (Result<[SearchResult], PodcastLoadingError>) -> Void) {
        searchClient.search(for: term) { result in
            switch result {
            case .success(let response):
                let searchResults = response.results.map(SearchResult.init)
                completion(.success(searchResults))
            case .failure(let error):
                completion(.failure(PodcastLoadingError.convert(from: error)))
            }
        }
    }
    
    func lookup(podcastID: String, completion: @escaping (Result<SearchResult?, APIError>) -> Void) {
        searchClient.lookup(id: podcastID) { result in
            completion(result)
        }
    }
}

//
//  SearchResult.swift
//  PodcastApp
//
//  Created by Gavin Butler on 03-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

class SearchResult {
    
    var id: String
    var title: String
    var author: String
    var artworkUrl: URL?
    var feedURL: URL?
    
    init(id: String, artworkUrl: URL?, title: String, author: String, feedURL: URL?) {
        self.id = id
        self.artworkUrl = artworkUrl
        self.title = title
        self.author = author
        self.feedURL = feedURL
    }
}

extension SearchResult {
    convenience init(podcastResult: TopPodcastsAPI.PodcastResult) {
        self.init(
            id: podcastResult.id,
            artworkUrl: URL(string: podcastResult.artworkUrl100),
            title: podcastResult.name,
            author: podcastResult.artistName,
            feedURL: nil)
    }
    
    convenience init(searchResult: PodcastSearchAPI.PodcastSearchResult) {
        self.init(
            id: String(searchResult.collectionId),
            artworkUrl: URL(string: searchResult.artworkUrl100),
            title: searchResult.collectionName,
            author: searchResult.artistName,
            feedURL: URL(string: searchResult.feedUrl))
    }
}

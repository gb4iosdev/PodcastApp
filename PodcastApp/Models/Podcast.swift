//
//  Podcast.swift
//  PodcastApp
//
//  Created by Gavin Butler on 16-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

class Podcast {
    var id: String
    var feedURL: URL
    var title: String?
    var author: String?
    var description: String?
    var primaryGenre: String?
    var artworkURL: URL?
    var episodes: [Episode] = []
    
    init(id: String, feedURL: URL) {
        self.id = id
        self.feedURL = feedURL
    }
    
    init(from entity: PodcastEntity) {
        id = entity.id!
        feedURL = URL(string: entity.feedURLString!)!
        title = entity.title
        author = entity.author
        description = entity.podcastDescription
        primaryGenre = entity.genre
        artworkURL = entity.artworkURL
    }
}

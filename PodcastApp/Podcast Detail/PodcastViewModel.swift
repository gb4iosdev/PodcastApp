//
//  PodcastViewModel.swift
//  PodcastApp
//
//  Created by Gavin Butler on 08-03-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

struct PodcastViewModel {
    private let podcast: Podcast
    let isSubscribed: Bool
    
    init(podcast: Podcast, isSubscribed: Bool) {
        self.podcast = podcast
        self.isSubscribed = isSubscribed
    }
    
    var title: String? {
        return podcast.title
    }
    
    var author: String? {
        return podcast.author
    }
    
    var genre: String? {
        return podcast.primaryGenre
    }
    
    var description: String? {
        return podcast.description?
        .strippingHTML()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var artworkURL: URL? {
        return podcast.artworkURL
    }
    
    var episodes: [EpisodeCellViewModel] {
        return podcast.episodes.map(EpisodeCellViewModel.init)
    }
}

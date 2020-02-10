//
//  SearchResult.swift
//  PodcastApp
//
//  Created by Gavin Butler on 03-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

class SearchResult {
    
    let title: String
    let author: String
    let artworkUrl: URL?
    
    init(artworkUrl: URL?, title: String, author: String) {
        self.artworkUrl = artworkUrl
        self.title = title
        self.author = author
    }
    
}

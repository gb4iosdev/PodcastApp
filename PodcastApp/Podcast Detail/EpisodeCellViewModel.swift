//
//  EpisodeCellViewModel.swift
//  PodcastApp
//
//  Created by Gavin Butler on 06-03-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

struct EpisodeCellViewModel {
    
    private let episode: Episode
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    init(episode: Episode) {
        
        self.episode = episode
    }
    
    var title: String {
        return episode.title ?? "<Untitled>"
    }
    
    var description: String? {
        return episode.description
    }
    
    var info: String {
        let parts = [timeString, dateString].compactMap { $0 }
        return parts.joined(separator: " • ")
    }
    
    private var timeString: String? {
        return "000"
    }
    
    private var dateString: String? {
        return "xxxxx"
    }
}

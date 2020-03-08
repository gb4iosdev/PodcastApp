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
    
    private static let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter
    }()
    
    init(episode: Episode) {
        self.episode = episode
    }
    
    var title: String {
        return episode.title ?? "<Untitled>"
    }
    
    var description: String? {
        return episode.description?
            .strippingHTML()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var info: String {
        let parts = [timeString, dateString].compactMap { $0 }
        return parts.joined(separator: " • ")
    }
    
    private var timeString: String? {
        guard let duration = episode.duration else { return nil }
        return EpisodeCellViewModel.timeFormatter.string(from: duration)
    }
    
    private var dateString: String? {
        guard let publicationDate = episode.publicationDate else { return nil }
        return EpisodeCellViewModel.dateFormatter.string(from: publicationDate)
    }
}

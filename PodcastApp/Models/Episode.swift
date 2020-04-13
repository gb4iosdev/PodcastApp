//
//  Episode.swift
//  PodcastApp
//
//  Created by Gavin Butler on 06-03-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

class Episode {
    var identifier: String?
    var title: String?
    var description: String?
    var publicationDate: Date?
    var duration: TimeInterval?
    var enclosureURL: URL?  //URL to the .mp3 sound file to download & play
}

//
//  EpisodeStatusEntity+CoreDataProperties.swift
//  PodcastApp
//
//  Created by Gavin Butler on 20-04-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//
//

import Foundation
import CoreData


extension EpisodeStatusEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EpisodeStatusEntity> {
        return NSFetchRequest<EpisodeStatusEntity>(entityName: "EpisodeStatus")
    }

    @NSManaged public var lastPlayedAt: Date?
    @NSManaged public var lastListenTime: Double
    @NSManaged public var hasCompleted: Bool
    @NSManaged public var isCurrentlyPlaying: Bool
    @NSManaged public var episode: EpisodeEntity?

}

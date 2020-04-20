//
//  EpisodeEntity+CoreDataProperties.swift
//  PodcastApp
//
//  Created by Gavin Butler on 14-04-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//
//

import Foundation
import CoreData


extension EpisodeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EpisodeEntity> {
        return NSFetchRequest<EpisodeEntity>(entityName: "Episode")
    }

    @NSManaged public var identifier: String
    @NSManaged public var duration: Double
    @NSManaged public var enclosureURL: URL
    @NSManaged public var episodeDescription: String
    @NSManaged public var publicationDate: Date
    @NSManaged public var title: String
    @NSManaged public var podcast: PodcastEntity
    @NSManaged public var status: EpisodeStatusEntity?
}

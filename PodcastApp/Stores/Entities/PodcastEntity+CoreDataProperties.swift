//
//  PodcastEntity+CoreDataProperties.swift
//  
//
//  Created by Gavin Butler on 08-03-2020.
//
//

import Foundation
import CoreData


extension PodcastEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PodcastEntity> {
        return NSFetchRequest<PodcastEntity>(entityName: "Podcast")
    }

    @NSManaged public var id: String?
    @NSManaged public var feedURLString: String?
    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var genre: String?
    @NSManaged public var podcastDescription: String?
    @NSManaged public var artworkURLString: String?
    @NSManaged public var subscription: SubscriptionEntity?

}

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
    @NSManaged public var episodes: [EpisodeEntity]?
    
    var artworkURL: URL? {
        return artworkURLString.flatMap(URL.init)
    }

}

extension PodcastEntity: PodcastCellModel {
    var titleText: String? {
        return title
    }
    
    var authorText: String? {
        return author
    }
    

    var artwork: URL? {
        return artworkURL
    }
    
    var lookupInfo: PodcastLookupInfo? {
        guard let id = id else { return nil }
        guard let feedURL = feedURLString.flatMap(URL.init) else { return nil }
        return PodcastLookupInfo(id: id, feedURL: feedURL)
    }    
}

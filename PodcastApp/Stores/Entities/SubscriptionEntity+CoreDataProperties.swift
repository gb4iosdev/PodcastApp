//
//  SubscriptionEntity+CoreDataProperties.swift
//  
//
//  Created by Gavin Butler on 08-03-2020.
//
//

import Foundation
import CoreData


extension SubscriptionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubscriptionEntity> {
        return NSFetchRequest<SubscriptionEntity>(entityName: "Subscription")
    }

    @NSManaged public var dateSubscribed: Date?
    @NSManaged public var podcast: PodcastEntity?

}

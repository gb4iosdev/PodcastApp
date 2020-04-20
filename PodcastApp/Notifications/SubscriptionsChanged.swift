//
//  SubscriptionsChanged.swift
//  PodcastApp
//
//  Created by Gavin Butler on 14-04-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

struct SubscriptionsChanged: TypedNotification {
    
    var sender: Any?
    
    static var name: String = "SubscriptionsChangedNotification"
    
    let subscribedIds: Set<String>
    let unsubscribedIds: Set<String>
    
    init(subscribed: Set<String>) {
        subscribedIds = subscribed
        unsubscribedIds = []
    }
    
    init(unsubscribed: Set<String>) {
        subscribedIds = []
        unsubscribedIds = unsubscribed
    }
}

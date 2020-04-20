//
//  FeedImporter.swift
//  PodcastApp
//
//  Created by Gavin Butler on 16-04-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

/*///
class FeedImporter {
    static let shared = FeedImporter()
    
    private var notificationObserver: NSObjectProtocol?
    private var importQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        queue.qualityOfService = .userInitiated
        return queue
    }()
    
    func startListening() {
        notificationObserver = NotificationCenter.default.addObserver(SubscriptionsChanged.self, sender: nil, queue: nil) { notification in
            notification.subscribedIds.forEach(self.onSubscribe)
            notification.unsubscribedIds.forEach(self.onUnsubscribe)
        }
    }
    
    private func onSubscribe(podcastId: String) {
        let operation = ImportEpisodesOperation(podcastId: podcastId)
        importQueue.addOperation(operation)
    }
    
    private func onUnsubscribe(podcastId: String) {
        
    }

}*/

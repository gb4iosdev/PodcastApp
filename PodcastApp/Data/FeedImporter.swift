//
//  FeedImporter.swift
//  PodcastApp
//
//  Created by Gavin Butler on 16-04-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

class FeedImporter {
    static let shared = FeedImporter()
    
    private var notificationObserver: NSObjectProtocol?
    private var priorityQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        queue.qualityOfService = .userInitiated
        return queue
    }()
    
    private var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        queue.qualityOfService = .background
        return queue
    }()
    
    func startListening() {
        notificationObserver = NotificationCenter.default.addObserver(SubscriptionsChanged.self, sender: nil, queue: nil) { notification in
            notification.subscribedIds.forEach(self.onSubscribe)
            notification.unsubscribedIds.forEach(self.onUnsubscribe)
        }
    }
    
    func updatePodcasts() {
        backgroundQueue.addOperation {
            let context = PersistenceManager.shared.newBackgroundContext()
            let subscriptionStore = SubscriptionStore(with: context)
            do {
                let subs = try subscriptionStore.fetchSubscriptions()
                for sub in subs {
                    guard let podcast = sub.podcast, let id = podcast.id else { continue }
                    print("Queueing operation to update subscribed podcast: \(podcast.title ?? "<?>") ")
                    let updateOperation = ImportEpisodesOperation(podcastId: id)
                    self.backgroundQueue.addOperation(updateOperation)
                }
            } catch {
                print("Error fetching subscriptions for background update: \(error.localizedDescription)")
            }
        }
    }
    
    private func onSubscribe(podcastId: String) {
        let operation = ImportEpisodesOperation(podcastId: podcastId)
        priorityQueue.addOperation(operation)
    }
    
    private func onUnsubscribe(podcastId: String) {
        
    }

}

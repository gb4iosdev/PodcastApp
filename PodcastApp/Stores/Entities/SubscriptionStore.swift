//
//  SubscriptionStore.swift
//  PodcastApp
//
//  Created by Gavin Butler on 08-03-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation
import CoreData

class SubscriptionStore {
    
    static var shared = SubscriptionStore()
    
    private let persistentContainer: NSPersistentContainer
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Subscriptions")
    }
    
    func initializeModel() {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Core Data Error: \(error.localizedDescription)")
            } else {
                print("Loaded Store: \(storeDescription.url?.absoluteString ?? "nil")")
            }
        }
    }
    
    func isSubscribed(to id: String) -> Bool {
        do {
            return try findSubscription(with: id) != nil
        } catch {
            return false
        }
    }
    
    func findSubscription(with podcastId: String) throws -> SubscriptionEntity? {
        let fetch: NSFetchRequest<SubscriptionEntity> = SubscriptionEntity.fetchRequest()
        fetch.fetchLimit = 1
        fetch.predicate = NSPredicate(format: "podcast.id == %@", podcastId)
        
        return try mainContext.fetch(fetch).first
    }
    
    @discardableResult
    func subscribe(to podcast: Podcast) throws -> SubscriptionEntity {
        let podcastEntity = PodcastEntity(context: mainContext)
        podcastEntity.id = podcast.id
        podcastEntity.title = podcast.title
        podcastEntity.podcastDescription = podcast.description
        podcastEntity.author = podcast.author
        podcastEntity.genre = podcast.primaryGenre
        podcastEntity.artworkURLString = podcast.artworkURL?.absoluteString
        podcastEntity.feedURLString = podcast.feedURL.absoluteString
        
        let subscription = SubscriptionEntity(context: mainContext)
        subscription.dateSubscribed = Date()
        subscription.podcast = podcastEntity
        
        try mainContext.save()
        
        return subscription
    }
    
    func unsubscribe(from podcast: Podcast) throws {
        if let sub = try findSubscription(with: podcast.id) {
            mainContext.delete(sub)
            try mainContext.save()
        }
    }
}

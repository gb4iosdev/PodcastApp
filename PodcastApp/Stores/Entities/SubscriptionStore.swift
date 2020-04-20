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
    
    private let context: NSManagedObjectContext
    
    init(with context: NSManagedObjectContext) {
        self.context = context
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
        
        return try context.fetch(fetch).first
    }
    
    func fetchSubscriptions() throws -> [SubscriptionEntity] {
        let fetchRequest: NSFetchRequest<SubscriptionEntity> = SubscriptionEntity.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.relationshipKeyPathsForPrefetching = ["podcast"]
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateSubscribed", ascending: false)]
        return try context.fetch(fetchRequest)
    }
    
    @discardableResult
    func subscribe(to podcast: Podcast) throws -> SubscriptionEntity {
        let podcastEntity = PodcastEntity(context: context)
        podcastEntity.id = podcast.id
        podcastEntity.title = podcast.title
        podcastEntity.podcastDescription = podcast.description
        podcastEntity.author = podcast.author
        podcastEntity.genre = podcast.primaryGenre
        podcastEntity.artworkURLString = podcast.artworkURL?.absoluteString
        podcastEntity.feedURLString = podcast.feedURL.absoluteString
        
        let subscription = SubscriptionEntity(context: context)
        subscription.dateSubscribed = Date()
        subscription.podcast = podcastEntity
        
        try context.save()
        
        let change = SubscriptionsChanged(subscribed: [podcast.id])
        NotificationCenter.default.post(change)
        
        return subscription
    }
    
    func unsubscribe(from podcast: Podcast) throws {
        if let sub = try findSubscription(with: podcast.id) {
            context.delete(sub)
            try context.save()
            
            let change = SubscriptionsChanged(unsubscribed: [podcast.id])
            NotificationCenter.default.post(change)
        }
    }
    
    func findPodcast(with podcastId: String) throws -> PodcastEntity? {
        let fetch: NSFetchRequest<PodcastEntity> = PodcastEntity.fetchRequest()
        fetch.fetchLimit = 1
        fetch.predicate = NSPredicate(format: "id == %@", podcastId)
        
        return try context.fetch(fetch).first
    }
    
    func fetchPlaylist() throws -> [EpisodeEntity] {
        return try context.fetch(playlistFetchRequest())
    }
    
    func playlistFetchRequest() -> NSFetchRequest<EpisodeEntity> {
        let fetch: NSFetchRequest<EpisodeEntity> = EpisodeEntity.fetchRequest()
        fetch.predicate = NSPredicate(format: "podcast.subscription != nil")
        fetch.sortDescriptors = [NSSortDescriptor(key: "publicationDate", ascending: false)]
        return fetch
    }
    
    func findCurrentlyPlayingEpisode() throws -> EpisodeStatusEntity? {
        let fetch: NSFetchRequest<EpisodeStatusEntity> = EpisodeStatusEntity.fetchRequest()
        fetch.fetchLimit = 1
        fetch.predicate = NSPredicate(format: "isCurrentlyPlaying == YES")
        
        return try context.fetch(fetch).first
    }
    
    func getStatus(for episode: Episode) throws -> EpisodeStatusEntity? {
        guard let identifier = episode.identifier else { return nil }
        let fetch: NSFetchRequest<EpisodeEntity> = EpisodeEntity.fetchRequest()
        fetch.fetchLimit = 1
        fetch.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        guard let episode = try context.fetch(fetch).first else { return nil }
        
        if let status = episode.status {
            return status
        }
        
        let status = EpisodeStatusEntity(context: context)
        status.episode = episode
        return status
    }
}

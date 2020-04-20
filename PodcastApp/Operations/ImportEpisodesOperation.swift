//
//  ImportEpisodesOperation.swift
//  PodcastApp
//
//  Created by Gavin Butler on 14-04-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation
import CoreData

//Import all the episodes from a podcast and save into database.

class ImportEpisodesOperation: BaseOperation {
    
    private let podcastId: String
    private let feedLoader = PodcastFeedLoader()
    private var context: NSManagedObjectContext!
    private var subscriptionStore: SubscriptionStore!
    
    init(podcastId: String) {
        self.podcastId = podcastId
    }
    
    override func execute() {
        context = PersistenceManager.shared.newBackgroundContext()
        subscriptionStore = SubscriptionStore(with: context)
        
        //load the Podcast
        print("Importing Episodes -> for podcast: \(podcastId)")
        guard let podcastEntity = loadPodcast() else {
            finish()
            return
        }
        
        //Import the feed
        print("Importing Episodes -> fetching the feed for: \(podcastEntity.title ?? "<?>") - \(podcastEntity.feedURLString)")
        
        guard let lookup = podcastEntity.lookupInfo else {
            print("Couldn't build lookup info - id or feedURL is nil")
            finish()
            return
        }
        
        feedLoader.fetch(lookupInfo: lookup) { result in
            switch result {
            case .success(let podcast):
                self.importEpisodes(podcast.episodes, podcast: podcastEntity)
                self.saveChanges()
                self.finish()
            case .failure(let error):
                print("Error loading feed: \(error.localizedDescription)")
                self.finish()
            }
        }
    }
    
    private func saveChanges() {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                print("Error saving changes: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadPodcast() -> PodcastEntity? {
        do {
            guard let podcast = try subscriptionStore.findPodcast(with: podcastId) else {
                print("Couldn't find podcast with Id: \(podcastId)")
                return nil
            }
            return podcast
        } catch {
            print("Error fetching podcast: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func importEpisodes(_ episodes: [Episode], podcast: PodcastEntity) {
        var existingEpisodes = [String : EpisodeEntity]()
        podcast.episodes?
            .forEach {
                existingEpisodes[$0.identifier] = $0
        }
        
        for episode in episodes {
            guard let episodeId = episode.identifier else {
                print("Skipping Episode with Title: \(episode.title ?? "<?>") because it's identifier doesn't exist")
                continue
            }
            
            guard let enclosureURL = episode.enclosureURL else {
                print("Skipping Episode with Title: \(episode.title ?? "<?>") because it's enclosureURL doesn't exist")
                continue
            }
            
            let episodeEntity = existingEpisodes[episodeId] ?? EpisodeEntity(context: context)
            episodeEntity.identifier = episodeId
            episodeEntity.podcast = podcast
            episodeEntity.title = episode.title ?? "Untitled"
            episodeEntity.publicationDate = episode.publicationDate ?? Date()
            episodeEntity.duration = episode.duration ?? 0
            episodeEntity.episodeDescription = episode.description ?? ""
            episodeEntity.enclosureURL = enclosureURL
            
            print("Importing:\(episodeEntity.title)...")
        }
    }
    
}

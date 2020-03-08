//
//  PodcastFeedLoader.swift
//  PodcastApp
//
//  Created by Gavin Butler on 16-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation
import FeedKit

class PodcastFeedLoader {
    
    typealias FeedLoaderCompletion = (Swift.Result<Podcast, PodcastLoadingError>) -> Void
    
    func fetch(lookupInfo: PodcastLookupInfo, completion: @escaping FeedLoaderCompletion) {
        
        let request = URLRequest(url: lookupInfo.feedURL, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.networkingError(error)))
                }
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            
            switch httpResponse.statusCode {
            case 200:
                if let data = data {
                    self.loadFeed(lookupInfo: lookupInfo, data: data, completion: completion)
                }
            case 404:
                DispatchQueue.main.async {
                    completion(.failure(.notFound))
                }
            default:
                DispatchQueue.main.async {
                    completion(.failure(.requestFailed(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    private func loadFeed(lookupInfo: PodcastLookupInfo, data: Data, completion: @escaping FeedLoaderCompletion) {
        
        let parser = FeedParser(data: data)
        
        parser.parseAsync { parseResult in
            
            let result: Swift.Result<Podcast, PodcastLoadingError>
            
            switch parseResult {
            case .success(let feed):
                do {
                    switch feed {
                    case .atom(let atom):
                        result = .success(try self.convert(atom: atom, lookupInfo: lookupInfo))
                    case .rss(let rss):
                        result = .success(try self.convert(rss: rss, lookupInfo: lookupInfo))
                    case .json(_):
                        result = .failure(.unknownDataFormat)
                    }
                } catch let err as PodcastLoadingError {
                    result = .failure(err)
                } catch {
                    fatalError()
                }
            case .failure:
                result = .failure(.feedParsingError)
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    private func convert(atom: AtomFeed, lookupInfo: PodcastLookupInfo) throws -> Podcast {
        guard let name = atom.title else {
            throw PodcastLoadingError.feedMissingData("title")
        }
        
        let author = atom.authors?.compactMap({ $0.name }).joined(separator: ", ") ?? ""
        
        guard let logoURL = atom.logo.flatMap(URL.init) else {
            throw PodcastLoadingError.feedMissingData("logo")
        }
        
        let description = atom.subtitle?.value ?? ""
        
        let podcast = Podcast(id: lookupInfo.id, feedURL: lookupInfo.feedURL)
        podcast.title = name
        podcast.author = author
        podcast.artworkURL = logoURL
        podcast.description = description
        podcast.primaryGenre = atom.categories?.first?.attributes?.label
        
        podcast.episodes = (atom.entries ?? []).map { entry in
            let episode = Episode()
            episode.identifier = entry.id
            episode.title = entry.title
            episode.description = entry.summary?.value
            episode.enclosureURL = entry.content?.value.flatMap(URL.init)
            
            return episode
        }
        
        return podcast
    }
    
    private func convert(rss: RSSFeed, lookupInfo: PodcastLookupInfo) throws -> Podcast {
        guard let title = rss.title else {
            throw PodcastLoadingError.feedMissingData("title")
        }
        
        guard let author = rss.iTunes?.iTunesAuthor ?? rss.iTunes?.iTunesOwner?.name else {
            throw PodcastLoadingError.feedMissingData("itunes:author, itunes:owner name")
        }
        
        guard let logoURL = rss.iTunes?.iTunesImage?.attributes?.href.flatMap(URL.init) else {
            throw PodcastLoadingError.feedMissingData("itunes:image url")
        }
        
        let description = rss.description ?? ""
        
        let podcast = Podcast(id: lookupInfo.id, feedURL: lookupInfo.feedURL)
        podcast.title = title
        podcast.author = author
        podcast.artworkURL = logoURL
        podcast.description = description
        podcast.primaryGenre = rss.categories?.first?.value ?? rss.iTunes?.iTunesCategories?.first?.attributes?.text
        podcast.episodes = (rss.items ?? []).map { item in
            let episode = Episode()
            episode.identifier = item.guid?.value
            episode.title = item.title
            episode.description = item.description
            episode.publicationDate = item.pubDate
            episode.duration = item.iTunes?.iTunesDuration
            episode.enclosureURL = item.enclosure?.attributes?.url.flatMap(URL.init)
            return episode
        }
        
        return podcast
    }
}


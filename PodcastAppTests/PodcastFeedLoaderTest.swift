//
//  PodcastFeedLoaderTest.swift
//  PodcastAppTests
//
//  Created by Gavin Butler on 16-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation
import XCTest
@testable import PodcastApp

class PodcastFeedLoaderTest: XCTestCase {
    
    func testCanParseFeeds() {
        let feeds = [
            "https://rss.art19.com/the-shrink-next-door",
            "https://feeds.megaphone.fm/solvable",
            "https://feeds.megaphone.fm/thechernobylpodcast"
            ].compactMap(URL.init)
        
        for feed in feeds {
            let exp = expectation(description: "Loading Feed \(feed)...")
            PodcastFeedLoader().fetch(feed: feed) { result in
                exp.fulfill()
                switch result {
                case .failure(let err):
                    XCTFail(err.localizedDescription)
                case .success(let podcast):
                    XCTAssertNotNil(podcast.title)
                }
            }
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
}

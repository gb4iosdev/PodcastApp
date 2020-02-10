//
//  PodcastAppTests.swift
//  PodcastAppTests
//
//  Created by Gavin Butler on 09-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import XCTest
@testable import PodcastApp

class TopPodcastsAPITests: XCTestCase {
    
    var client: TopPodcastsAPI?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        client = TopPodcastsAPI()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        client = nil
    }

    func testFetchesData() {
        let exp = expectation(description: "API Result received")
        client?.fetchTopPodcasts(limit: 50) { result in
            exp.fulfill()
            switch result {
            case .success(let data):
                XCTAssert(data.count > 0)
                let body = String(data: data, encoding: .utf8)!
                print(body)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [exp], timeout: 3.0)
        
    }
}

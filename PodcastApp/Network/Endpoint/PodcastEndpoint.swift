//
//  PodcastEndpoint.swift
//  PodcastApp
//
//  Created by Gavin Butler on 09-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import UIKit

//Encapsulate endpoints for the 3 main app areas:
enum PodcastEndpoint {
    case topPodcasts(limit: Int)
    //Example URL: https://rss.itunes.apple.com/api/v1/ca/podcasts/top-podcasts/all/27/non-explicit.json
    case search(searchTerm: String)
    //Example URL: https://itunes.apple.com/search?country=ca&media=podcast&entity=podcast&attribute=titleTerm&term=reply all
}

//conforms to the Endpoint protocol to assist with URL creation.
extension PodcastEndpoint: Endpoint {
    var path: String {
        switch self {
        case .topPodcasts(let limit):
            return "/api/v1/ca/podcasts/top-podcasts/all/\(limit)/non-explicit.json"
        case .search:
            return "/search/"
        }
    }
    
    var queryParameters: [URLQueryItem] {
        
        var result = [URLQueryItem]()
        //let apiKey = "4Ye02d6tWRNIZvP5a9RMOnFbePacsNy6ZfwIcW9l"
        
        switch self {
        //Build Parameter lists (Query Items) with reference to the ParameterKey Class.
        case .topPodcasts:      //No query items
            break
        case .search(let searchTerm):
            result.append(URLQueryItem(name: ParameterKey.country.rawValue, value: "ca"))
            result.append(URLQueryItem(name: ParameterKey.media.rawValue, value: "podcast"))
            result.append(URLQueryItem(name: ParameterKey.entity.rawValue, value: "podcast"))
            result.append(URLQueryItem(name: ParameterKey.attribute.rawValue, value: "titleTerm"))
            result.append(URLQueryItem(name: ParameterKey.searchTerm.rawValue, value: searchTerm))
        }
        
        return result
    }
    
    var base: String {
        switch self {
        case .topPodcasts:
            return "https://rss.itunes.apple.com"
        case .search:
            return "https://itunes.apple.com"
        }
        
    }
}

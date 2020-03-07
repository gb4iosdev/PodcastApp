//
//  PodcastLoadingError.swift
//  PodcastApp
//
//  Created by Gavin Butler on 16-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

enum PodcastLoadingError: Error {
    case networkingError(Error)
    case requestFailed(Int)
    case notFound
    case feedParsingError
    case feedMissingData(String)
    case unknownDataFormat          //if JSON or other returned in the feed
    
    var localizedDescription: String {
        switch self {
        case .feedMissingData(let key): return "Feed is missing data for key: \(key)"
        case .networkingError(let error): return "Network error fetching podcast: \(error.localizedDescription)"
        case .feedParsingError: return "Feed Parsing Error"
        case .notFound: return "Feed not found"
        case .requestFailed(let status): return "HTTP \(status) returned while fetching feed"
        case .unknownDataFormat: return "Found an unexpected data format in the feed"
        }
    }
    
    static func convert(from error: APIError) -> PodcastLoadingError {
        switch error {
        case .decodingError(_): return .feedParsingError
        case .timeOut: return .networkingError(error)
        case .networkingError(let e): return .networkingError(e)
        }
    }
}

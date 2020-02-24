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
    case serverError(Int)
    case notFound
    case feedParsingError
    case missingAttribute(String)
    case unknownDataFormat
    case feedMissingData(String)
    
    var localizedDescription: String {
        switch self {
        case .feedMissingData(let key): return "Feed is missing data for key: \(key)"
        case .networkingError(let error): return "Network error fetching podcast: \(error.localizedDescription)"
        case .feedParsingError: return "Feed Parsking Error"
        }
    }
}

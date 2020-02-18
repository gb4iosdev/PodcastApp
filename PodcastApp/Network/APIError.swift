//
//  APIError.swift
//  PodcastApp
//
//  Created by Gavin Butler on 10-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

enum APIError: Error {
    case networkingError(Error)
    case decodingError(Error)
    case timeOut
    
    var localizedDescription: String {
        switch self {
        case .networkingError(let error): return "Error sending request: \(error.localizedDescription)"
        case .decodingError(let error): return "Decoding error: \(error.localizedDescription)"
        case .timeOut: return "Time out error."
        }
    }
}

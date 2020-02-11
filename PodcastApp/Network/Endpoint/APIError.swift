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
    case decodingError(DecodingError)
}

//
//  ImageAPI.swift
//  PodcastApp
//
//  Created by Gavin Butler on 17-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import UIKit

var imageCache = NSCache<NSString, AnyObject>()

class ImageAPI: API {
    
    var downloadingURL: URL?
    
    func fetchImage(at url: URL, completion: @escaping (Result<UIImage, APIError>) -> Void) {
        
        //If we have an image in the cache, use that and return
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            completion(.success(imageFromCache))
        }
        
        //If no image in the cache, need to fetch.
        //Record the url we're fetching for:
        downloadingURL = url
        
        //Perform the low level call (request)
        fetchData(from: url) { result in
            
            switch result {
            case .success(let data):
                //Don't proceed if the url being downloaded is no longer current for this cell.
                guard url == self.downloadingURL else {
                    completion(.failure(.timeOut))
                    return
                }
                
                if let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(.success(image))
                }
                
            case .failure(let err):
                completion(.failure(.networkingError(err)))
            }
            
        }
    }
}


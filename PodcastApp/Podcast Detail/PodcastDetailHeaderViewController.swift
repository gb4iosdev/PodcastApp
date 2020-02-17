//
//  PodcastDetailHeaderViewController.swift
//  PodcastApp
//
//  Created by Gavin Butler on 16-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import UIKit

class PodcastDetailHeaderViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var podcast: Podcast? {
        didSet {
            if isViewLoaded, let podcast = podcast {
                updateUI(for: podcast)
            }
        }
    }
    
    var downloadingURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let podcast = podcast {
            updateUI(for: podcast)
        }
    }
    
    private func updateUI(for podcast: Podcast) {
        //Fetch the image
        //Ensure we have a url to use:
        guard let url = podcast.artworkURL else {
            return
        }
        
        //If we have an image in the cache, use that and return
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
          imageView.image = imageFromCache
          return
        }
        
        //If no image in the cache, need to fetch.
        //Record the url we're fetching for:
        downloadingURL = url
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let err = error {
            print(err.localizedDescription)
            return
            }
            
            //Don't proceed if the url being downloaded is no longer current for this cell.
            guard url == self.downloadingURL else { return }
            
            DispatchQueue.main.async {
                if let retreivedData = data, let imageToCache = UIImage(data: retreivedData) {
                    imageCache.setObject(imageToCache, forKey: url.absoluteString as NSString)
                    self.imageView.alpha = 0
                    self.imageView.image = imageToCache
                    UIView.animate(withDuration: 0.5) {
                        self.imageView.alpha = 1.0
                    }
                }
            }
          }).resume()
        
        titleLabel.text = podcast.title
        authorLabel.text = podcast.author
        genreLabel.text = podcast.primaryGenre
        descriptionLabel.text = podcast.description
    }
    
}

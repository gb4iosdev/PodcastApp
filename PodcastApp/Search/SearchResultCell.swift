//
//  SearchResultCell.swift
//  PodcastApp
//
//  Created by Gavin Butler on 02-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import UIKit

var imageCache = NSCache<NSString, AnyObject>()

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var podcastTitleLabel: UILabel!
    @IBOutlet weak var podcastAuthorLabel: UILabel!
    
    var downloadingURL: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        artworkImageView.backgroundColor = Theme.Colours.grey3
        artworkImageView.layer.cornerRadius = 10
        artworkImageView.layer.masksToBounds = true
        
        backgroundColor = Theme.Colours.grey4

        //selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = Theme.Colours.grey3

        podcastTitleLabel.textColor = Theme.Colours.grey0
        podcastAuthorLabel.textColor = Theme.Colours.grey1
    }
    
    func configure(with searchResult: SearchResult) {
        podcastTitleLabel.text = searchResult.title
        podcastAuthorLabel.text = searchResult.author
        
        //Fetch the image
        //Ensure we have a url to use:
        guard let url = searchResult.artworkUrl else {
            return
        }
        
        //If we have an image in the cache, use that and return
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
          artworkImageView.image = imageFromCache
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
                    self.artworkImageView.alpha = 0
                    self.artworkImageView.image = imageToCache
                    UIView.animate(withDuration: 1.5) {
                        self.artworkImageView.alpha = 1.0
                    }
                }
            }
          }).resume()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        podcastTitleLabel.text = nil
        podcastAuthorLabel.text = nil
        
        artworkImageView.image = nil
        downloadingURL = nil
    }
    
}

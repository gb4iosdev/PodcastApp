//
//  SearchResultCell.swift
//  PodcastApp
//
//  Created by Gavin Butler on 02-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import UIKit

//var imageCache = NSCache<NSString, AnyObject>()

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var podcastTitleLabel: UILabel!
    @IBOutlet weak var podcastAuthorLabel: UILabel!
    
    var downloadingURL: URL?
    
    let imageAPI = ImageAPI()
    
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
        
        //Ensure we have a url to use:
        guard let url = searchResult.artworkUrl else {
            return
        }
        
        imageAPI.fetchImage(at: url) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.artworkImageView.alpha = 0
                    self.artworkImageView.image = image
                    UIView.animate(withDuration: 0.5) {
                        self.artworkImageView.alpha = 1.0
                    }
                }
            case .failure(let err):
                switch err {
                case .timeOut:
                    return
                default:
                    print("Error fetching Image for cell: \(err.localizedDescription)")
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        podcastTitleLabel.text = nil
        podcastAuthorLabel.text = nil
        
        artworkImageView.image = nil
        downloadingURL = nil
    }
    
}

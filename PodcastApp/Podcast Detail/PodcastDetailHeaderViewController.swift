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
    
    let imageAPI = ImageAPI()
    
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
        
        imageAPI.fetchImage(at: url) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.imageView.alpha = 0
                    self.imageView.image = image
                    UIView.animate(withDuration: 0.5) {
                        self.imageView.alpha = 1.0
                    }
                }
            case .failure(let error):
                print("Error downloading image: \(error.localizedDescription)")
            }
        }
        
        titleLabel.text = podcast.title
        authorLabel.text = podcast.author
        genreLabel.text = podcast.primaryGenre
        descriptionLabel.text = podcast.description
    }
    
}

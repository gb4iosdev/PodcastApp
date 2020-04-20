//
//  PlaylistCell.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 10/28/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import UIKit

class PlaylistCell : UITableViewCell {

    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var podcastLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    let imageAPI = ImageAPI()

    override func awakeFromNib() {
        super.awakeFromNib()

        artworkImageView.backgroundColor = Theme.Colours.grey3
        artworkImageView.layer.cornerRadius = 6
        artworkImageView.layer.masksToBounds = true

        backgroundColor = Theme.Colours.grey4
        backgroundView = UIView()
        backgroundView?.backgroundColor = Theme.Colours.grey4

        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = Theme.Colours.grey3

        episodeTitleLabel.textColor = Theme.Colours.grey0
        podcastLabel.textColor = Theme.Colours.grey1
        durationLabel.textColor = Theme.Colours.grey2
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        episodeTitleLabel.text = nil
        podcastLabel.text = nil
        durationLabel.text = nil

        imageAPI.cancelFetch()
        artworkImageView.image = nil
    }

    func configure(with viewModel: PlaylistCellViewModel) {
        episodeTitleLabel.text = viewModel.title
        podcastLabel.text = viewModel.podcastTitle
        durationLabel.text = viewModel.info
    
        //artworkImageView.kf.setImage(with: viewModel.artworkURL, placeholder: nil, options: [.transition(.fade(0.3))])
        
        //Ensure we have a url to use:
        guard let url = viewModel.artworkURL else {
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
}

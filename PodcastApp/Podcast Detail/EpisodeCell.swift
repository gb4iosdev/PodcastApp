//
//  EpisodeCell.swift
//  PodcastApp
//
//  Created by Gavin Butler on 06-03-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = Theme.Colours.grey5
        contentView.backgroundColor = Theme.Colours.grey5
        titleLabel.textColor = Theme.Colours.grey0
        infoLabel.textColor = Theme.Colours.grey2
        descriptionLabel.textColor = Theme.Colours.grey2
    }
    
    func configure(with viewModel: EpisodeCellViewModel) {
        titleLabel.text = viewModel.title
        infoLabel.text = viewModel.info
        descriptionLabel.text = viewModel.description
    }
}

//
//  PlayerViewController.swift
//  PodcastApp
//
//  Created by Gavin Butler on 09-03-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    
    static var shared: PlayerViewController  = {
        let storyboard = UIStoryboard(name: "Player", bundle: nil)
        let playerVC = storyboard.instantiateInitialViewController() as! PlayerViewController
        _ = playerVC.view            //Touching this ensures that the PlayerViewController is forced to load.
        return playerVC
    }()
    
    //MARK:- Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var artworkShadowWrapper: UIView!
    @IBOutlet weak var transportSlider: UISlider!
    @IBOutlet weak var timeProgressedLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.Colours.grey4
        
        titleLabel.textColor = Theme.Colours.grey1
        timeRemainingLabel.textColor = Theme.Colours.grey2
        timeProgressedLabel.textColor = Theme.Colours.grey2
        
        timeRemainingLabel.text = nil
        timeProgressedLabel.text = nil
        
        artworkImageView.layer.masksToBounds = true
        artworkImageView.layer.cornerRadius = 12
        artworkImageView.backgroundColor = Theme.Colours.grey4
        
        artworkShadowWrapper.backgroundColor = .clear
        artworkShadowWrapper.layer.shadowColor = UIColor.black.cgColor
        artworkShadowWrapper.layer.shadowOpacity = 0.9
        artworkShadowWrapper.layer.shadowOffset = CGSize(width: 0, height: 1)
        artworkShadowWrapper.layer.shadowRadius = 20
        
        transportSlider.setThumbImage(UIImage(named: "Knob"), for: .normal)
        transportSlider.setThumbImage(UIImage(named: "Knob-Tracking"), for: .highlighted)
        
        let pauseImage = playPauseButton.image(for: .selected)
        //TODO:  tint this image
        playPauseButton.setImage(pauseImage, for: [.selected, .highlighted])
    
    }
    
    func setEpisode(_ episode: Episode, podcast: Podcast) {
        titleLabel.text = episode.title
        //Set the artworkImageView image here:  This is where Ben uses Kingfisher again.  Need to borrow code from other location, and look to modularize that code.   Fade in over 0.3 sec
        
    }
    
    //MARK:- Actions
    @IBAction func dismissTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func transportSliderChanged(_ sender: UISlider) {
    }
    
    @IBAction func skipBack(_ sender: UIButton) {
    }
    
    @IBAction func skipForward(_ sender: UIButton) {
    }
    
    @IBAction func playPause(_ sender: UIButton) {
        
        playPauseButton.isSelected.toggle()
    }
}

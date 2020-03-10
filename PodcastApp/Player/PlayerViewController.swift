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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
    }
    
    //MARK:- Actions
    @IBAction func dismissTapped(_ sender: UIButton) {
    }
    
    @IBAction func transportSliderChanged(_ sender: UISlider) {
    }
    
    @IBAction func skipBack(_ sender: UIButton) {
    }
    
    @IBAction func skipForward(_ sender: UIButton) {
    }
    
    @IBAction func playPause(_ sender: UIButton) {
    }
}

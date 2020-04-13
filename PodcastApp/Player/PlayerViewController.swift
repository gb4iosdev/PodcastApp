//
//  PlayerViewController.swift
//  PodcastApp
//
//  Created by Gavin Butler on 09-03-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import UIKit
import AVFoundation


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
    
    @IBOutlet var playerBar: PlayerBar!
    
    weak var presentationRootController: UIViewController?   //Where we present this PlayerViewController from.
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let imageAPI = ImageAPI()
    
    private var player: AVPlayer?
    private var timeObservationToken: Any?
    private var skipTime = CMTime(seconds: 10, preferredTimescale: CMTimeScale(NSEC_PER_SEC))

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playerBar.isHidden = true

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
        transportSlider.isEnabled = false
        
        let pauseImage = playPauseButton.image(for: .selected)
        let tintedImage = pauseImage?.tint(colour: Theme.Colours.purpleDimmed)
        playPauseButton.setImage(tintedImage, for: [.selected, .highlighted])
        playerBar.playPauseButton.setImage(tintedImage, for: [.selected, .highlighted])
    }
    
    func setEpisode(_ episode: Episode, podcast: Podcast) {
        titleLabel.text = episode.title
        
        //Retrieve Image:  Ensure we have a url to use:
        guard let url = podcast.artworkURL else {
            return
        }
        
        fetchImage(at: url, for: artworkImageView)
        fetchImage(at: url, for: playerBar.imageView)   //Should use the cache for this.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.playerBar.isHidden = false
        }
        
        //Setup Audio Session:
        do {
            try configureAudioSession()
        } catch {
            print("ERROR: \(error.localizedDescription)")
            showAudioSessionError()
        }
        
        //Stop any existing player from playing
        if let player = player {
            player.pause()
            if let previousTimeObservation = timeObservationToken {
                player.removeTimeObserver(previousTimeObservation)
            }
            self.player = nil
        }
        
        guard let audioURL = episode.enclosureURL else { return }
        let player = AVPlayer(url: audioURL)
        player.play()   //Delay here - Will start playing when enough of the song is buffered
        togglePlayPauseButton(isPlaying: true)
        
        self.player = player
        
        transportSlider.isEnabled = true
        transportSlider.value = 0
        
        let interval = CMTime(seconds: 0.25, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObservationToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.updateSlider(for: time)
            
            self?.timeProgressedLabel.text = time.formattedString
            if let duration = player.currentItem?.duration {
                let remaining = duration - time
                self?.timeRemainingLabel.text = "-" + remaining.formattedString
            } else {
                self?.timeRemainingLabel.text = "--"
            }
        }
    }
    
    private func updateSlider(for time: CMTime) {
        //Need to ensure the user is not currently dragging the transportSlider, otherwise will be fighting against this:
        guard !transportSlider.isTracking else { return }
        guard let duration = player?.currentItem?.duration else { return }
        let progress = time.seconds / duration.seconds
        transportSlider.value = Float(progress)
    }
    
    private func configureAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playback)
        try session.setMode(.spokenAudio)
        try session.setActive(true, options: [])
    }

    private func showAudioSessionError() {
        let alert = UIAlertController(title: "Playback Error", message: "There was an error configuring the audio system for playback", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Actions
    @IBAction func dismissTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func transportSliderChanged(_ sender: UISlider) {
        guard let player = player else { return }
        guard let currentItem = player.currentItem else { return }
        
        let seconds = currentItem.duration.seconds * Double(transportSlider.value)
        let time = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.seek(to: time)
        
    }
    
    @IBAction func skipBack(_ sender: UIButton) {
        guard let player = player else { return }
        
        let time = player.currentTime() - skipTime
        if time > CMTime.zero {
            player.seek(to: time)
            updateSlider(for: time)
        } else {
            player.seek(to: .zero)
            updateSlider(for: .zero)
        }
        
    }
    
    @IBAction func skipForward(_ sender: UIButton) {
        guard let player = player else { return }
        guard let currentItem = player.currentItem else { return }
        
        let time = player.currentTime() + skipTime
        if time < currentItem.duration {
            player.seek(to: time)
            updateSlider(for: time)
        } else {
            player.seek(to: currentItem.duration)
            updateSlider(for: currentItem.duration)
        }
    }
    
    @IBAction func playPause(_ sender: UIButton) {
        
        let wasPlaying = playPauseButton.isSelected
        togglePlayPauseButton(isPlaying: !wasPlaying)
        
        if wasPlaying {
            player?.pause()
        } else {
            player?.play()
        }
    }
    
    private func togglePlayPauseButton(isPlaying: Bool) {
        playPauseButton.isSelected = isPlaying
        playerBar.playPauseButton.isSelected = isPlaying
    }
    
    @IBAction func presentPlayer() {
        //Needs a view controller to call, as the playerVC can be presented from anywhere in the application.
        presentationRootController?.present(PlayerViewController.shared, animated: true, completion: nil)
    }
}

//MARK: - Helpers
extension PlayerViewController {
    
    func fetchImage(at url: URL, for imageView: UIImageView) {
        imageAPI.fetchImage(at: url) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    imageView.alpha = 0
                    imageView.image = image
                    UIView.animate(withDuration: 0.3) {
                        imageView.alpha = 1.0
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

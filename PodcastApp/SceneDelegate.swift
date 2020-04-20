//
//  SceneDelegate.swift
//  PodcastApp
//
//  Created by Gavin Butler on 02-02-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        //guard let window = thisScene.windows.first else { return }
        window = UIWindow() // This would normally come from the storyboard...
        window!.windowScene = windowScene
        

        window!.rootViewController = UIViewController()

        window!.makeKeyAndVisible()
        
        Theme.apply(to: window!)
        
        //Persistence
        PersistenceManager.shared.initializeModel {
            FeedImporter.shared.startListening()
            FeedImporter.shared.updatePodcasts()    //Loads episodes in the background
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            self.window!.rootViewController = storyboard.instantiateInitialViewController()
            
            let store = SubscriptionStore(with: PersistenceManager.shared.mainContext)
            do {
                if let currentStatus = try store.findCurrentlyPlayingEpisode() {
                    guard let episodeEntity = currentStatus.episode else { return }
                    let podcastEntity = episodeEntity.podcast
                    
                    let episode = Episode(from: episodeEntity)
                    let podcast = Podcast(from: podcastEntity)
                    
                    let playerVC = PlayerViewController.shared
                    playerVC.setEpisode(episode, podcast: podcast, autoPlay: false)
                    
                    self.window?.rootViewController?.present(playerVC, animated: true, completion: nil)
                }
            } catch {
                print("Error trying to fetch currently playing episode \(error.localizedDescription)")
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        trySave()
    }

    private func trySave() {
        do {
            print("Saving changes....")
            try PersistenceManager.shared.mainContext.save()
        } catch {
            print("Error saving changes in scene delegate: \(error.localizedDescription)")
        }
    }

}


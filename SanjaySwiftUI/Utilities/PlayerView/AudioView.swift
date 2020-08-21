//
//  AudioView.swift
//  AVPlayer-SwiftUI
//
//  Created by Chris Mash on 08/03/2020.
//  Copyright © 2020 Chris Mash. All rights reserved.
//
// Modified by Sanjay Sampat on 21/08/2020

import SwiftUI
import AVFoundation

struct AudioPlayerControlsView: View {
    private enum PlaybackState: Int {
        case waitingForSelection
        case buffering
        case readyToPlay
        case playing
        case failed
    }
    
    let player: AVPlayer
    let timeObserver: PlayerTimeObserver
    let durationObserver: PlayerDurationObserver
    let itemObserver: PlayerItemObserver
    let itemStatusObserver: PlayerItemStatusObserver
    let itemLikelyToKeepUpObserver: PlayerItemLikelyToKeepUpObserver
    @State private var currentTime: TimeInterval = 0
    @State private var currentDuration: TimeInterval = 0
    @State private var state = PlaybackState.waitingForSelection
    
    @State private var playerPaused = true

    var body: some View {
        VStack {
            if state == .waitingForSelection {
                Text("Select a song below")
            } else if state == .buffering {
                Text("Buffering...")
            } else if state == .readyToPlay {
                Text("Play now")
            } else if state == .failed {
                Text("Load failed")
            } else {
                Text("Great choice!")
            }
            
            HStack {
            // Play/pause button
            Button(action: togglePlayPause) {
                Image(systemName: state == .readyToPlay || state == .playing ? (playerPaused ? "play" : "pause") : "questionmark.diamond")
                    .padding(.trailing, 10)
            }
            .disabled(state == .waitingForSelection)

            Slider(value: $currentTime,
                   in: 0...currentDuration,
                   onEditingChanged: sliderEditingChanged,
                   minimumValueLabel: Text("\(Utility.formatSecondsToHMS(currentTime))"),
                   maximumValueLabel: Text("\(Utility.formatSecondsToHMS(currentDuration))")) {
                    // I have no idea in what scenario this View is shown...
                    Text("seek/progress slider")
            }
            .disabled(state != .playing)
            }
        }
        .padding()
        // Listen out for the time observer publishing changes to the player's time
        .onReceive(timeObserver.publisher) { time in
            // Update the local var
            self.currentTime = time
            // And flag that we've started playback
            if time > 0 {
                self.state = .playing
            }
        }
        // Listen out for the duration observer publishing changes to the player's item duration
        .onReceive(durationObserver.publisher) { duration in
            // Update the local var
            self.currentDuration = duration
        }
        // Listen out for the item observer publishing a change to whether the player has an item
        .onReceive(itemObserver.publisher) { hasItem in
            
            print("hasItem : \(hasItem)")
            
            self.state = hasItem ? self.state : .waitingForSelection
            self.currentTime = 0
            self.currentDuration = 0
        }
        // Listen out for the item observer publishing a status of player item.
        .onReceive(itemStatusObserver.publisher) { playerStatus in
                
                print("playerStatus : \(playerStatus.rawValue)")
                
            self.state = playerStatus == AVPlayer.Status.failed ? .failed : playerStatus == AVPlayer.Status.readyToPlay ? .readyToPlay : self.state
        }
        // Listen out for the item observer publishing PlaybackLikelyToKeepUpObserver
        .onReceive(itemLikelyToKeepUpObserver.publisher) { isKeepUp in
                
                print("isKeepUp : \(isKeepUp)")

                self.state = isKeepUp ? self.state : .buffering

        }
        
        // TODO the below could replace the above but causes a crash
//        // Listen out for the player's item changing
//        .onReceive(player.publisher(for: \.currentItem)) { item in
//            self.state = item != nil ? .buffering : .waitingForSelection
//            self.currentTime = 0
//            self.currentDuration = 0
//        }
    }
    
    // MARK: Private functions
    
    private func togglePlayPause() {
        pausePlayer(!playerPaused)
    }
    
    private func pausePlayer(_ pause: Bool) {
        playerPaused = pause
        if playerPaused {
            player.pause()
        }
        else {
            player.play()
        }
    }

    private func sliderEditingChanged(editingStarted: Bool) {
        if editingStarted {
            // Tell the PlayerTimeObserver to stop publishing updates while the user is interacting
            // with the slider (otherwise it would keep jumping from where they've moved it to, back
            // to where the player is currently at)
            timeObserver.pause(true)
            playerPaused = true
        }
        else {
            // Editing finished, start the seek
            ////state = .buffering
            let targetTime = CMTime(seconds: currentTime,
                                    preferredTimescale: 600)
            player.seek(to: targetTime) { _ in
                // Now the (async) seek is completed, resume normal operation
                self.timeObserver.pause(false)
                self.playerPaused = false
                self.state = .playing
            }
        }
    }
}

struct AudioView: View {
    let player = AVPlayer()
    // preventsDisplaySleepDuringVideoPlayback: Bool ( of AVPlayer )
    
    private let items = [(url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
                          title: "Song-1"),
                         (url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
                          title: "Song-2")]
    
    var body: some View {
        VStack {
            AudioPlayerControlsView(player: player,
                                    timeObserver: PlayerTimeObserver(player: player),
                                    durationObserver: PlayerDurationObserver(player: player),
                                    itemObserver: PlayerItemObserver(player: player),
                                    itemStatusObserver: PlayerItemStatusObserver(player: player),
                                    itemLikelyToKeepUpObserver: PlayerItemLikelyToKeepUpObserver(player: player)
            )
            
            List(items, id: \.title) { item in
                Button(item.title) {
                    guard let url = URL(string: item.url) else {
                        return
                    }
                    
                    // SSTODO - here we will get the AVPlayerItem status when Item is replaced.
                    // SSTODO the PlayerItemObserver and PlayerItemStatusObserver of AVPlayer object should be using AVPlayerItem observers eg. code as under
                    /*
                    // Create a new AVPlayerItem with the asset and an
                    // array of asset keys to be automatically loaded
                    playerItem = AVPlayerItem(asset: asset,
                                              automaticallyLoadedAssetKeys: assetKeys)
                    
                    // Register as an observer of the player item's status property
                    playerItem.addObserver(self,
                                           forKeyPath: #keyPath(AVPlayerItem.status),
                                           options: [.old, .new],
                                           context: &playerItemContext)
                    
                    // Associate the player item with the player
                    player = AVPlayer(playerItem: playerItem)
                     //// and Observer handling
                     override func observeValue(forKeyPath keyPath: String?,
                                                of object: Any?,
                                                change: [NSKeyValueChangeKey : Any]?,
                                                context: UnsafeMutableRawPointer?) {
                         // Only handle observations for the playerItemContext
                         guard context == &playerItemContext else {
                             super.observeValue(forKeyPath: keyPath,
                                                of: object,
                                                change: change,
                                                context: context)
                             return
                         }
                         
                         if keyPath == #keyPath(AVPlayerItem.status) {
                             let status: AVPlayerItemStatus
                             
                             // Get the status change from the change dictionary
                             if let statusNumber = change?[.newKey] as? NSNumber {
                                 status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
                             } else {
                                 status = .unknown
                             }
                             
                             // Switch over the status
                             switch status {
                             case .readyToPlay:
                             // Player item is ready to play.
                             case .failed:
                             // Player item failed. See error.
                             case .unknown:
                                 // Player item is not yet ready.
                             }
                         }
                     }
                    */
                    
                    let playerItem = AVPlayerItem(url: url)
                    self.player.replaceCurrentItem(with: playerItem)
                    //self.player.play()
                }
            }
        }
        .onDisappear {
            // When this View isn't being shown anymore stop the player
            self.player.replaceCurrentItem(with: nil)
        }
    }
}

import Combine
class PlayerTimeObserver {
    let publisher = PassthroughSubject<TimeInterval, Never>()
    private weak var player: AVPlayer?
    private var timeObservation: Any?
    private var paused = false
    
    init(player: AVPlayer) {
        self.player = player
        
        // Periodically observe the player's current time, whilst playing
        timeObservation = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: nil) { [weak self] time in
            guard let self = self else { return }
            // If we've not been told to pause our updates
            guard !self.paused else { return }
            // Publish the new player time
            self.publisher.send(time.seconds)
        }
    }
    
    deinit {
        if let player = player,
            let observer = timeObservation {
            player.removeTimeObserver(observer)
        }
    }
    
    func pause(_ pause: Bool) {
        paused = pause
    }
}

class PlayerItemStatusObserver {
    let publisher = PassthroughSubject<AVPlayer.Status, Never>()
    private var itemObservation: NSKeyValueObservation?
    
    init(player: AVPlayer) {
        // Observe the current item changing
        itemObservation = player.observe(\.currentItem?.status, options: [.new, .old]) { [weak self] player, change in
            guard let self = self else { return }
            // Publish whether the player has an item or not
            self.publisher.send(player.status)

        }
    }
    
    deinit {
        if let observer = itemObservation {
            observer.invalidate()
        }
    }
}

class PlayerItemLikelyToKeepUpObserver {
    let publisher = PassthroughSubject<Bool, Never>()
    private var itemObservation: NSKeyValueObservation?
    
    init(player: AVPlayer) {
        // Observe the current item changing
        itemObservation = player.observe(\.currentItem) { [weak self] player, change in
            guard let self = self else { return }
            guard let currentItem = player.currentItem else { return }
            // Publish whether the player has an item or not
            self.publisher.send(currentItem.isPlaybackLikelyToKeepUp)
        }
    }
    
    deinit {
        if let observer = itemObservation {
            observer.invalidate()
        }
    }
}

class PlayerItemObserver {
    let publisher = PassthroughSubject<Bool, Never>()
    private var itemObservation: NSKeyValueObservation?
    
    init(player: AVPlayer) {
        // Observe the current item changing
        itemObservation = player.observe(\.currentItem) { [weak self] player, change in
            guard let self = self else { return }
            // Publish whether the player has an item or not
            self.publisher.send(player.currentItem != nil)
        }
    }
    
    deinit {
        if let observer = itemObservation {
            observer.invalidate()
        }
    }
}

class PlayerDurationObserver {
    let publisher = PassthroughSubject<TimeInterval, Never>()
    private var cancellable: AnyCancellable?
    
    init(player: AVPlayer) {
        let durationKeyPath: KeyPath<AVPlayer, CMTime?> = \.currentItem?.duration
        cancellable = player.publisher(for: durationKeyPath).sink { duration in
            guard let duration = duration else { return }
            guard duration.isNumeric else { return }
            self.publisher.send(duration.seconds)
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
}

//
//  AudioView.swift
//  AVPlayer-SwiftUI
//
//  Created by Chris Mash on 08/03/2020.
//  Copyright © 2020 Chris Mash. All rights reserved.
//
// Modified by Sanjay Sampat on 21/08/2020 to 28/08/2020

import SwiftUI
import AVFoundation

struct AudioView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(
        entity: Audio.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Audio.datetime, ascending: true)
        ]
    ) var audios: FetchedResults<Audio>

    let player = AVPlayer()
    // preventsDisplaySleepDuringVideoPlayback: Bool ( of AVPlayer )
    
    @State var items = [
        (url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3", title: "Song-1"),
        (url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3", title: "Song-2"),
        (url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3", title: "Song-8"),
        (url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-12.mp3", title: "Song-12"),
        (url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3", title: "Song-14"),
        (url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-16.mp3", title: "Song-16")
    ]
    
    private let itemsToAdd = [(url: "https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3",
                          title: "Audio-1"),
                         (url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3",
                          title: "Audio-2")]
    

    var body: some View {
        VStack {
            AudioPlayerControlsView(player: player,
                                    timeObserver: PlayerTimeObserver(player: player),
                                    durationObserver: PlayerDurationObserver(player: player),
                                    itemObserver: PlayerItemObserver(player: player)
                                    //,
                                    //itemStatusObserver: PlayerItemStatusObserver(player: player),
                                    //itemLikelyToKeepUpObserver: PlayerItemLikelyToKeepUpObserver(player: player)
            )
            
            Divider()
            
            HStack {
                List {
                    AddButtonView(title: "Shuffle", action: {self.items.shuffle()})
                ForEach(items, id: \.title) { item in
                Button(item.title) {
                    guard let url = URL(string: item.url) else {
                        return
                    }
                    
                    // SSTODO - here we will get the AVPlayerItem status when Item is replaced.
                    // SSTODO the PlayerItemObserver and PlayerItemStatusObserver of AVPlayer object should be using AVPlayerItem observers eg. code as under
                    
                    // Be careful while adding the observers.
                    // issue of 'SourceKitService" and/or 'Swift' process on mac taking max memory, so xcode and all mac proccesses slogs to halt
                    
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
                    self.player.play()
                }
            }
                }
                
            Divider()
                
            List {
                HStack(alignment: .center) {
                    AddButtonView(title: "Add", action: insert)
                    Spacer()
                    Text("<< to del")
                        .font(.caption)
                        .fontWeight(.ultraLight)
                }
                ForEach(audios, id: \.datetime) { audio in
                    Button(audio.name ?? "") {
                        guard let _ = audio.name, let urlString = audio.url, let url = URL(string: urlString) else {
                            return
                        }
                        
                        let playerItem = AVPlayerItem(url: url)
                        
                        self.player.replaceCurrentItem(with: playerItem)
                        self.player.play()
                    }
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
            }
            .frame(maxWidth: .infinity)
                
            }
            .frame( minHeight: 150, idealHeight: 500)
           
            Divider()

        }
        .onDisappear {
            // When this View isn't being shown anymore stop the player
            self.player.replaceCurrentItem(with: nil)
        }
    }
    
    func insert() {
        
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "yyyyMMddHHmmss"
        let dateTimeString = formatter3.string(from: Date())

        // itemsToAdd.forEach { item in
        // SSNote : if we use itemsToAdd.forEach as above, we can NOT use break or continue
        for item in itemsToAdd {
            var found = false
            //audios.forEach { audio in
            for audio in audios {
                let audioName = audio.name ?? ""
                if !audioName.isEmpty && item.title.elementsEqual(audioName) {
                    found = true
                    break
                }
            }
            if !found {
                print( " new item.title '\(item.title)' added to core data" )
                let newAudio = Audio(context: self.managedObjectContext)
                newAudio.name = item.title
                newAudio.url = item.url
                newAudio.datetime = dateTimeString
                self.saveContext()
                break
            }
        }
        
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let audio = self.audios[index]
            self.managedObjectContext.delete(audio)
        }
        self.saveContext()
    }
    
    func move(from source: IndexSet, to destination: Int) {
      print("Item moved from \(source) to \(destination)")
    }

    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }

}

struct AddButtonView : View {
    var title : String = ""
    
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
        }
        .padding(5)
        .background(CommonUtils.cu_activity_light_theam_color)
        .cornerRadius(10)
    }
}


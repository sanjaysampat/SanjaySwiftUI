//
//  EmitterSpriteKitView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 03/10/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI
import SpriteKit

struct EmitterSpriteKitView: UIViewRepresentable {
    
    /**
        makeUIView and updateUIView are required methods of the UIViewRepresentable
        protocol. makeUIView does just what you'd think - makes the view we want.

        updateUIView allows you to update the view with new data, but we don't need
        it for our purposes.
        */
    
    func makeUIView(context: UIViewRepresentableContext<EmitterSpriteKitView>) -> SKView {
        // Create our SKView
                let view = SKView()
                // We want the view to animate the particle effect over our SwiftUI view
                // and let its components show through so we'll set allowsTransparenty to true.
                view.allowsTransparency = true
                // Load our custom SKScene
                // More info about creating scene in Xcode is
                // https://developer.apple.com/documentation/spritekit/skscene/creating_a_scene_from_a_file
                if let scene = SceneSanjay(fileNamed: "MySceneSanjay.sks") {
                    // We need to set the background to clear.
                    scene.backgroundColor =  .clear
                    view.presentScene(scene)
                }
                return view
    }
    
    func updateUIView(_ uiView: SKView, context: UIViewRepresentableContext<EmitterSpriteKitView>) {
        
    }
}

/**
This is our SKScene subclass that will present the emitter node.
*/
class SceneSanjay: SKScene {
    override func didMove(to view: SKView) {
       super.didMove(to: view)

       // Create our SKEmitterNode with a particle effect named "MyParticleMagic"
       // More info about creating particle effects in Xcode is
       // https://help.apple.com/xcode/mac/current/#/dev9eed16018
        
       if let emitter: SKEmitterNode = SKEmitterNode(fileNamed: "MyParticleMagic.sks") {
            // Set the initial alpha of the node to 0, as we're going to fade it in.
            emitter.alpha = 0
            // Add the emitter node to the scene
            addChild(emitter)
            // Fade the node in with a duration of half a second.
            emitter.run(SKAction.fadeIn(withDuration: 0.5)) {
                // Fade the node out with a duration of 2.5 seconds.
                emitter.run(SKAction.fadeOut(withDuration: 2.5)) {
                    // Clean up our emitter node.
                    emitter.removeFromParent()
                    // Tell our SwiftUI view that the animation has finished.
                    NotificationCenter.default.post(name: NSNotification.Name(CommonUtils.cu_ResetEmitterNotification), object: nil)
                }
            }
        }
    }
}

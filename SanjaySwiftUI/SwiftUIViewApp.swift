//
//  SwiftUIViewApp.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 03/11/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

@main
struct SwiftUIViewAppWrapper {
    static func main() {
        if #available(iOS 14.0, *) {
            SwiftUIViewApp.main()
        }
        else {
            //UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self))
        }
    }
}


@available(iOS 14.0, *)
//@main
struct SwiftUIViewApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(UserSettings())
                .environmentObject(UserAuth())
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .active:
                print("scene is now active!")
            case .inactive:
                print("scene is now inactive!")
            case .background:
                print("scene is now in the background!")
            @unknown default:
                print("Apple must have added something new!")
            }
        }
    }
}

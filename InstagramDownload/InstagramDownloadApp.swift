//
//  InstagramDownloadApp.swift
//  InstagramDownload
//
//  Created by Vo Thanh Sang on 10/04/2021.
//

import SwiftUI
import FBSDKCoreKit

@main
struct InstagramDownloadApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            
        ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                .onChange(of: scenePhase) { newScencePhase in
////                            persistenceController.save()
//                    switch newScencePhase {
//                        case.background:
//                            print("background")
//                        case .inactive:
//                            print("inactive")
//                        case .active:
//                            print("active")
//                        default:
//                            print("background")
//                    }
//                        }
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate { func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool { ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
    
    print("Database FilePatch : ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not found")
    
    return true
    
    }

    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool { ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
        
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
    
        ApplicationDelegate.shared.application( UIApplication.shared, open: url, sourceApplication: nil, annotation: [UIApplication.OpenURLOptionsKey.annotation] )
        
    }

    
}
    

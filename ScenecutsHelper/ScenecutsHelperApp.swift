//
//  ScenecutsHelperApp.swift
//  ScenecutsHelper
//
//  Created by Nick Hayward on 10/29/20.
//

import SwiftUI

@main
struct ScenecutsHelperApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            EmptyView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    
    static var appKitController:NSObject?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AppDelegate.loadAppKitIntegrationFramework()
        Home.shared.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(terminate), name: .terminateHelper, object: nil)
        
        // MARK: Handle Reopening
        NotificationCenter.default.addObserver(self, selector: #selector(handleReopen), name: NSNotification.Name("NSApplicationDidBecomeActiveNotification"),object: nil)
        return false
    }
    
    class func loadAppKitIntegrationFramework() {
        if let frameworksPath = Bundle.main.privateFrameworksPath {
            let bundlePath = "\(frameworksPath)/AppKitIntegration.framework"
            do {
                try Bundle(path: bundlePath)?.loadAndReturnError()
                
                let bundle = Bundle(path: bundlePath)!
                NSLog("[APPKIT BUNDLE] Loaded Successfully")
                
                if let appKitControllerClass = bundle.classNamed("AppKitIntegration.AppKitController") as? NSObject.Type {
                    appKitController = appKitControllerClass.init()
                }
            }
            catch {
                NSLog("[APPKIT BUNDLE] Error loading: \(error)")
            }
        }
    }
    
    @objc func terminate() {
        exit(1)
    }
    
    @objc func handleReopen() {
        let openScenecutsSelector = NSSelectorFromString("openScenecuts")
        AppDelegate.appKitController?.performSelector(onMainThread: openScenecutsSelector, with: nil, waitUntilDone: true)
    }
}

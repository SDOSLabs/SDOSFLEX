//
//  AppDelegate.swift
//  SDOSFLEX
//
//  Created by Rafael Fernandez Alvarez on 22/05/2018.
//  Copyright © 2018 SDOS. All rights reserved.
//

import UIKit
#if SPM
#if !SDOSFLEX_Disable
import FLEX
#endif
#else
#if canImport(FLEX)
import FLEX
#endif
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        #if SPM
        #if !SDOSFLEX_Disable
        FLEXManager.shared.showExplorer()
        #endif
        #else
        #if canImport(FLEX)
        FLEXManager.shared.showExplorer()
        #endif
        #endif
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard.init(name: ExampleFLEX, bundle: nil)
        let viewcontroller = storyboard.instantiateInitialViewController()
        
        self.window?.rootViewController = viewcontroller
        self.window?.makeKeyAndVisible()
        
        return true
        
    }
}

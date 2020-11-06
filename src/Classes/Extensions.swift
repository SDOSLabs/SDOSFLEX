//
//  File.swift
//  
//
//  Created by Rafael Fernandez Alvarez on 6/11/20.
//

import Foundation
import UIKit
import FLEX

extension UIWindow {
    override open func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionBegan(motion, with: event)
        
        guard motion == .motionShake else {
            return
        }
        
        FLEXManager.shared.showExplorer()
    }
}

extension UIApplication {
    override open func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionBegan(motion, with: event)
        
        guard motion == .motionShake else {
            return
        }
        
        FLEXManager.shared.showExplorer()
    }
}

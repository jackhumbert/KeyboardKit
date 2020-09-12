//
//  KeyboardKey.swift
//  KeyboardKitDemoKeyboard
//
//  Created by Jack Humbert on 9/9/20.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import Foundation
import KeyboardKit

class KeyboardKey {
    var action: KeyboardAction = .none
    var secondaryAction: KeyboardAction = .none
    var width: Float = 50
    var system: Bool = false
    
    init(action: KeyboardAction, width: Float = 50, system: Bool = false) {
        self.action = action
        self.width = width
    }
    
    convenience init(action: String, width: Float = 50, system: Bool = false) {
        self.init(action: .character(action), width: width, system: system)
    }
}

//
//  Shadow+Extra.swift
//  KeyboardKitDemoKeyboard
//
//  Created by Jack Humbert on 9/8/20.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import Foundation
import KeyboardKit

public extension Shadow {
    static var standardExtraButtonShadowDark: Shadow {
        Shadow(alpha: 0.5, blur: 0.0, spread: 0, x: 0, y: 1)
    }
    static var standardExtraButtonShadowLight: Shadow {
        Shadow(alpha: 0.3, blur: 0.0, spread: 0, x: 0, y: 1)
    }
    static var standardExtraButtonShadowCharacter: Shadow {
        Shadow(alpha: 0.9, blur: 8.0, spread: 1.0, x: 0, y: 1)
    }
}

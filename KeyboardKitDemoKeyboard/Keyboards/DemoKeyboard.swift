//
//  DemoKeyboard.swift
//  KeyboardKitExampleKeyboard
//
//  Created by Daniel Saidi on 2019-05-14.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import KeyboardKit
import UIKit

/**
 This protocol is used by the demo application keyboards and
 provides shared functionality.
 
 The demo keyboards are for demo purposes, so they lack some
 functionality, like adapting to languages, device types etc.
 */
class DemoKeyboard {
    var actions: KeyboardActionRows = [[]]
}


private extension DemoKeyboard {

    static func switchAction(for vc: KeyboardViewController) -> KeyboardAction {
        let needsSwitch = vc.needsInputModeSwitchKey
        return needsSwitch ? .nextKeyboard : .keyboardType(.emojis)
    }
    
    static func imageAction(for vc: KeyboardViewController) -> KeyboardAction {
        let needsSwitch = vc.needsInputModeSwitchKey
        return needsSwitch ? .keyboardType(.emojis) : .keyboardType(.images)
    }
}

private extension Collection where Element == KeyboardAction {
    
    var withoutImageActions: [KeyboardAction] {
        self.filter { $0 != .keyboardType(.emojis) }
            .filter { $0 != .keyboardType(.images) }
    }
}

private extension KeyboardType {

    var shouldIncludeImageAction: Bool { self != .images }
}


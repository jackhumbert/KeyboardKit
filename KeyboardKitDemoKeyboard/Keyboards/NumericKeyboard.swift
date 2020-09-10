//
//  NumericKeyboard.swift
//  KeyboardKitExampleKeyboard
//
//  Created by Daniel Saidi on 2019-05-13.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import KeyboardKit
import UIKit

/**
 This demo keyboard mimicks an English numeric keyboard.
 */
class NumericKeyboard: DemoKeyboard {
    
    init(in viewController: KeyboardViewController) {
        super.init()
        actions = actions(in: viewController)
    }
    
    func bottomActions(in vc: KeyboardViewController) -> KeyboardActionRows {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return [[
                .nextKeyboard,
                .keyboardType(.alphabetic(.lowercased)),
                .character("0"),
                .space,
                .keyboardType(.symbolic),
                .moveCursorBackward,
                .moveCursorForward
            ]]
        } else {
            return [[
                .keyboardType(.alphabetic(.lowercased)),
                .character("0"),
                .keyboardType(.symbolic),
                .space,
                .newLine
            ]]
        }
    }
    
    func actions(in viewController: KeyboardViewController) -> KeyboardActionRows {
        KeyboardActionRows(anything: characters())
    }
    
    func characters() -> [[Any]] {
        if UIDevice.current.userInterfaceIdiom != .pad {
            return [
                ["*", "7", "8", "9", "+"],
                ["-", "4", "5", "6", "/"],
                [".", "1", "2", "3", "="]
            ]
        } else {
            return [
                [KeyboardAction.tab, "*", "7", "8", "9", KeyboardAction.backspace],
                [               "/", "-", "4", "5", "6", "="],
                [               "+", ".", "1", "2", "3", KeyboardAction.newLine]
            ]
        }
    }
}

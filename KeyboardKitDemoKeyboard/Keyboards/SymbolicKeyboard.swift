//
//  SymbolicKeyboard.swift
//  KeyboardKitExampleKeyboard
//
//  Created by Daniel Saidi on 2019-05-13.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import KeyboardKit
import UIKit

/**
 This demo keyboard mimicks an English symbolic keyboard.
 */
struct SymbolicKeyboard: DemoKeyboard {
    
    init(in viewController: KeyboardViewController) {
        actions = type(of: self).actions(in: viewController)
    }
    
    let actions: KeyboardActionRows
    
    static func bottomActions(in vc: KeyboardViewController) -> KeyboardActionRows {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return [[
                .nextKeyboard,
                .keyboardType(.numeric),
                .shift(currentState: .lowercased),
                .space,
                .keyboardType(.alphabetic(.lowercased)),
                .moveCursorBackward,
                .moveCursorForward
            ]]
        } else {
            return [[
                .keyboardType(.numeric),
                .shift(currentState: .lowercased),
                .keyboardType(.alphabetic(.lowercased)),
                .space,
                .newLine
            ]]
        }
    }
}

private extension SymbolicKeyboard {
    
    static func actions(in viewController: KeyboardViewController) -> KeyboardActionRows {
        KeyboardActionRows(anything: characters())
    }
    
    static func characters() -> [[Any]] {
    
        if UIDevice.current.userInterfaceIdiom == .pad {
        return [
            [KeyboardAction.tab, "-", "<", "$", ">", "@", "`", "[", "_", "]", ";", KeyboardAction.backspace],
            ["-", "\\", "(", "\"", ")", "#", "%", "{", "=", "}", "|", "'"],
            [KeyboardAction.escape, ";", ":", "*", "+", "/", ".", "&", "^", "~", "?", KeyboardAction.newLine]
        ]
        } else {
        return [
            ["-", "<", "$", ">", "@", "`", "[", "_", "]", KeyboardAction.backspace],
            ["\\", "(", "\"", ")", "#", "%", "{", "=", "}", "|"],
            [";", ":", "*", "+", "/", ".", "&", "^", "~", "?"]
        ]
        }
    
    }

}

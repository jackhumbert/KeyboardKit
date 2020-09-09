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
struct NumericKeyboard: DemoKeyboard {
    
    init(in viewController: KeyboardViewController) {
        actions = type(of: self).actions(in: viewController)
    }
    
    let actions: KeyboardActionRows
    
    static func bottomActions(in vc: KeyboardViewController) -> KeyboardActionRows {
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
}

private extension NumericKeyboard {
    
    static func actions(in viewController: KeyboardViewController) -> KeyboardActionRows {
        KeyboardActionRows(characters: characters)
            .addingSideActions()
    }
    
    static let characters: [[String]] = [
        ["*", "7", "8", "9", "+"],
        ["-", "4", "5", "6", "/"],
        [".", "1", "2", "3", "="]
    ]
}

private extension Sequence where Iterator.Element == KeyboardActionRow {
    
    func addingSideActions() -> [Iterator.Element] {
        var actions = map { $0 }
//        actions[2].insert(.keyboardType(.symbolic), at: 0)
//        actions[2].insert(.none, at: 1)
//        actions[2].append(.none)
//        actions[2].append(.backspace)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
        
            actions[0].insert(.tab, at: 0)
            actions[1].insert(.character("/"), at: 0)
            actions[2].insert(.character("*"), at: 0)
            actions[0].append(.backspace)
            actions[1].append(.character("+"))
            actions[2].append(.newLine)
        }
        return actions
    }
}

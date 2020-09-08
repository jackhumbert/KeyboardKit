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
                .space,
                .keyboardType(.alphabetic(.lowercased))
            ]]
        }
    }
}

private extension SymbolicKeyboard {
    
    static func actions(in viewController: KeyboardViewController) -> KeyboardActionRows {
        KeyboardActionRows(characters: characters)
            .addingSideActions()
    }
    
    static var characters: [[String]] = [
        ["-", "<", "$", ">", "@", "`", "[", "_", "]"],
        ["\\", "(", "\"", ")", "#", "%", "{", "=", "}", "|"],
        [";", ":", "*", "+", "/", ".", "&", "^", "~"]
    ]
    
}

private extension Sequence where Iterator.Element == KeyboardActionRow {
    
    func addingSideActions() -> [Iterator.Element] {
        var actions = map { $0 }
//        actions[2].insert(.keyboardType(.numeric), at: 0)
//        actions[2].insert(.none, at: 1)
//        actions[2].append(.none)
//        actions[2].append(.backspace)
        if UIDevice.current.userInterfaceIdiom == .pad {
            actions[0].insert(.tab, at: 0)
            actions[1].insert(.character("-"), at: 0)
            actions[2].insert(.escape, at: 0)
            
            actions[0].append(.character(";"))
            actions[1].append(.character("'"))
            actions[2].append(.character("/"))
        }
        actions[0].append(.backspace)
        actions[2].append(.newLine)
        return actions
    }
}

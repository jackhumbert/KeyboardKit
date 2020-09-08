//
//  AlphabeticKeyboard.swift
//  KeyboardKitExampleKeyboard
//
//  Created by Daniel Saidi on 2019-05-13.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import KeyboardKit
import UIKit

/**
 This demo keyboard mimicks an English alphabetic keyboard.
 */
struct AlphabeticKeyboard: DemoKeyboard {
    
    init(uppercased: Bool, in viewController: KeyboardViewController) {
        actions = AlphabeticKeyboard.actions(
            uppercased: uppercased,
            in: viewController)
    }

    var actions: KeyboardActionRows
    
    static func bottomActions(uppercased: Bool, in vc: KeyboardViewController) -> KeyboardActionRows {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return [[
                .nextKeyboard,
                .keyboardType(.numeric),
                .shift(currentState: uppercased ? .uppercased : .lowercased),
                .space,
                .keyboardType(.symbolic),
                .moveCursorBackward,
                .moveCursorForward
            ]]
        } else {
            return [[
                .keyboardType(.numeric),
                .shift(currentState: uppercased ? .uppercased : .lowercased),
                .space,
                .keyboardType(.symbolic)
            ]]
        }
    }
}


private extension AlphabeticKeyboard {
    
    static func actions(
        uppercased: Bool,
        in viewController: KeyboardViewController) -> KeyboardActionRows {
        KeyboardActionRows(characters: characters(uppercased: uppercased))
            .addingSideActions(uppercased: uppercased)
    }
    
    static func keys(uppercased: Bool) -> [[KeyboardAction]] {
        return [
        [
            .character("Q"),
            .character("W"),
        ]
        ]
    }
    
    static func characters(uppercased: Bool) -> [[String]] {
    
        if UIDevice.current.userInterfaceIdiom == .pad {
            if uppercased {
            
            return  [["Q", "W", "F", "P", "G", "J", "L", "U", "Y"],
                     ["A", "R", "S", "T", "D", "H", "N", "E", "I", "O"],
                     ["Z", "X", "C", "V", "B", "K", "M", "!", "?"]]
            } else {
            return  [["q", "w", "f", "p", "g", "j", "l", "u", "y"],
                     ["a", "r", "s", "t", "d", "h", "n", "e", "i", "o"],
                     ["z", "x", "c", "v", "b", "k", "m", ",", "."]]
            }
        } else {
            if uppercased {
            
            return  [["Q", "W", "F", "P", "G", "J", "L", "U", "Y"],
                     ["A", "R", "S", "T", "D", "H", "N", "E", "I", "O"],
                     ["Z", "X", "C", "V", "B", "K", "M", "!", "?"]]
            } else {
            return  [["q", "w", "f", "p", "g", "j", "l", "u", "y"],
                     ["a", "r", "s", "t", "d", "h", "n", "e", "i", "o"],
                     ["z", "x", "c", "v", "b", "k", "m", ",", "'"]]
            }
        }
    }
}

private extension Sequence where Iterator.Element == KeyboardActionRow {
    
    func addingSideActions(uppercased: Bool) -> [Iterator.Element] {
        var actions = map { $0 }
//        actions[2].insert(.keyboardType(.symbolic), at: 0)
//        actions[2].insert(.none, at: 1)
//        actions[2].append(.none)
        if UIDevice.current.userInterfaceIdiom == .pad {
            actions[0].insert(.tab, at: 0)
            actions[1].insert(.character("-"), at: 0)
            actions[2].insert(.escape, at: 0)
            if uppercased {
                actions[0].append(.character(":"))
                actions[1].append(.character("`"))
                actions[2].append(.character("@"))
            } else {
                actions[0].append(.character(";"))
                actions[1].append(.character("'"))
                actions[2].append(.character("/"))
            }
        }
        actions[0].append(.backspace)
        actions[2].append(.newLine)
        return actions
    }
}

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
class AlphabeticKeyboard: DemoKeyboard {
    
    init(uppercased: Bool, in viewController: KeyboardViewController) {
        super.init()
        actions = actions(
            uppercased: uppercased,
            in: viewController)
    }
    
    func bottomActions(uppercased: Bool, in vc: KeyboardViewController) -> KeyboardActionRows {
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
                .keyboardType(.symbolic),
                .space,
                .newLine
            ]]
        }
    }
    
    func actions(
        uppercased: Bool,
        in viewController: KeyboardViewController) -> KeyboardActionRows {
        KeyboardActionRows(anything: characters(uppercased: uppercased))
    }
    
    
    func characters(uppercased: Bool) -> [[Any]] {
    
        if UIDevice.current.userInterfaceIdiom == .pad {
            if uppercased {
            return  [[KeyboardAction.tab,    "Q", "W", "F", "P", "G", "J", "L", "U", "Y", ":", KeyboardAction.backspace],
                     [                  "_", "A", "R", "S", "T", "D", "H", "N", "E", "I", "O", "\""],
                     [KeyboardAction.escape, "Z", "X", "C", "V", "B", "K", "M", "!", "@", "?", KeyboardAction.newLine]]
            } else {
            return  [[KeyboardAction.tab,    "q", "w", "f", "p", "g", "j", "l", "u", "y", ";", KeyboardAction.backspace],
                     [                  "-", "a", "r", "s", "t", "d", "h", "n", "e", "i", "o", "'"],
                     [KeyboardAction.escape, "z", "x", "c", "v", "b", "k", "m", ",", ".", "/", KeyboardAction.newLine]]
            }
        } else {
//            if uppercased {
//            return  [["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
//                     ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
//                     ["Z", "X", "C", "V", "B", "N", "M", "!", "?"]]
//            } else {
//            return  [["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
//                     ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
//                     ["z", "x", "c", "v", "b", "n", "m", ",", "'"]]
//            }
            if uppercased {
            return  [["Q", "W", "F", "P", "G", "J", "L", "U", "Y", KeyboardAction.backspace],
                     ["A", "R", "S", "T", "D", "H", "N", "E", "I", "O"],
                     ["Z", "X", "C", "V", "B", "K", "M", "!", "\"","?"]]
            } else {
            return  [["q", "w", "f", "p", "g", "j", "l", "u", "y", KeyboardAction.backspace],
                     ["a", "r", "s", "t", "d", "h", "n", "e", "i", "o"],
                     ["z", "x", "c", "v", "b", "k", "m", ",", "'", "-"]]
            }
//            if uppercased {
//            return  [["M", "B", "W", "H",   "G", "T", "O", "J"],
//                     ["P", "\"", "X", "C",   "I", "E", KeyboardAction.space, "U"],
//                     ["R", "Y", "S", "Z",   "K", "A", "L", "Q"],
//                     ["D", "N", "F", "V",   "!", "@", "?", KeyboardAction.backspace]]
//            } else {
//            return  [["m", "b", "w", "h",   "g", "t", "o", "j"],
//                     ["p", "'", "x", "c",   "i", "e", KeyboardAction.space, "u"],
//                     ["r", "y", "s", "z",   "k", "a", "l", "q"],
//                     ["d", "n", "f", "v",   ",", ".", "/", KeyboardAction.backspace]]
//            }
        }
    }
}

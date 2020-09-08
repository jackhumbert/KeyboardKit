//
//  KeyboardActionRows+Extra.swift
//  KeyboardKitDemoKeyboard
//
//  Created by Jack Humbert on 9/8/20.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import KeyboardKit
import Foundation

public extension KeyboardActionRows {
    /**
     Map string arrays to rows of `character` actions.
    */
    init(anything: [[Any]]) {
        var actionRows: KeyboardActionRows = []
        for row in anything {
            var actionRow: KeyboardActionRow = []
            for input in row {
                var action: KeyboardAction = .none
                if input is KeyboardAction {
                    action = input as! KeyboardAction
                }
                if input is String {
                    action = .character(input as! String)
                }
                actionRow.append(action)
            }
            actionRows.append(actionRow)
        }
        self = actionRows
    }
}

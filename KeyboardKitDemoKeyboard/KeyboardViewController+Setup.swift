//
//  KeyboardViewController+Setup.swift
//  KeyboardKitDemoKeyboard
//
//  Created by Daniel Saidi on 2019-10-15.
//  Copyright © 2018 Daniel Saidi. All rights reserved.
//

import KeyboardKit
import UIKit

extension KeyboardViewController {
    
    func setupKeyboard(for size: CGSize) {
        DispatchQueue.main.async {
            self.setupKeyboardAsync(for: size)
        }
    }
}

private extension KeyboardViewController {
    
    func setupKeyboardAsync(for size: CGSize) {
        if bottomRowThing != nil {
            for view in keyboardStackView.arrangedSubviews {
                if (view != bottomRowThing!) {
                    keyboardStackView.removeArrangedSubview(view)
                    view.removeFromSuperview()
                }
            }
        } else {
            keyboardStackView.removeAllArrangedSubviews()
        }
        switch context.keyboardType {
        case .alphabetic(let state): setupAlphabeticKeyboard(for: state)
        case .numeric: setupNumericKeyboard()
        case .symbolic: setupSymbolicKeyboard()
        default: return
        }
    }
    
    func setupBottomRow(rows: inout [KeyboardStackViewComponent], newBottomActions: KeyboardActionRows) {
        if bottomRow.isEmpty {
            let bottom = newBottomActions.map {
                buttonRowBottom(for: $0, distribution: .fillProportionally)
            }
            bottomRowThing = bottom[0]
            rows.append(bottom[0])
        } else {
            for (index, button) in bottomRow.enumerated() {
                button.setup(with: (newBottomActions as [[KeyboardAction]])[0][index], in: self, distribution: .fillProportionally)
            }
        }
        var bottomRowHeight: CGFloat = 0
        if UIDevice.current.userInterfaceIdiom == .pad {
            if deviceOrientation.isLandscape {
                bottomRowHeight = 90
            } else {
                bottomRowHeight = 66
            }
        } else {
            bottomRowHeight = 53
        }
        if bottomRowThing!.heightConstraint != nil {
            bottomRowThing!.heightConstraint?.constant = bottomRowHeight
        } else {
            bottomRowThing!.addConstraint(NSLayoutConstraint(item: bottomRowThing!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: bottomRowHeight))
        }
    }
    
    func setupRows(keyboard: DemoKeyboard) -> [KeyboardStackViewComponent] {
        let rows = buttonRows(for: keyboard.actions, distribution: .fillProportionally)
        var rowHeight: CGFloat = 0
        if UIDevice.current.userInterfaceIdiom == .pad {
            if deviceOrientation.isLandscape {
                rowHeight = 90
            } else {
                rowHeight = 66
            }
        } else {
            rowHeight = 54
        }
        for row in rows {
            row.addConstraints([
                NSLayoutConstraint(item: row, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: rowHeight)
            ])
        }
        return rows
    }
    
    func setupAllRows(rows: [KeyboardStackViewComponent]) {
        for (index, row) in rows.enumerated() {
            keyboardStackView.insertArrangedSubview(row, at: index)
            var rowPadding: CGFloat = 0
            if UIDevice.current.userInterfaceIdiom == .pad {
                if deviceOrientation.isLandscape {
                    rowPadding = 7
                } else {
                    rowPadding = 5
                }
            }
            if keyboardStackView.leftConstraint == nil {
                keyboardStackView.addConstraints([
                    NSLayoutConstraint(item: row, attribute: .left, relatedBy: .equal, toItem: keyboardStackView, attribute: .left, multiplier: 1, constant: rowPadding),
                    NSLayoutConstraint(item: keyboardStackView, attribute: .right, relatedBy: .equal, toItem: row, attribute: .right, multiplier: 1, constant: rowPadding)
                ])
            } else {
                keyboardStackView.leftConstraint?.constant = rowPadding
                keyboardStackView.rightConstraint?.constant = rowPadding
            }
        }
    }
    
    func setupAlphabeticKeyboard(for state: KeyboardShiftState) {
        let keyboard = AlphabeticKeyboard(uppercased: state.isUppercased, in: self)
        let newBottomActions = keyboard.bottomActions(uppercased: state.isUppercased, in: self)
        var rows = setupRows(keyboard: keyboard)
        setupBottomRow(rows: &rows, newBottomActions: newBottomActions)
        setupAllRows(rows: rows)
    }

    func setupNumericKeyboard() {
        let keyboard = NumericKeyboard(in: self)
        let newBottomActions = keyboard.bottomActions(in: self)
        var rows = setupRows(keyboard: keyboard)
        setupBottomRow(rows: &rows, newBottomActions: newBottomActions)
        setupAllRows(rows: rows)
    }
    
    func setupSymbolicKeyboard() {
        let keyboard = SymbolicKeyboard(in: self)
        let newBottomActions = keyboard.bottomActions(in: self)
        var rows = setupRows(keyboard: keyboard)
        setupBottomRow(rows: &rows, newBottomActions: newBottomActions)
        setupAllRows(rows: rows)
    }
}

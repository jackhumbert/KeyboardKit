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
            if UIDevice.current.userInterfaceIdiom == .pad {
                bottom[0].addConstraint(NSLayoutConstraint(item: bottom[0], attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 90))
            } else {
                bottom[0].addConstraint(NSLayoutConstraint(item: bottom[0], attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 53))
            }
            rows.append(bottom[0])
        } else {
            for (index, button) in bottomRow.enumerated() {
                button.setup(with: (newBottomActions as [[KeyboardAction]])[0][index], in: self, distribution: .fillProportionally)
            }
        }
    }
    
    func setupAlphabeticKeyboard(for state: KeyboardShiftState) {
        let keyboard = AlphabeticKeyboard(uppercased: state.isUppercased, in: self)
        var rows = buttonRows(for: keyboard.actions, distribution: .fillProportionally)
        let newBottomActions = AlphabeticKeyboard.bottomActions(uppercased: state.isUppercased, in: self)
        setupBottomRow(rows: &rows, newBottomActions: newBottomActions)
        for (index, row) in rows.enumerated() {
            keyboardStackView.insertArrangedSubview(row, at: index)
            if UIDevice.current.userInterfaceIdiom == .pad {
                keyboardStackView.addConstraints([
                    NSLayoutConstraint(item: row, attribute: .left, relatedBy: .equal, toItem: keyboardStackView, attribute: .left, multiplier: 1, constant: 7),
                    NSLayoutConstraint(item: keyboardStackView, attribute: .right, relatedBy: .equal, toItem: row, attribute: .right, multiplier: 1, constant: 7)
                ])
            }
        }
    }

    func setupNumericKeyboard() {
        let keyboard = NumericKeyboard(in: self)
        var rows = buttonRows(for: keyboard.actions, distribution: .fillProportionally)
        let newBottomActions = NumericKeyboard.bottomActions(in: self)
        setupBottomRow(rows: &rows, newBottomActions: newBottomActions)
        for (index, row) in rows.enumerated() {
            keyboardStackView.insertArrangedSubview(row, at: index)
            if UIDevice.current.userInterfaceIdiom == .pad {
                keyboardStackView.addConstraints([
                    NSLayoutConstraint(item: row, attribute: .left, relatedBy: .equal, toItem: keyboardStackView, attribute: .left, multiplier: 1, constant: 7),
                    NSLayoutConstraint(item: keyboardStackView, attribute: .right, relatedBy: .equal, toItem: row, attribute: .right, multiplier: 1, constant: 7)
                ])
            }
        }
    }
    
    func setupSymbolicKeyboard() {
        let keyboard = SymbolicKeyboard(in: self)
        var rows = buttonRows(for: keyboard.actions, distribution: .fillProportionally)
        let newBottomActions = SymbolicKeyboard.bottomActions(in: self)
        setupBottomRow(rows: &rows, newBottomActions: newBottomActions)
        for (index, row) in rows.enumerated() {
            keyboardStackView.insertArrangedSubview(row, at: index)
            if UIDevice.current.userInterfaceIdiom == .pad {
                keyboardStackView.addConstraints([
                    NSLayoutConstraint(item: row, attribute: .left, relatedBy: .equal, toItem: keyboardStackView, attribute: .left, multiplier: 1, constant: 7),
                    NSLayoutConstraint(item: keyboardStackView, attribute: .right, relatedBy: .equal, toItem: row, attribute: .right, multiplier: 1, constant: 7)
                ])
            }
        }
    }
}

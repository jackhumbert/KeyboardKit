//
//  DemoKeyboardActionHandler.swift
//  KeyboardKitExampleKeyboard
//
//  Created by Daniel Saidi on 2019-04-24.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import KeyboardKit
import UIKit

/**
 This action handler inherits `StandardKeyboardActionHandler`
 and adds demo-specific functionality to it.
 */
class DemoKeyboardActionHandler: StandardKeyboardActionHandler {
    
    
    // MARK: - Initialization
    
    public init(inputViewController: KeyboardInputViewController) {
        super.init(
            inputViewController: inputViewController,
            hapticConfiguration: .standard
        )
    }
    
    
    // MARK: - Properties
        
    private var demoViewController: KeyboardViewController? {
        inputViewController as? KeyboardViewController
    }
    
    
    // MARK: - Actions
    
    
    override func longPressAction(for action: KeyboardAction, sender: Any?) -> GestureAction? {
        switch action {
        default: return super.longPressAction(for: action, sender: sender)
        }
    }
    
    override func tapAction(for action: KeyboardAction, sender: Any?) -> GestureAction? {
        switch action {
        case .space: return handleSpace(for: sender)
        case .shift(let currentState): return { [weak self] in
            switch currentState {
            case .lowercased: self?.inputViewController?.changeKeyboardType(to: .alphabetic(.uppercased))
            case .uppercased: self?.inputViewController?.changeKeyboardType(to: .alphabetic(.lowercased))
            case .capsLocked: self?.inputViewController?.changeKeyboardType(to: .alphabetic(.lowercased))
            }
        }
        default: return super.tapAction(for: action, sender: sender)
        }
    }
    
    // MARK: - Action Handling
    
    override func handle(_ gesture: KeyboardGesture, on action: KeyboardAction, sender: Any?) {
        guard let gestureAction = self.action(for: gesture, on: action, sender: sender) else { return }
        gestureAction()
            
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            let buttonView = (sender as? DemoButton)?.buttonView
//            let backgroundColor = buttonView?.backgroundColor
//            UIView.animate(
//                withDuration: 0.1,
//                delay: 0,
//                options: [.curveEaseOut, .allowUserInteraction],
//                animations: { buttonView?.backgroundColor = .darkGray },
//                completion: { (finished: Bool) in
//                    buttonView?.backgroundColor = backgroundColor
//                }
//            )
//        } else {
//            var transform = CGAffineTransform(translationX: 0.0, y: -50.0)
//            transform = transform.scaledBy(x: 1.1, y: 1.1)
//            let buttonView = (sender as? DemoButton)?.buttonView
//            let backgroundColor = buttonView?.backgroundColor
//            UIView.animate(
//                withDuration: 0.1,
//                delay: 0,
//                options: [.curveEaseOut, .allowUserInteraction],
//                animations: {
//                    buttonView?.transform = transform
//                    buttonView?.backgroundColor = .darkGray
//                },
//                completion: { (finished: Bool) in
//                    buttonView?.transform = .identity
//                    buttonView?.backgroundColor = backgroundColor
//                }
//            )
//        }
//
//        triggerHapticFeedback(for: gesture, on: action, sender: sender)
        handleKeyboardSwitch(after: gesture, on: action)
        demoViewController?.requestAutocompleteSuggestions()
    }
}

// MARK: - Actions

private extension DemoKeyboardActionHandler {
    
    func alert(_ message: String) {
        guard let input = inputViewController as? KeyboardViewController else { return }
        input.alerter.alert(message: message, in: input.view, withDuration: 4)
    }
    
    /**
     `NOTE` Changing to alphabetic lower case should be done
     in `StandardKeyboardActionHandler`.
     */
    func handleSpace(for sender: Any?) -> GestureAction {
        let baseAction = super.tapAction(for: .space, sender: sender)
        return { [weak self] in
            baseAction?()
            let type = self?.demoViewController?.context.keyboardType
            if type?.isAlphabetic == true { return }
            self?.inputViewController?.changeKeyboardType(to: .alphabetic(.lowercased))
        }
    }
    
}

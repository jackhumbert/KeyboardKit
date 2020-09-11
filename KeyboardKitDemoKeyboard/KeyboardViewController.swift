//
//  KeyboardViewController.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2018-03-04.
//  Copyright © 2018 Daniel Saidi. All rights reserved.
//

import UIKit
import KeyboardKit

/**
 This UIKit-based demo keyboard demonstrates how to create a
 keyboard extension using `KeyboardKit` and `UIKit`.
 
 This keyboard sends text and emoji inputs to the text proxy,
 copies tapped images to the device's pasteboard, saves long
 pressed images to photos etc. It also adds an auto complete
 toolbar that provides fake suggestions for the current word.
 
 `IMPORTANT` To use this keyboard, you must enable it in the
 system keyboard settings ("Settings/General/Keyboards") and
 give it full access, which is unfortunately required to use
 some features like haptic and audio feedback, let it access
 the user's photos etc.
 
 If you want to use these features in your own app, you must
 add `RequestsOpenAccess` to the extension's `Info.plist` to
 make it possible for the user to enable full access. If you
 want to allow the keyboard to access the user's photo album,
 you must add the `NSPhotoLibraryAddUsageDescription` key to
 the **host** application's `Info.plist`. Have a look at the
 demo app and extension and copy the parts that you need.
 */
class KeyboardViewController: KeyboardInputViewController {
    
    var gestureRecognizer: MultitouchGestureRecognizer?
    var lastCharacter: Character = " "
    
    let characterLUT: [[CGFloat]] = [
[ 0.769, 0.285, 0.294, 0.172, 0.134, 0.277, 0.118, 0.262, 0.382, 0.025, 0.027, 0.153, 0.202, 0.117, 0.428, 0.261, 0.010, 0.170, 0.422, 1.000, 0.065, 0.042, 0.366, 0.000, 0.065, 0.001 ],
[ 0.001, 0.054, 0.127, 0.109, 0.004, 0.023, 0.061, 0.009, 0.119, 0.005, 0.050, 0.294, 0.098, 0.543, 0.001, 0.041, 0.001, 0.345, 0.253, 0.399, 0.035, 0.067, 0.023, 0.006, 0.110, 0.006 ],
[ 0.056, 0.005, 0.000, 0.000, 0.170, 0.000, 0.000, 0.000, 0.031, 0.002, 0.000, 0.054, 0.001, 0.000, 0.057, 0.000, 0.000, 0.027, 0.008, 0.002, 0.049, 0.001, 0.000, 0.000, 0.036, 0.000 ],
[ 0.137, 0.000, 0.022, 0.000, 0.170, 0.000, 0.000, 0.151, 0.068, 0.000, 0.059, 0.039, 0.000, 0.000, 0.198, 0.000, 0.001, 0.038, 0.004, 0.098, 0.036, 0.000, 0.000, 0.000, 0.010, 0.000 ],
[ 0.066, 0.001, 0.001, 0.017, 0.186, 0.001, 0.009, 0.002, 0.115, 0.001, 0.000, 0.010, 0.005, 0.008, 0.063, 0.000, 0.000, 0.028, 0.037, 0.001, 0.032, 0.005, 0.003, 0.000, 0.015, 0.000 ],
[ 0.240, 0.015, 0.125, 0.302, 0.129, 0.037, 0.034, 0.009, 0.049, 0.001, 0.014, 0.149, 0.088, 0.374, 0.025, 0.046, 0.007, 0.574, 0.335, 0.132, 0.004, 0.065, 0.052, 0.046, 0.052, 0.003 ],
[ 0.041, 0.000, 0.000, 0.000, 0.062, 0.048, 0.000, 0.000, 0.081, 0.000, 0.000, 0.013, 0.000, 0.000, 0.153, 0.000, 0.000, 0.057, 0.002, 0.025, 0.026, 0.000, 0.000, 0.000, 0.002, 0.000 ],
[ 0.051, 0.000, 0.000, 0.001, 0.111, 0.000, 0.008, 0.076, 0.038, 0.000, 0.000, 0.013, 0.001, 0.016, 0.054, 0.000, 0.000, 0.046, 0.017, 0.004, 0.021, 0.000, 0.000, 0.000, 0.005, 0.000 ],
[ 0.270, 0.002, 0.000, 0.002, 0.796, 0.000, 0.000, 0.000, 0.181, 0.000, 0.000, 0.005, 0.003, 0.008, 0.146, 0.000, 0.000, 0.029, 0.004, 0.041, 0.022, 0.000, 0.002, 0.000, 0.009, 0.000 ],
[ 0.078, 0.020, 0.177, 0.117, 0.097, 0.042, 0.081, 0.000, 0.001, 0.001, 0.022, 0.165, 0.079, 0.681, 0.174, 0.023, 0.002, 0.089, 0.268, 0.296, 0.003, 0.078, 0.000, 0.007, 0.000, 0.017 ],
[ 0.003, 0.000, 0.000, 0.000, 0.007, 0.000, 0.000, 0.000, 0.001, 0.000, 0.000, 0.000, 0.000, 0.000, 0.014, 0.000, 0.000, 0.000, 0.000, 0.000, 0.018, 0.000, 0.000, 0.000, 0.000, 0.000 ],
[ 0.007, 0.000, 0.000, 0.000, 0.098, 0.001, 0.000, 0.001, 0.041, 0.000, 0.000, 0.004, 0.000, 0.013, 0.003, 0.000, 0.000, 0.001, 0.022, 0.000, 0.001, 0.000, 0.001, 0.000, 0.004, 0.000 ],
[ 0.144, 0.003, 0.003, 0.083, 0.242, 0.010, 0.001, 0.002, 0.183, 0.000, 0.009, 0.218, 0.009, 0.002, 0.114, 0.009, 0.000, 0.003, 0.046, 0.032, 0.031, 0.009, 0.004, 0.000, 0.100, 0.001 ],
[ 0.126, 0.031, 0.000, 0.000, 0.228, 0.001, 0.000, 0.000, 0.083, 0.000, 0.000, 0.001, 0.032, 0.002, 0.086, 0.060, 0.000, 0.000, 0.021, 0.000, 0.028, 0.000, 0.000, 0.000, 0.015, 0.000 ],
[ 0.085, 0.002, 0.098, 0.354, 0.205, 0.016, 0.317, 0.002, 0.110, 0.005, 0.022, 0.015, 0.011, 0.035, 0.104, 0.001, 0.001, 0.002, 0.118, 0.291, 0.022, 0.016, 0.002, 0.000, 0.030, 0.001 ],
[ 0.027, 0.024, 0.043, 0.046, 0.011, 0.234, 0.022, 0.007, 0.031, 0.004, 0.026, 0.111, 0.168, 0.481, 0.092, 0.076, 0.000, 0.386, 0.081, 0.124, 0.298, 0.064, 0.102, 0.004, 0.013, 0.001 ],
[ 0.083, 0.001, 0.001, 0.001, 0.126, 0.000, 0.000, 0.015, 0.033, 0.000, 0.000, 0.079, 0.005, 0.000, 0.090, 0.039, 0.000, 0.104, 0.012, 0.019, 0.030, 0.000, 0.000, 0.000, 0.002, 0.000 ],
[ 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.026, 0.000, 0.000, 0.000, 0.000, 0.000 ],
[ 0.167, 0.008, 0.035, 0.066, 0.484, 0.009, 0.031, 0.003, 0.194, 0.000, 0.045, 0.025, 0.037, 0.056, 0.200, 0.008, 0.000, 0.034, 0.138, 0.121, 0.038, 0.020, 0.005, 0.000, 0.076, 0.000 ],
[ 0.086, 0.003, 0.037, 0.008, 0.222, 0.003, 0.001, 0.086, 0.138, 0.000, 0.014, 0.015, 0.011, 0.007, 0.106, 0.048, 0.002, 0.003, 0.098, 0.321, 0.064, 0.001, 0.005, 0.000, 0.008, 0.000 ],
[ 0.155, 0.003, 0.013, 0.001, 0.316, 0.002, 0.001, 0.864, 0.288, 0.000, 0.000, 0.026, 0.009, 0.004, 0.365, 0.001, 0.000, 0.104, 0.100, 0.055, 0.057, 0.000, 0.021, 0.000, 0.074, 0.002 ],
[ 0.033, 0.025, 0.043, 0.029, 0.040, 0.004, 0.038, 0.000, 0.027, 0.000, 0.002, 0.082, 0.037, 0.135, 0.002, 0.054, 0.000, 0.155, 0.122, 0.137, 0.000, 0.001, 0.000, 0.001, 0.003, 0.001 ],
[ 0.027, 0.000, 0.000, 0.000, 0.253, 0.000, 0.000, 0.000, 0.076, 0.000, 0.000, 0.000, 0.000, 0.000, 0.019, 0.000, 0.000, 0.000, 0.000, 0.000, 0.001, 0.000, 0.000, 0.000, 0.002, 0.000 ],
[ 0.114, 0.001, 0.001, 0.001, 0.098, 0.000, 0.000, 0.077, 0.124, 0.000, 0.000, 0.003, 0.001, 0.028, 0.068, 0.000, 0.000, 0.006, 0.015, 0.002, 0.000, 0.000, 0.000, 0.000, 0.001, 0.000 ],
[ 0.006, 0.000, 0.006, 0.000, 0.006, 0.000, 0.000, 0.001, 0.006, 0.000, 0.000, 0.000, 0.000, 0.000, 0.001, 0.016, 0.000, 0.000, 0.000, 0.010, 0.002, 0.000, 0.000, 0.000, 0.000, 0.000 ],
[ 0.008, 0.003, 0.002, 0.002, 0.043, 0.000, 0.000, 0.000, 0.010, 0.000, 0.000, 0.006, 0.006, 0.003, 0.048, 0.003, 0.000, 0.002, 0.028, 0.004, 0.000, 0.000, 0.002, 0.000, 0.000, 0.000 ],
[ 0.005, 0.000, 0.000, 0.000, 0.016, 0.000, 0.000, 0.000, 0.003, 0.000, 0.000, 0.001, 0.000, 0.000, 0.003, 0.000, 0.000, 0.000, 0.000, 0.000, 0.001, 0.000, 0.000, 0.000, 0.001, 0.002 ]
   ]
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context.actionHandler = DemoKeyboardActionHandler(inputViewController: self)
        view.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        setupKeyboard()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupKeyboard()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupKeyboard(for: size)
    }
    
    // MARK: - Keyboard Functionality
    
    override func setupKeyboard() {
        setupKeyboard(for: view.bounds.size)
        
         if gestureRecognizer == nil {
            gestureRecognizer = MultitouchGestureRecognizer()
            gestureRecognizer?.delegate = self
            
//            gestureRecognizer?.mode = .stack
//            gestureRecognizer?.count = 4
            gestureRecognizer?.sustain = false
            view.addGestureRecognizer(gestureRecognizer!)
        }
    }
    
    override func selectionWillChange(_ textInput: UITextInput?) {
        super.selectionWillChange(textInput)
        autocompleteToolbar.reset()
    }
    
    override func selectionDidChange(_ textInput: UITextInput?) {
        super.selectionDidChange(textInput)
        autocompleteToolbar.reset()
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        super.textDidChange(textInput)
        requestAutocompleteSuggestions()
    }
    
    
    // MARK: - Properties
    
    let alerter = ToastAlert()
    
    var bottomRow: [DemoButton] = []
    var bottomRowThing: KeyboardStackViewComponent?
    public var currentKeys: [DemoButton] = []
    
    // MARK: - Helper functions
        
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    
    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }

    // MARK: - Autocomplete
    
    lazy var autocompleteProvider = DemoAutocompleteSuggestionProvider()
    
    lazy var autocompleteToolbar: AutocompleteToolbarView = {
        AutocompleteToolbarView(textDocumentProxy: textDocumentProxy)
    }()
    
    override func addKeyboardGestures(to button: KeyboardButton) {
//        button.gestureRecognizers?.forEach { button.removeGestureRecognizer($0) }

//        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap2))
//        gesture.numberOfTapsRequired = 2
//        gesture.delegate = self
//        button.addGestureRecognizer(gesture)
        
        if button.action == .nextKeyboard { return addNextKeyboardGesture2(to: button) }
    }
    
    @objc func handleDoubleTap2(_ gesture: UIGestureRecognizer) {
        guard let button = gesture.view as? KeyboardButton else { return }
        context.actionHandler.handle(.doubleTap, on: button.action, sender: button)
    }
    
    func addNextKeyboardGesture2(to button: KeyboardButton) {
        guard let button = button as? UIButton else { return }
        setupNextKeyboardButton(button)
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return [.left, .bottom, .right]
    }
    
}

// MARK: - Multitouch gesture recognizer delegate

extension KeyboardViewController: MultitouchGestureRecognizerDelegate {

    func multitouchGestureRecognizer(_ gestureRecognizer: MultitouchGestureRecognizer, touchDidBegin touch: UITouch) {
        let currentLocation = touch.preciseLocation(in: view)
        var closestButton: DemoButton?
        var closestDistance: CGFloat = 10000
        for v in view.subviews {
            for a in v.subviews {
                for c in a.subviews {
                    for b in c.subviews {
                        if b is DemoButton {
                            let button = b as! DemoButton
                            let center = button.superview!.convert(button.center, to: view)
                            var distance = CGPointDistance(from: center, to: currentLocation)
                            if lastCharacter.isASCII && button.character != nil && button.character != " " {
                                var a: Int = 0
                                if lastCharacter != " " {
                                    a = Int(lastCharacter.asciiValue! - 96)
                                }
                                let b = Int(button.character!.asciiValue! - 97)
                                distance = max(distance - (characterLUT[a][b]) * 30.0, 0.0)
                            }
                            if (distance < closestDistance) {
                                closestDistance = distance
                                closestButton = button
                            }
                        }
                    }
                }
            }
        }
        if closestButton != nil {
            if closestButton!.character != nil {
                lastCharacter = closestButton!.character!
            }
            closestButton!.handleBegin(touch: touch)
        }
    }
    
    func multitouchGestureRecognizer(_ gestureRecognizer: MultitouchGestureRecognizer, touchDidMove touch: UITouch) {
       for button in currentKeys {
            if button.lastTouch == touch {
                button.handleMove(touch: touch)
            }
        }
    }
    
    func multitouchGestureRecognizer(_ gestureRecognizer: MultitouchGestureRecognizer, touchDidCancel touch: UITouch) {
        for button in currentKeys {
            if button.lastTouch == touch {
                button.handleEnd(touch: touch)
            }
        }
    }
    
    func multitouchGestureRecognizer(_ gestureRecognizer: MultitouchGestureRecognizer, touchDidEnd touch: UITouch) {
        for button in currentKeys {
            if button.lastTouch == touch {
                button.handleEnd(touch: touch)
            }
        }
    }
}

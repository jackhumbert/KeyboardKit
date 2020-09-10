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
[ 0.002, 0.100, 0.235, 0.200, 0.008, 0.042, 0.113, 0.016, 0.220, 0.009, 0.092, 0.541, 0.181, 1.000, 0.002, 0.075, 0.002, 0.636, 0.466, 0.734, 0.064, 0.124, 0.043, 0.011, 0.202, 0.011 ],
[ 0.329, 0.030, 0.001, 0.002, 1.000, 0.000, 0.000, 0.001, 0.185, 0.009, 0.000, 0.319, 0.004, 0.001, 0.336, 0.001, 0.000, 0.158, 0.047, 0.013, 0.288, 0.007, 0.001, 0.000, 0.212, 0.000 ],
[ 0.690, 0.000, 0.109, 0.000, 0.859, 0.000, 0.001, 0.761, 0.344, 0.000, 0.299, 0.197, 0.000, 0.001, 1.000, 0.000, 0.004, 0.192, 0.022, 0.494, 0.179, 0.000, 0.000, 0.000, 0.052, 0.001 ],
[ 0.356, 0.006, 0.008, 0.094, 1.000, 0.006, 0.046, 0.008, 0.620, 0.004, 0.000, 0.056, 0.029, 0.041, 0.339, 0.002, 0.001, 0.151, 0.197, 0.003, 0.172, 0.027, 0.015, 0.000, 0.083, 0.000 ],
[ 0.418, 0.026, 0.218, 0.526, 0.225, 0.065, 0.060, 0.016, 0.085, 0.002, 0.024, 0.260, 0.153, 0.652, 0.043, 0.081, 0.012, 1.000, 0.584, 0.229, 0.007, 0.113, 0.090, 0.080, 0.091, 0.006 ],
[ 0.266, 0.000, 0.001, 0.000, 0.405, 0.312, 0.002, 0.000, 0.529, 0.000, 0.000, 0.084, 0.001, 0.001, 1.000, 0.000, 0.000, 0.372, 0.013, 0.167, 0.172, 0.000, 0.001, 0.000, 0.014, 0.000 ],
[ 0.463, 0.004, 0.001, 0.007, 1.000, 0.004, 0.075, 0.689, 0.340, 0.000, 0.001, 0.114, 0.008, 0.147, 0.491, 0.001, 0.000, 0.416, 0.154, 0.037, 0.186, 0.000, 0.004, 0.000, 0.042, 0.000 ],
[ 0.339, 0.003, 0.000, 0.002, 1.000, 0.001, 0.000, 0.000, 0.228, 0.000, 0.000, 0.006, 0.004, 0.010, 0.183, 0.000, 0.000, 0.036, 0.006, 0.051, 0.027, 0.000, 0.003, 0.000, 0.012, 0.000 ],
[ 0.115, 0.029, 0.260, 0.171, 0.142, 0.062, 0.119, 0.001, 0.001, 0.002, 0.033, 0.242, 0.116, 1.000, 0.255, 0.033, 0.003, 0.131, 0.393, 0.435, 0.005, 0.114, 0.000, 0.010, 0.001, 0.025 ],
[ 0.182, 0.002, 0.000, 0.002, 0.386, 0.000, 0.000, 0.000, 0.045, 0.002, 0.000, 0.002, 0.000, 0.000, 0.760, 0.000, 0.000, 0.002, 0.002, 0.002, 1.000, 0.000, 0.002, 0.000, 0.000, 0.000 ],
[ 0.075, 0.004, 0.000, 0.003, 1.000, 0.011, 0.005, 0.009, 0.423, 0.001, 0.005, 0.043, 0.005, 0.129, 0.030, 0.004, 0.000, 0.010, 0.224, 0.004, 0.010, 0.001, 0.007, 0.000, 0.038, 0.000 ],
[ 0.595, 0.011, 0.013, 0.343, 1.000, 0.042, 0.005, 0.006, 0.757, 0.000, 0.038, 0.902, 0.039, 0.007, 0.471, 0.039, 0.000, 0.013, 0.192, 0.132, 0.128, 0.039, 0.016, 0.000, 0.415, 0.002 ],
[ 0.555, 0.138, 0.001, 0.001, 1.000, 0.005, 0.000, 0.000, 0.365, 0.000, 0.001, 0.003, 0.143, 0.008, 0.376, 0.265, 0.000, 0.000, 0.091, 0.001, 0.125, 0.000, 0.001, 0.000, 0.067, 0.000 ],
[ 0.241, 0.006, 0.278, 1.000, 0.579, 0.044, 0.894, 0.007, 0.310, 0.013, 0.064, 0.041, 0.031, 0.099, 0.293, 0.004, 0.002, 0.007, 0.335, 0.823, 0.062, 0.044, 0.007, 0.001, 0.083, 0.004 ],
[ 0.056, 0.050, 0.090, 0.096, 0.022, 0.486, 0.045, 0.014, 0.065, 0.008, 0.053, 0.230, 0.349, 1.000, 0.191, 0.157, 0.001, 0.802, 0.168, 0.258, 0.618, 0.133, 0.213, 0.008, 0.027, 0.003 ],
[ 0.657, 0.005, 0.005, 0.009, 1.000, 0.003, 0.002, 0.117, 0.262, 0.000, 0.003, 0.630, 0.040, 0.002, 0.712, 0.308, 0.000, 0.824, 0.098, 0.153, 0.239, 0.000, 0.003, 0.000, 0.019, 0.000 ],
[ 0.003, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.010, 0.000, 0.000, 0.000, 0.000, 0.000, 0.001, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 0.000, 0.001, 0.000, 0.000, 0.000 ],
[ 0.344, 0.016, 0.073, 0.137, 1.000, 0.018, 0.064, 0.006, 0.400, 0.001, 0.094, 0.052, 0.077, 0.115, 0.413, 0.017, 0.001, 0.070, 0.286, 0.249, 0.079, 0.041, 0.010, 0.000, 0.156, 0.001 ],
[ 0.269, 0.010, 0.117, 0.024, 0.692, 0.011, 0.003, 0.268, 0.430, 0.000, 0.045, 0.046, 0.035, 0.022, 0.330, 0.151, 0.007, 0.009, 0.306, 1.000, 0.199, 0.002, 0.016, 0.000, 0.024, 0.000 ],
[ 0.179, 0.004, 0.015, 0.001, 0.366, 0.003, 0.001, 1.000, 0.333, 0.000, 0.000, 0.030, 0.010, 0.005, 0.423, 0.001, 0.000, 0.121, 0.116, 0.064, 0.066, 0.000, 0.025, 0.000, 0.086, 0.002 ],
[ 0.215, 0.162, 0.276, 0.184, 0.258, 0.028, 0.248, 0.003, 0.173, 0.002, 0.013, 0.531, 0.241, 0.870, 0.011, 0.347, 0.001, 1.000, 0.790, 0.884, 0.001, 0.006, 0.001, 0.007, 0.019, 0.009 ],
[ 0.106, 0.000, 0.000, 0.000, 1.000, 0.000, 0.000, 0.000, 0.300, 0.000, 0.000, 0.001, 0.000, 0.000, 0.073, 0.000, 0.000, 0.000, 0.001, 0.000, 0.003, 0.000, 0.000, 0.000, 0.006, 0.000 ],
[ 0.915, 0.006, 0.005, 0.011, 0.786, 0.002, 0.000, 0.622, 1.000, 0.000, 0.003, 0.024, 0.006, 0.224, 0.549, 0.001, 0.000, 0.051, 0.124, 0.015, 0.002, 0.000, 0.003, 0.000, 0.008, 0.000 ],
[ 0.341, 0.004, 0.357, 0.000, 0.354, 0.015, 0.000, 0.052, 0.374, 0.000, 0.000, 0.002, 0.000, 0.000, 0.046, 1.000, 0.002, 0.000, 0.004, 0.617, 0.098, 0.000, 0.004, 0.007, 0.017, 0.000 ],
[ 0.177, 0.055, 0.045, 0.042, 0.910, 0.008, 0.008, 0.009, 0.203, 0.000, 0.007, 0.120, 0.116, 0.070, 1.000, 0.067, 0.001, 0.050, 0.586, 0.092, 0.006, 0.003, 0.048, 0.001, 0.002, 0.004 ],
[ 0.339, 0.014, 0.000, 0.000, 1.000, 0.000, 0.002, 0.023, 0.215, 0.000, 0.002, 0.038, 0.009, 0.000, 0.176, 0.005, 0.000, 0.002, 0.005, 0.002, 0.034, 0.002, 0.007, 0.000, 0.045, 0.145 ],
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
    
    // MARK: - Handle Press
        
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
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touch")
//        guard let locationPoint = touches.first?.location(in: view) else { return }
//        let button = view.hitTest(locationPoint, with: event)
//        print(button)
//        button?.backgroundColor = .black
//    }
    
}

// MARK: - Multitouch gesture recognizer delegate

extension KeyboardViewController: MultitouchGestureRecognizerDelegate {

    func multitouchGestureRecognizer(_ gestureRecognizer: MultitouchGestureRecognizer, touchDidBegin touch: UITouch) {
        let currentLocation = touch.location(in: view)
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
                                distance = max(distance - (characterLUT[a][b] - 0.5) * 20.0, 0.0)
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
        print("Touch finished")
        for button in currentKeys {
            if button.lastTouch == touch {
                button.handleEnd(touch: touch)
            }
        }
    }
}

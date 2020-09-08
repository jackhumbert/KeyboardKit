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
    
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context.actionHandler = DemoKeyboardActionHandler(inputViewController: self)
//        view.isUserInteractionEnabled = true
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

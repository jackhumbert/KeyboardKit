//
//  DemoButton.swift
//  KeyboardKitExampleKeyboard
//
//  Created by Daniel Saidi on 2019-04-30.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import UIKit
import KeyboardKit

/**
 This demo-specific button view represents a keyboard button
 like the one used in the iOS system keyboard. The file also
 contains `KeyboardAction` extensions used by this class.
 */
class DemoButton: KeyboardButtonView {

    var buttonViewBackgroundColor: UIColor = .black
    var vC : KeyboardViewController?
    var startTime: Date?
    var touching: Bool = false
    var timer: Timer?
    var repeated: Bool = false
    var gR: UILongPressGestureRecognizer?
    var bottomRow: Bool = false
    var currentLocation: CGPoint = CGPoint(x: 0, y: 0)
    var character: Character?
    var lastTouch: UITouch?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if action != .none {
            let dark = action.useDarkAppearance(in: vC!)
            if dark {
                buttonView?.applyShadowExtra(.standardExtraButtonShadowDark)
            } else {
                buttonView?.applyShadowExtra(.standardExtraButtonShadowLight)
            }
        }
    }
    
    
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        var margin: CGFloat = 0
//        switch action {
//            case .character("e"): margin = 50
//            default: break
//        }
//        let area = self.bounds.insetBy(dx: -margin, dy: -margin)
//        return area.contains(point)
//    }
    
    open func setup(with action: KeyboardAction, in viewController: KeyboardInputViewController, distribution: UIStackView.Distribution = .fillEqually) {
        super.setup(with: action, in: viewController)
        
        vC = viewController as? KeyboardViewController
        backgroundColor = .clearInteractable
        buttonViewBackgroundColor = action.buttonColor(for: viewController)
        if !touching {
            buttonView?.backgroundColor = buttonViewBackgroundColor
        }
//        buttonView?.backgroundColor = .clear
        DispatchQueue.main.async { self.image?.image = action.buttonImage(in: viewController) }
        textLabel?.font = action.buttonFont(in: viewController)
        textLabel?.text = action.buttonText(in: viewController)
        switch action {
            case .none:
                break
            case .character(let text):
                if text.rangeOfCharacter(from: CharacterSet.lowercaseLetters.inverted) == nil {
                    character = text.first
                } else if text.rangeOfCharacter(from: CharacterSet.uppercaseLetters.inverted) == nil {
                    character = text.lowercased().first
                } else {
                    character = " "
                }
            default: break
        }
        textLabel?.textColor = action.tintColor(in: viewController)
        buttonView?.tintColor = action.tintColor(in: viewController)
        width = action.buttonWidth(for: distribution)
        
//         if gR == nil {
//            gR = UILongPressGestureRecognizer(target: self, action: #selector(handlePress))
//            gR!.minimumPressDuration = 0.0
//            addGestureRecognizer(gR!)
//        }
    
        self.removeConstraints(self.constraints)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if viewController.deviceOrientation.isLandscape {
                buttonView?.layer.cornerRadius = 8
            } else {
                buttonView?.layer.cornerRadius = 5
            }
        } else {
            buttonView?.layer.cornerRadius = 5
        }
            
        var buttonPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        var textPadding = CGPoint(x: 0, y: 0)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if viewController.deviceOrientation.isLandscape {
                buttonPadding = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
                textPadding = CGPoint(x: 8, y: 6)
            } else {
                buttonPadding = UIEdgeInsets(top: 5, left: 5, bottom: 4, right: 5)
                textPadding = CGPoint(x: 7, y: 5)
            }
            switch action {
                case .keyboardType(.alphabetic(.lowercased)):
                    if viewController.context.keyboardType == .numeric {
                        self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .left, relatedBy: .equal, toItem: buttonView!, attribute: .left, multiplier: 1, constant: textPadding.x))
                        self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .bottom, relatedBy: .equal, toItem: buttonView!, attribute: .bottom, multiplier: 1, constant: -textPadding.y))
                    } else {
                        self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .right, relatedBy: .equal, toItem: buttonView!, attribute: .right, multiplier: 1, constant: -textPadding.x))
                        self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .bottom, relatedBy: .equal, toItem: buttonView!, attribute: .bottom, multiplier: 1, constant: -textPadding.y))
                    }
                case .tab, .escape, .shift(_), .keyboardType(.numeric), .nextKeyboard:
                    self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .left, relatedBy: .equal, toItem: buttonView!, attribute: .left, multiplier: 1, constant: textPadding.x))
                    self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .bottom, relatedBy: .equal, toItem: buttonView!, attribute: .bottom, multiplier: 1, constant: -textPadding.y))
                    self.addConstraint(NSLayoutConstraint(item: image!, attribute: .left, relatedBy: .equal, toItem: buttonView!, attribute: .left, multiplier: 1, constant: textPadding.x))
                    self.addConstraint(NSLayoutConstraint(item: image!, attribute: .bottom, relatedBy: .equal, toItem: buttonView!, attribute: .bottom, multiplier: 1, constant: -textPadding.y))
                case .backspace, .newLine, .keyboardType(.symbolic), .moveCursorForward, .moveCursorBackward:
                    self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .right, relatedBy: .equal, toItem: buttonView!, attribute: .right, multiplier: 1, constant: -textPadding.x))
                    self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .bottom, relatedBy: .equal, toItem: buttonView!, attribute: .bottom, multiplier: 1, constant: -textPadding.y))
                default:
                    self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .centerX, relatedBy: .equal, toItem: buttonView! , attribute: .centerX, multiplier: 1, constant: 0))
                    self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .centerY, relatedBy: .equal, toItem: buttonView!, attribute: .centerY, multiplier: 1, constant: -2))

                    self.addConstraint(NSLayoutConstraint(item: image!, attribute: .centerX, relatedBy: .equal, toItem: buttonView!, attribute: .centerX, multiplier: 1, constant: 0))
                    self.addConstraint(NSLayoutConstraint(item: image!, attribute: .centerY, relatedBy: .equal, toItem: buttonView!, attribute: .centerY, multiplier: 1, constant: 0))

            }
        } else {
            if viewController.deviceOrientation.isLandscape {
                buttonPadding = UIEdgeInsets(top: 4, left: 3, bottom: 2, right: 3)
            } else {
                buttonPadding = UIEdgeInsets(top: 8, left: 3, bottom: 4, right: 3)
            }
            self.addConstraint(NSLayoutConstraint(item:textLabel!, attribute: .centerX, relatedBy: .equal, toItem: buttonView!, attribute: .centerX, multiplier: 1, constant: 0))
            if viewController.context.keyboardType == .alphabetic(.lowercased) && action.isInputAction {
                self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .centerY, relatedBy: .equal, toItem: buttonView!, attribute: .centerY, multiplier: 1, constant: -2))
            } else {
                self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .centerY, relatedBy: .equal, toItem: buttonView!, attribute: .centerY, multiplier: 1, constant: 0))
            }
            self.addConstraint(NSLayoutConstraint(item: image!, attribute: .centerX, relatedBy: .equal, toItem: buttonView!, attribute: .centerX, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: image!, attribute: .centerY, relatedBy: .equal, toItem: buttonView!, attribute: .centerY, multiplier: 1, constant: 0))
        }
        
        self.addConstraints([
            NSLayoutConstraint(item:self, attribute: .left, relatedBy: .equal, toItem: buttonView!, attribute: .left, multiplier: 1, constant: -buttonPadding.left),
            NSLayoutConstraint(item:self, attribute: .top, relatedBy: .equal, toItem: buttonView!, attribute: .top, multiplier: 1, constant: -buttonPadding.top),
            NSLayoutConstraint(item:self, attribute: .right, relatedBy: .equal, toItem: buttonView!, attribute: .right, multiplier: 1, constant: buttonPadding.right),
            NSLayoutConstraint(item:self, attribute: .bottom, relatedBy: .equal, toItem: buttonView!, attribute: .bottom, multiplier: 1, constant: buttonPadding.bottom)
        ])
    }
    
    @objc func handleBegin(touch: UITouch) {
        if action == .none {
            return
        }
        lastTouch = touch
        let handler = vC?.context.actionHandler
        currentLocation = touch.location(in: self)
        touching = true
        repeated = false
        
        for k in vC!.currentKeys {
            switch k.action {
                case .space: fallthrough
                case .character(_):
                    k.gR?.isEnabled = false
                    k.gR?.isEnabled = true
                default:
                    break
            }
        }
        if !vC!.currentKeys.contains(self) {
            vC!.currentKeys.append(self)
        }
        
        (handler as? DemoKeyboardActionHandler)?.triggerAudioFeedback(for: .tap, on: action, sender: self)
        (handler as? DemoKeyboardActionHandler)?.triggerHapticFeedback(for: .tap, on: action, sender: self)
        
        if action == .space {
            if let startTime = startTime {
                let difference = Date().timeIntervalSince(startTime)
                if difference < 0.300 {
                    vC?.context.actionHandler.handle(.tap, on: .backspace)
                    vC?.context.actionHandler.handle(.tap, on: .character("."))
                }
            }
        }
        
        startTime = Date()
        
        switch action {
            case .shift(currentState: .lowercased): fallthrough
            case .keyboardType(.symbolic), .keyboardType(.numeric):
                buttonView?.backgroundColor =  ColorAsset(name: "darkSystemButtonActive").color
                textLabel?.tintColor =  ColorAsset(name: "lightButtonText").color
                break
            case .character(_):
                if UIDevice.current.userInterfaceIdiom != .pad {
                    superview?.bringSubviewToFront(self)
                    buttonView?.applyShadowExtra(.standardExtraButtonShadowCharacter)
                    buttonView?.layer.rasterizationScale = UIScreen.main.scale * 2.0
                    var edgeOffset: CGFloat = 0
                    if vC!.deviceOrientation.isLandscape {
                        edgeOffset = 15
                    } else {
                        edgeOffset = 8
                    }
                    if self.frame.minX < 10.0 {
                        buttonView!.transform = CGAffineTransform(translationX: edgeOffset, y: -54.0).scaledBy(x: 1.5, y: 1.5)
                    } else if self.frame.maxX > superview!.bounds.maxX - 10.0 {
                        buttonView!.transform = CGAffineTransform(translationX: -edgeOffset, y: -54.0).scaledBy(x: 1.5, y: 1.5)
                    } else {
                        buttonView!.transform = CGAffineTransform(translationX: 0.0, y: -54.0).scaledBy(x: 1.5, y: 1.5)
                    }
//                        textLabel?.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
                    buttonView?.backgroundColor = action.buttonColorRaised(for: vC!)
                    break
                }
                fallthrough
            default:
                buttonView?.backgroundColor = action.buttonColorPressed(for: vC!)
                break
        }
        
        switch action {
            case .keyboardType(_), .shift(_):
                vC!.context.actionHandler.handle(.tap, on: self.action)
            case .backspace:
                timer = Timer.scheduledTimer(timeInterval: 0.250, target: self, selector: #selector(keyRepeat), userInfo: nil, repeats: false)
            default: break
        }
    }
    
    @objc func handleMove(touch: UITouch) {
        let handler = vC?.context.actionHandler
        let touchLocation = touch.location(in: self)
        if action == .space {
            if let startTime = startTime {
                let difference = Date().timeIntervalSince(startTime)
                if difference > 0.300 {
                    if !repeated {
                        (handler as? DemoKeyboardActionHandler)?.triggerAudioFeedback(for: .longPress, on: action, sender: self)
                        (handler as? DemoKeyboardActionHandler)?.triggerHapticFeedback(for: .longPress, on: action, sender: self)
                    }
                    repeated = true
                    if currentLocation.x < (touchLocation.x + 8) {
                        while currentLocation.x < (touchLocation.x - 8) {
                            (handler as? DemoKeyboardActionHandler)?.triggerAudioFeedback(for: .tap, on: action, sender: self)
                            (handler as? DemoKeyboardActionHandler)?.triggerHapticFeedback(for: .tap, on: action, sender: self)
                            vC!.context.actionHandler.handle(.tap, on: .moveCursorForward)
                            currentLocation.x += 8
                        }
                    } else if currentLocation.x > (touchLocation.x - 8) {
                        while currentLocation.x > (touchLocation.x + 8) {
                            (handler as? DemoKeyboardActionHandler)?.triggerAudioFeedback(for: .tap, on: action, sender: self)
                            (handler as? DemoKeyboardActionHandler)?.triggerHapticFeedback(for: .tap, on: action, sender: self)
                            vC!.context.actionHandler.handle(.tap, on: .moveCursorBackward)
                            currentLocation.x -= 8
                        }
                    }
                }
            }
        } else {
            if !self.bounds.insetBy(dx: -40.0, dy: -40.0).contains(touchLocation) {
                (handler as? DemoKeyboardActionHandler)?.triggerAudioFeedback(for: .longPress, on: action, sender: self)
                (handler as? DemoKeyboardActionHandler)?.triggerHapticFeedback(for: .longPress, on: action, sender: self)
                touching = false
                handleEnd(touch: touch)
            }
        }
    }
    
    @objc func handleEnd(touch: UITouch) {
//        let handler = vC?.context.actionHandler
    
        for (index, k) in vC!.currentKeys.enumerated() {
            if k == self {
                vC!.currentKeys.remove(at: index)
            }
        }
    
//            UIView.animate(withDuration: 0.050, delay: 0.100, options: .curveEaseInOut, animations: {
            if UIDevice.current.userInterfaceIdiom == .pad {
                self.buttonView?.backgroundColor = self.buttonViewBackgroundColor
            } else {
                switch self.action {
                    case .character(_):
                        self.buttonView?.layer.rasterizationScale = UIScreen.main.scale
                        self.buttonView?.transform = .identity
                        fallthrough
                    default:
                        self.buttonView?.backgroundColor = self.buttonViewBackgroundColor
                        break
                }
            }
//            }, completion: { (finished: Bool) in
            if UIDevice.current.userInterfaceIdiom != .pad {
                let dark = self.action.useDarkAppearance(in: self.vC!)
                if dark {
                    self.buttonView?.applyShadowExtra(.standardExtraButtonShadowDark)
                } else {
                    self.buttonView?.applyShadowExtra(.standardExtraButtonShadowLight)
                }
            }
//            })
        
        switch action {
            case .keyboardType(_), .shift(_):
                // never gets here
                if let startTime = startTime {
                    let difference = Date().timeIntervalSince(startTime)
                    if difference > 0.300 {
                        vC?.context.actionHandler.handle(.tap, on: .keyboardType(.alphabetic(.lowercased)))
                    }
                }
            default:
                if !repeated && touching {
                    repeated = false
                    timer?.invalidate()
//                        vC?.context.actionHandler.handle(.tap, on: self.action)
                    (vC?.context.actionHandler as? DemoKeyboardActionHandler)?.handle(.tap, on: self.action)
                }
        }
        
        touching = false
        

    }
    
    @objc func keyRepeat() {
        if touching {
            repeated = true
            timer = Timer.scheduledTimer(timeInterval: 0.100, target: self, selector: #selector(keyRepeat), userInfo: nil, repeats: false)
            
            let handler = vC?.context.actionHandler
            (handler as? DemoKeyboardActionHandler)?.triggerAudioFeedback(for: .tap, on: action, sender: self)
            (handler as? DemoKeyboardActionHandler)?.triggerHapticFeedback(for: .tap, on: action, sender: self)
            
            vC?.context.actionHandler.handle(.tap, on: self.action)
        }
    }
    
    @IBOutlet weak var buttonView: UIView?
    
    @IBOutlet weak var image: UIImageView?
    
    @IBOutlet weak var textLabel: UILabel? {
        didSet { textLabel?.text = "" }
    }
 
}


// MARK: - Private button-specific KeyboardAction Extensions

private extension KeyboardAction {
    
    func buttonColor(for viewController: KeyboardInputViewController) -> UIColor {
        let dark = useDarkAppearance(in: viewController)
        let asset = useDarkButton
            ? (dark ? Asset.Colors.darkSystemButton : Asset.Colors.lightSystemButton)
            : (dark ? Asset.Colors.darkButton : Asset.Colors.lightButton)
        switch self {
            case .none:
                return .clear
            case .shift(currentState: .uppercased):
                return ColorAsset(name: "darkSystemButtonActive").color
            case .newLine:
                if viewController.textDocumentProxy.returnKeyType != UIReturnKeyType.default {
                    return ColorAsset(name: "blueButton").color
                } else {
                    return asset.color
                }
            case .keyboardType(.alphabetic(.lowercased)):
                if viewController.context.keyboardType == .numeric || viewController.context.keyboardType == .symbolic {
                    return ColorAsset(name: "darkSystemButtonActive").color
                } else {
                    return asset.color
                }
            default: return asset.color
        }
    }
    
    func buttonColorPressed(for viewController: KeyboardInputViewController) -> UIColor {
        let dark = useDarkAppearance(in: viewController)
        let asset = useDarkButton
            ? (dark ? ColorAsset(name: "darkSystemButtonPressed") : ColorAsset(name: "lightSystemButtonPressed"))
            : (dark ? ColorAsset(name: "darkButtonPressed") : ColorAsset(name: "lightButtonPressed"))
        switch self {
            case .shift(currentState: .uppercased):
                return ColorAsset(name: "lightButtonPressed").color
            case .newLine:
                if viewController.textDocumentProxy.returnKeyType != UIReturnKeyType.default {
                    return ColorAsset(name: "blueButtonPressed").color
                } else {
                    return asset.color
                }
            case .keyboardType(.alphabetic(.lowercased)):
                if viewController.context.keyboardType == .numeric || viewController.context.keyboardType == .symbolic {
                    return ColorAsset(name: "lightButtonPressed").color
                } else {
                    return asset.color
                }
            default: return asset.color
        }
    }
    
    func buttonColorRaised(for viewController: KeyboardInputViewController) -> UIColor {
        let dark = useDarkAppearance(in: viewController)
        let asset = dark ? ColorAsset(name: "darkButtonRaised") : ColorAsset(name: "lightButtonRaised")
        return asset.color
    }
    
    func buttonImage(in viewController: KeyboardInputViewController) -> UIImage? {
        switch self {
        case .image(_, let imageName, _): return UIImage(named: imageName)
        case .nextKeyboard:
            let dark = useDarkAppearance(in: viewController)
            if dark {
                return Asset.Images.Buttons.switchKeyboard.image.tinted(with: ColorAsset(name: "darkSystemButtonText").color, blendMode: .normal)?.resized(to: CGSize(width: 24.0, height: 24.0))
            } else {
                return Asset.Images.Buttons.switchKeyboard.image.tinted(with: ColorAsset(name: "lightSystemButtonText").color, blendMode: .normal)?.resized(to: CGSize(width: 24.0, height: 24.0))
            }
        default: return nil
        }
    }
    
    func buttonFont(in viewController: KeyboardInputViewController) -> UIFont {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if viewController.deviceOrientation.isLandscape {
                switch self {
                    case .character(_): return UIFont.systemFont(ofSize: 32.0, weight: UIFont.Weight.light)
                    default: return UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.regular)
                }
            } else {
                switch self {
                    case .character(_): return UIFont.systemFont(ofSize: 25.0, weight: UIFont.Weight.light)
                    default: return UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.regular)
                }
            }
        } else {
            if viewController.deviceOrientation.isLandscape {
                switch self {
                    case .shift(_): fallthrough
                    case .backspace: fallthrough
                    case .character(_): return UIFont.systemFont(ofSize: 23.0, weight: UIFont.Weight.light)
                    case .newLine:
                        switch viewController.textDocumentProxy.returnKeyType {
                            case .go:
                                return UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.regular)
                            default:
                                return UIFont.systemFont(ofSize: 25.0, weight: UIFont.Weight.light)
                        }
                    default: return UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.regular)
                }
            } else {
                switch self {
                    case .shift(_): fallthrough
                    case .backspace: fallthrough
                    case .character(_): return UIFont.systemFont(ofSize: 25.0, weight: UIFont.Weight.light)
                    case .newLine:
                        switch viewController.textDocumentProxy.returnKeyType {
                            case .go:
                                return UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.regular)
                            default:
                                return UIFont.systemFont(ofSize: 25.0, weight: UIFont.Weight.light)
                        }
                    default: return UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.regular)
                }
            }
        }
    }
    
    func buttonText(in viewController: KeyboardInputViewController) -> String {
        switch self {
        case .backspace: return UIDevice.current.userInterfaceIdiom == .pad ? "delete" : "⌫"
        case .character(let text), .emoji(let text): return text
        case .keyboardType(let type): return buttonText(for: type, in: viewController)
        case .newLine:
            switch viewController.textDocumentProxy.returnKeyType {
                case .continue:
                    return UIDevice.current.userInterfaceIdiom == .pad ? "continue" : "⏎"
                case .default:
                    return UIDevice.current.userInterfaceIdiom == .pad ? "return" : "⏎"
                case .emergencyCall:
                    return UIDevice.current.userInterfaceIdiom == .pad ? "call" : "⏎"
                case .search:
                    return UIDevice.current.userInterfaceIdiom == .pad ? "search" : "⏎"
                case .send:
                    return UIDevice.current.userInterfaceIdiom == .pad ? "send" : "⏎"
                case .go:
                    return "go"
                default:
                    return UIDevice.current.userInterfaceIdiom == .pad ? "return" : "⏎"
            }
        case .shift, .custom(name: "shift"): return UIDevice.current.userInterfaceIdiom == .pad ? "shift" : "⇧"
        case .space: return ""
        case .tab: return "tab"
        case .escape: return "esc"
        case .command: return "⌘"
        case .control: return "⌃"
        case .option: return "⌥"
        case .moveCursorBackward: return "←"
        case .moveCursorForward: return "→"
        default: return ""
        }
    }
    
    func buttonText(for keyboardType: KeyboardType, in viewController: KeyboardInputViewController) -> String {
        switch keyboardType {
        case .alphabetic:
                if viewController.context.keyboardType == .numeric {
                    return "123"
                }
                if viewController.context.keyboardType == .symbolic {
                    return "#+="
                }
                return "ABC"
        case .numeric: return "123"
        case .symbolic: return "#+="
        case .custom("shift"): return "⇧"
        default: return "???"
        }
    }
    
    var buttonWidth: CGFloat {
        switch self {
        case .none: return 50
//        case .backspace: return 100
        case .moveCursorForward, .moveCursorBackward: return 25
//        case .character("e"): return 60
//        case .character("t"): return 60
//        case .character("a"): return 60
//        case .character("o"): return 60
//        case .character("i"): return 60
//        case .character("n"): return 60
//        case .character("s"): return 60
//        case .character("r"): return 60
//        case .character("p"): return 40
//        case .character("g"): return 40
//        case .character("b"): return 40
//        case .character("v"): return 40
//        case .character("k"): return 40
//        case .character("j"): return 40
//        case .character("x"): return 40
//        case .character("q"): return 40
//        case .character("z"): return 40
        default: return 50
        }
    }
    
    func buttonWidth(for distribution: UIStackView.Distribution) -> CGFloat {
        let adjust = distribution == .fillProportionally
        return adjust ? buttonWidth * 100 : buttonWidth
    }
    
    func tintColor(in viewController: KeyboardInputViewController) -> UIColor {
        let dark = useDarkAppearance(in: viewController)
        var asset = useDarkButton
            ? (dark ? Asset.Colors.darkSystemButtonText : Asset.Colors.lightSystemButtonText)
            : (dark ? Asset.Colors.darkButtonText : Asset.Colors.lightButtonText)
            
        if self == .newLine && viewController.textDocumentProxy.returnKeyType != UIReturnKeyType.default {
            asset = Asset.Colors.darkButtonText
        }
        if self == .shift(currentState: .uppercased) {
            asset = ColorAsset(name: "lightButtonText")
        }
        if self == .keyboardType(.alphabetic(.lowercased)) {
            if viewController.context.keyboardType == .numeric || viewController.context.keyboardType == .symbolic {
                asset = ColorAsset(name: "lightButtonText")
            }
        }
        
        return asset.color
    }
    
    func useDarkAppearance(in viewController: KeyboardInputViewController) -> Bool {
        if #available(iOSApplicationExtension 12.0, *) {
            return viewController.traitCollection.userInterfaceStyle == .dark
        } else {
            let appearance = viewController.textDocumentProxy.keyboardAppearance ?? .default
            return appearance == .dark
        }
    }
    
    var useDarkButton: Bool {
        switch self {
        case .character, .image, .space: return false
        default: return true
        }
    }
    
}


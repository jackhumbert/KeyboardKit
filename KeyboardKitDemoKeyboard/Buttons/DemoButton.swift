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
    
    open func setup(with action: KeyboardAction, in viewController: KeyboardInputViewController, distribution: UIStackView.Distribution = .fillEqually) {
        super.setup(with: action, in: viewController)
        
        vC = viewController as? KeyboardViewController
        backgroundColor = .clearInteractable
        buttonViewBackgroundColor = action.buttonColor(for: viewController)
        buttonView?.backgroundColor = buttonViewBackgroundColor
//        buttonView?.backgroundColor = .clear
        DispatchQueue.main.async { self.image?.image = action.buttonImage }
        textLabel?.font = action.buttonFont
        textLabel?.text = action.buttonText(in: viewController)
        textLabel?.textColor = action.tintColor(in: viewController)
        buttonView?.tintColor = action.tintColor(in: viewController)
        width = action.buttonWidth(for: distribution)
        applyShadow(.standardButtonShadow)
        
         if gR == nil {
            gR = UILongPressGestureRecognizer(target: self, action: #selector(handlePress))
            gR!.minimumPressDuration = 0.0
            addGestureRecognizer(gR!)
        }
    
        self.removeConstraints(self.constraints)
        

        
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.addConstraints([
                NSLayoutConstraint(item:self, attribute: .left, relatedBy: .equal, toItem: buttonView!, attribute: .left, multiplier: 1, constant: -7),
                NSLayoutConstraint(item:self, attribute: .top, relatedBy: .equal, toItem: buttonView!, attribute: .top, multiplier: 1, constant: -7),
                NSLayoutConstraint(item:self, attribute: .right, relatedBy: .equal, toItem: buttonView!, attribute: .right, multiplier: 1, constant: 7),
                NSLayoutConstraint(item:self, attribute: .bottom, relatedBy: .equal, toItem: buttonView!, attribute: .bottom, multiplier: 1, constant: 7)
            ])
            switch action {
                case .keyboardType(.alphabetic(.lowercased)):
                    if viewController.context.keyboardType == .numeric {
                        self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .left, relatedBy: .equal, toItem: buttonView!, attribute: .left, multiplier: 1, constant: 8))
                        self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .bottom, relatedBy: .equal, toItem: buttonView!, attribute: .bottom, multiplier: 1, constant: -6))
                    } else {
                        self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .right, relatedBy: .equal, toItem: buttonView!, attribute: .right, multiplier: 1, constant: -8))
                        self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .bottom, relatedBy: .equal, toItem: buttonView!, attribute: .bottom, multiplier: 1, constant: -6))
                    }
                case .tab, .escape, .shift(_), .keyboardType(.numeric), .nextKeyboard:
                    self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .left, relatedBy: .equal, toItem: buttonView!, attribute: .left, multiplier: 1, constant: 8))
                    self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .bottom, relatedBy: .equal, toItem: buttonView!, attribute: .bottom, multiplier: 1, constant: -6))
                    self.addConstraint(NSLayoutConstraint(item: image!, attribute: .left, relatedBy: .equal, toItem: buttonView!, attribute: .left, multiplier: 1, constant: 8))
                    self.addConstraint(NSLayoutConstraint(item: image!, attribute: .bottom, relatedBy: .equal, toItem: buttonView!, attribute: .bottom, multiplier: 1, constant: -6))
                case .backspace, .newLine, .keyboardType(.symbolic), .moveCursorForward, .moveCursorBackward:
                    self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .right, relatedBy: .equal, toItem: buttonView!, attribute: .right, multiplier: 1, constant: -8))
                    self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .bottom, relatedBy: .equal, toItem: buttonView!, attribute: .bottom, multiplier: 1, constant: -6))
                default:
                    self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .centerX, relatedBy: .equal, toItem: buttonView! , attribute: .centerX, multiplier: 1, constant: 0))
                    self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .centerY, relatedBy: .equal, toItem: buttonView!, attribute: .centerY, multiplier: 1, constant: -2))

                    self.addConstraint(NSLayoutConstraint(item: image!, attribute: .centerX, relatedBy: .equal, toItem: buttonView!, attribute: .centerX, multiplier: 1, constant: 0))
                    self.addConstraint(NSLayoutConstraint(item: image!, attribute: .centerY, relatedBy: .equal, toItem: buttonView!, attribute: .centerY, multiplier: 1, constant: 0))

            }
        } else {
            self.addConstraints([
                NSLayoutConstraint(item:self, attribute: .left, relatedBy: .equal, toItem: buttonView!, attribute: .left, multiplier: 1, constant: -3),
                NSLayoutConstraint(item:self, attribute: .top, relatedBy: .equal, toItem: buttonView!, attribute: .top, multiplier: 1, constant: -3),
                NSLayoutConstraint(item:self, attribute: .right, relatedBy: .equal, toItem: buttonView!, attribute: .right, multiplier: 1, constant: 3),
                NSLayoutConstraint(item:self, attribute: .bottom, relatedBy: .equal, toItem: buttonView!, attribute: .bottom, multiplier: 1, constant: 3)
            ])
            self.addConstraint(NSLayoutConstraint(item:textLabel!, attribute: .centerX, relatedBy: .equal, toItem: buttonView!, attribute: .centerX, multiplier: 1, constant: 0))
            if viewController.context.keyboardType == .alphabetic(.lowercased) && action.isInputAction {
                self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .centerY, relatedBy: .equal, toItem: buttonView!, attribute: .centerY, multiplier: 1, constant: -2))
            } else {
                self.addConstraint(NSLayoutConstraint(item: textLabel!, attribute: .centerY, relatedBy: .equal, toItem: buttonView!, attribute: .centerY, multiplier: 1, constant: 0))
            }
            self.addConstraint(NSLayoutConstraint(item: image!, attribute: .centerX, relatedBy: .equal, toItem: buttonView!, attribute: .centerX, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: image!, attribute: .centerY, relatedBy: .equal, toItem: buttonView!, attribute: .centerY, multiplier: 1, constant: 0))
        }
    }
    
    @objc func handlePress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
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
            vC!.currentKeys.append(self)
            
            let handler = vC?.context.actionHandler
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
                    buttonView?.backgroundColor =  ColorAsset(name: "lightButton").color
                    textLabel?.tintColor =  ColorAsset(name: "lightButtonText").color
                    break
                case .character(_):
                    if UIDevice.current.userInterfaceIdiom != .pad {
                        superview?.bringSubviewToFront(self)
                        buttonView?.transform = CGAffineTransform(translationX: 0.0, y: -50.0).scaledBy(x: 1.75, y: 1.5)
                        textLabel?.transform = CGAffineTransform(translationX: 0.0, y: 0.0).scaledBy(x: 1.0, y: 1.75/1.5)
                        buttonView?.backgroundColor = action.buttonColorPressed(for: vC!).withAlphaComponent(1.0)
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
        
        if gesture.state == .ended || gesture.state == .cancelled {
        
            touching = false
            for (index, k) in vC!.currentKeys.enumerated() {
                if k == self {
                    vC!.currentKeys.remove(at: index)
                }
            }
        
            if UIDevice.current.userInterfaceIdiom == .pad {
                buttonView?.backgroundColor = buttonViewBackgroundColor
            } else {
                switch action {
                    case .character(_):
//                        self.layer.zPosition = 1
                        buttonView?.transform = .identity
                        textLabel?.transform = .identity
                        fallthrough
                    default:
                        buttonView?.backgroundColor = buttonViewBackgroundColor
                        break
                }
            }
            
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
                    if !repeated {
                        repeated = false
                        timer?.invalidate()
//                        vC?.context.actionHandler.handle(.tap, on: self.action)
                        (vC?.context.actionHandler as? DemoKeyboardActionHandler)?.handle(.tap, on: self.action)
                    }
            }
        
        }
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
    
    @IBOutlet weak var buttonView: UIView? {
        didSet { buttonView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 8 : 5 }
    }
    
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
            case .shift(currentState: .uppercased):
                return ColorAsset(name: "lightButton").color
            case .newLine:
                if viewController.textDocumentProxy.returnKeyType != UIReturnKeyType.default {
                    return ColorAsset(name: "blueButton").color
                } else {
                    return asset.color
                }
            case .keyboardType(.alphabetic(.lowercased)):
                if viewController.context.keyboardType == .numeric || viewController.context.keyboardType == .symbolic {
                    return ColorAsset(name: "lightButton").color
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
    
    var buttonImage: UIImage? {
        switch self {
        case .image(_, let imageName, _): return UIImage(named: imageName)
        case .nextKeyboard:
            return Asset.Images.Buttons.switchKeyboard.image.tinted(with: .white, blendMode: .lighten)?.resized(to: CGSize(width: 24.0, height: 24.0))
        default: return nil
        }
    }
    
    var buttonFont: UIFont? {
        if UIDevice.current.userInterfaceIdiom == .pad {
            switch self {
                case .character(_): return UIFont.systemFont(ofSize: 32.0, weight: UIFont.Weight.light)
                default: return UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.regular)
            }
        } else {
            switch self {
                case .shift(_): return UIFont.systemFont(ofSize: 25.0, weight: UIFont.Weight.light)
                case .backspace, .newLine: return UIFont.systemFont(ofSize: 25.0, weight: UIFont.Weight.light)
                case .character(_): return UIFont.systemFont(ofSize: 25.0, weight: UIFont.Weight.light)
                case .space: return UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.regular)
                default: return UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.regular)
            }
        }
    }
    
    func buttonText(in viewController: KeyboardInputViewController) -> String {
        switch self {
        case .backspace: return UIDevice.current.userInterfaceIdiom == .pad ? "delete" : "⌫"
        case .character(let text), .emoji(let text): return text
        case .keyboardType(let type): return buttonText(for: type, in: viewController)
        case .newLine: return UIDevice.current.userInterfaceIdiom == .pad ? "return" : "⏎"
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
        case .none: return 10
        case .shift, .backspace: return 50
        case .space: return 50
        case .moveCursorForward, .moveCursorBackward: return 25
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


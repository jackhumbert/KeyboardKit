//
//  KeyboardViewController.swift
//  KeyboardKitDemoKeyboard_SwiftUI
//
//  Created by Daniel Saidi on 2020-06-10.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import UIKit
import KeyboardKit
import KeyboardKitSwiftUI
import SwiftUI

/**
 This SwiftUI-based demo keyboard demonstrates how to create
 a keyboard extension using `KeyboardKit` and `SwiftUI`.
 
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
    
    let toastContext = KeyboardToastContext()
    
    var keyboardView: some View {
        KeyboardView(controller: self)
            .environmentObject(toastContext)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(with: keyboardView)
        context.actionHandler = DemoKeyboardActionHandler(inputViewController: self, toastContext: toastContext)
    }
}

struct KeyboardViewController_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

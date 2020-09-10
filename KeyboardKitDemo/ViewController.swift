//
//  ViewController.swift
//  KeyboardKitDemo
//
//  Created by Daniel Saidi on 2019-10-01.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBInspectable var light: Bool = false

    @IBOutlet weak var textView: UITextView? {
        didSet { textView?.contentInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0) }
    }
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = self.light ? .light : .dark
        }
    }
}

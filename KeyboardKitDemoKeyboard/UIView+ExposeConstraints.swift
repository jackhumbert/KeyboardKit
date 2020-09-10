//
//  UIView+ExposeConstraints.swift
//  KeyboardKitDemoKeyboard
//
//  Created by Jack Humbert on 9/10/20.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

var heightConstraint: NSLayoutConstraint? {
    get {
        return constraints.first(where: {
            $0.firstAttribute == .height && $0.relation == .equal
        })
    }
    set { setNeedsLayout() }
}

var widthConstraint: NSLayoutConstraint? {
    get {
        return constraints.first(where: {
            $0.firstAttribute == .width && $0.relation == .equal
        })
    }
    set { setNeedsLayout() }
}

var leftConstraint: NSLayoutConstraint? {
    get {
        return constraints.first(where: {
            $0.firstAttribute == .left && $0.relation == .equal
        })
    }
    set { setNeedsLayout() }
}

var rightConstraint: NSLayoutConstraint? {
    get {
        return constraints.first(where: {
            $0.firstAttribute == .right && $0.relation == .equal
        })
    }
    set { setNeedsLayout() }
}

var topConstraint: NSLayoutConstraint? {
    get {
        return constraints.first(where: {
            $0.firstAttribute == .top && $0.relation == .equal
        })
    }
    set { setNeedsLayout() }
}

var bottomConstraint: NSLayoutConstraint? {
    get {
        return constraints.first(where: {
            $0.firstAttribute == .bottom && $0.relation == .equal
        })
    }
    set { setNeedsLayout() }
}

}

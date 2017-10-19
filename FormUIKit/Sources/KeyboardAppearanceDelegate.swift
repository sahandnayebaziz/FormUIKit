//
//  KeyboardAppearanceDelegate.swift
//  Galaxies
//
//  Created by Sahand Nayebaziz on 11/19/16.
//  Copyright © 2016 Sahand Nayebaziz. All rights reserved.
//

import UIKit

public protocol KeyboardAppearanceDelegate: class {
    func keyboardWillHide(toEndHeight height: CGFloat)
    func keyboardWillShow(toEndHeight height: CGFloat)
    var keyboardObserver: NSObjectProtocol? { get set }
}

public extension KeyboardAppearanceDelegate where Self: UIViewController {
    
    // This method must be called in the view controller.
    public func listenForKeyboardAppearance() {
        self.keyboardObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil, queue: nil) { [weak self] notification in
            self?.handle(notification: notification)
        }
        
    }
    
    public func stopListeningForKeyboardAppearance() {
        NotificationCenter.default.removeObserver(self.keyboardObserver as Any)
        self.keyboardObserver = nil
    }
    
    fileprivate func handle(notification: Notification) {
        guard let info = (notification as NSNotification).userInfo else {
            return
        }
        
        let duration: TimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        
        let animationCurveRawNSN = info[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions().rawValue
        let animationCurve = UIViewAnimationOptions(rawValue: animationCurveRaw)
        
        guard let endFrame = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if endFrame.minY >= (self.view.frame.maxY - 20) {
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: {
                self.keyboardWillHide(toEndHeight: endFrame.height)
            }, completion: nil)
        } else {
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: {
                self.keyboardWillShow(toEndHeight: endFrame.height)
            }, completion: nil)
        }
    }
}


//
//  Dimmable.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/5/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//
//

/// Found here: http://www.totem.training/swift-ios-tips-tricks-tutorials-blog/ux-chops-dim-the-lights

import UIKit

enum Direction { case In, Out }

protocol Dimmable { }

extension Dimmable where Self: UIViewController {
    
    internal func dim(direction: Direction, color: UIColor = UIColor.blackColor(), alpha: CGFloat = 0.0, speed: Double = 0.0, completion: (() -> Void)? = nil) {
        
        switch direction {
        case .In:
            
            /// Create and add a dim view
            let dimView = UIView(frame: view.frame)
            dimView.backgroundColor = color
            dimView.alpha = 0.0
            view.addSubview(dimView)
            
            /// Deal with Auto Layout
            dimView.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[dimView]|", options: [], metrics: nil, views: ["dimView": dimView]))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[dimView]|", options: [], metrics: nil, views: ["dimView": dimView]))
            
            /// Animate alpha (the actual "dimming" effect)
            UIView.animateWithDuration(speed) { () -> Void in
                dimView.alpha = alpha
                completion?()
            }
            
        case .Out:
            UIView.animateWithDuration(speed, animations: { () -> Void in
                self.view.subviews.last?.alpha = alpha ?? 0
                }, completion: { (complete) -> Void in
                    self.view.subviews.last?.removeFromSuperview()
                    completion?()
            })
        }
    }
}

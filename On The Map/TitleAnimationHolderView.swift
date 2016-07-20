//
//  TitleAnimationHolderView.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

//protocol TitleAnimationHolderViewDelegate: class {
//    func animateLabel()
//}

class TitleAnimationHolderView: UIView {
    let titleLayer = TitleLayer()
    
//    var parentFrame :CGRect = CGRectZero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        magic("frame: \(frame)")
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    func addTitle() {
        layer.addSublayer(titleLayer)
        titleLayer.animateWithDuration(2.3)
//        let delayInSeconds = 0.2
//        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
//        
//        dispatch_after(popTime, dispatch_get_main_queue()) {
//            self.wobbleOval()
//        }
        //        NSTimer.scheduledTimerWithTimeInterval(1.3, target: self, selector: #selector(HolderView.wobbleOval), userInfo: nil, repeats: false)
    }
}
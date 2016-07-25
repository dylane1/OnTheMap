//
//  StarLayer.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/25/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class StarLayer: CAShapeLayer {

    override init() {
        super.init()
        
        fillColor   = Theme03.starColor.CGColor
        path        = drawStar().CGPath
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Need to offset the frame so the center follows the path during animation
    private func drawStar() -> UIBezierPath {
        let frame: CGRect = CGRect(x: -40, y: -40, width: 80, height: 80)
        
        //// Star 2 Drawing
        let starPath = UIBezierPath()
        starPath.moveToPoint(CGPoint(x: frame.minX + 40, y: frame.minY))
        starPath.addLineToPoint(CGPoint(x: frame.minX + 49.68, y: frame.minY + 26.68))
        starPath.addLineToPoint(CGPoint(x: frame.minX + 78.04, y: frame.minY + 27.64))
        starPath.addLineToPoint(CGPoint(x: frame.minX + 55.66, y: frame.minY + 45.09))
        starPath.addLineToPoint(CGPoint(x: frame.minX + 63.51, y: frame.minY + 72.36))
        starPath.addLineToPoint(CGPoint(x: frame.minX + 40, y: frame.minY + 56.47))
        starPath.addLineToPoint(CGPoint(x: frame.minX + 16.49, y: frame.minY + 72.36))
        starPath.addLineToPoint(CGPoint(x: frame.minX + 24.34, y: frame.minY + 45.09))
        starPath.addLineToPoint(CGPoint(x: frame.minX + 1.96, y: frame.minY + 27.64))
        starPath.addLineToPoint(CGPoint(x: frame.minX + 30.32, y: frame.minY + 26.68))
        starPath.closePath()
        
        return starPath
    }
}

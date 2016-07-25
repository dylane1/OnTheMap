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
//        strokeColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0).CGColor
        fillColor = Theme03.starColor.CGColor
//        lineWidth = 4.0
//        lineDashPattern = [2, 3]
        
        path = drawStar().CGPath
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawStar(frame frame: CGRect = CGRect(x: -40, y: -40, width: 80, height: 80)) -> UIBezierPath {
        
        //// Star 2 Drawing
        let star2Path = UIBezierPath()
        star2Path.moveToPoint(CGPoint(x: frame.minX + 40, y: frame.minY))
        star2Path.addLineToPoint(CGPoint(x: frame.minX + 49.68, y: frame.minY + 26.68))
        star2Path.addLineToPoint(CGPoint(x: frame.minX + 78.04, y: frame.minY + 27.64))
        star2Path.addLineToPoint(CGPoint(x: frame.minX + 55.66, y: frame.minY + 45.09))
        star2Path.addLineToPoint(CGPoint(x: frame.minX + 63.51, y: frame.minY + 72.36))
        star2Path.addLineToPoint(CGPoint(x: frame.minX + 40, y: frame.minY + 56.47))
        star2Path.addLineToPoint(CGPoint(x: frame.minX + 16.49, y: frame.minY + 72.36))
        star2Path.addLineToPoint(CGPoint(x: frame.minX + 24.34, y: frame.minY + 45.09))
        star2Path.addLineToPoint(CGPoint(x: frame.minX + 1.96, y: frame.minY + 27.64))
        star2Path.addLineToPoint(CGPoint(x: frame.minX + 30.32, y: frame.minY + 26.68))
        star2Path.closePath()
        
        return star2Path
    }
}

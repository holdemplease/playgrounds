// Playground - noun: a place where people can play

import UIKit
import CoreGraphics

class ColorWheelView : UIView {

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var rect:CGRect;
    
    override func drawRect(rect: CGRect) {
        let gc = UIGraphicsGetCurrentContext()
        let slices = 300.0
        let inc = CGFloat(2.0 * M_PI / slices)

        let lineWidth:CGFloat = 40.0
        let radius = (self.bounds.width * 0.5) - 2;

        CGContextSetFillColorWithColor(gc, UIColor.clearColor().CGColor)
        CGContextFillRect(gc, self.bounds)

        CGContextSetLineWidth(gc, lineWidth)
        for var theta = inc; theta <= CGFloat(2.0 * M_PI); theta+=inc {
            CGContextMoveToPoint(gc,
                self.center.x + radius * cos(theta),
                self.center.y + radius * sin(theta))

            let nextPoint = CGPointMake(
                self.center.x + (radius-lineWidth) * cos(theta),
                self.center.y + (radius-lineWidth) * sin(theta))

            CGContextAddLineToPoint(gc, nextPoint.x, nextPoint.y)
            
            let c = UIColor(hue: (theta / CGFloat(2.0 * M_PI)), saturation: 1.0, brightness: 1.0, alpha: 1.0)

            CGContextSetStrokeColorWithColor(gc, c.CGColor)
            CGContextStrokePath(gc)
            
            CGContextMoveToPoint(gc, nextPoint.x, nextPoint.y)
        }

        let path = CGPathCreateWithEllipseInRect(self.bounds, nil)
        
        CGContextSaveGState(gc)

        let boundingRect = CGContextGetClipBoundingBox(gc)
//        let otherRect = CGRectInset(boundingRect, 2, 2)
        CGContextAddRect(gc, boundingRect)
        CGContextAddPath(gc, path)
        CGContextEOClip(gc)
        
        UIColor.blackColor().setFill()
        CGContextAddPath(gc, path)
        CGContextSetShadowWithColor(gc, CGSizeMake(1, 1), 3.0, UIColor.blackColor().CGColor)
        CGContextSetBlendMode (gc, kCGBlendModeNormal)
        CGContextFillPath(gc)
        
//        CGContextAddPath(gc, path)
//        CGContextSetShadowWithColor(gc, CGSizeMake(-1, -1), 1.0, UIColor.blackColor().CGColor)
//        CGContextSetBlendMode (gc, kCGBlendModeNormal)
//        CGContextFillPath(gc)
        
        CGContextRestoreGState(gc)
    }
}

let superView = UIView(frame: CGRectMake(0, 0, 400, 400))
let view = ColorWheelView(frame: CGRectMake(0, 0, 300, 300))
superView.addSubview(view)
view.clipsToBounds = false

view.backgroundColor = UIColor.lightGrayColor()

view.layer.cornerRadius = view.bounds.width / 2

view.layer.borderWidth = 8
view.layer.borderColor = UIColor.whiteColor().CGColor

view.layer.cornerRadius = view.bounds.width / 2

superView

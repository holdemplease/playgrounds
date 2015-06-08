//
//  SquigglyView.swift
//  nekomi
//
//  Created by Justin Kovalchuk on 3/13/15.
//  Copyright (c) 2015 dravvo. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics
import Darwin

extension Int
{
    static func random(range: Range<Int> ) -> Int
    {
        var offset = 0

        if range.startIndex < 0   // allow negative ranges
        {
            offset = abs(range.startIndex)
        }

        let mini = UInt32(range.startIndex + offset)
        let maxi = UInt32(range.endIndex   + offset)

        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}

class SquigglyView : UIView {

    let path = UIBezierPath()

    @IBInspectable var shadowWidth:CGFloat = 6
    @IBInspectable var borderWidth:CGFloat = 6
    @IBInspectable var borderColor:UIColor = UIColor(red: 2.0/255, green: 200.0/255, blue: 247.0/255, alpha: 1.0)
    @IBInspectable var shadowColor:UIColor = UIColor.grayColor()
    @IBInspectable var fillColor:UIColor = UIColor.whiteColor()
    @IBInspectable var roundedEdgeRadius:CGFloat = 24
    @IBInspectable var isClipToPath:Bool = false

    @IBInspectable var maxSquiggleAmplitude:CGFloat = 8
    @IBInspectable var pixelsPerSquiggle:CGFloat = 250

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // custom init
    init(frame: CGRect, borderColor: UIColor) {
        super.init(frame: frame)
        self.borderColor = borderColor
    }

    func randomInt(number: CGFloat) -> Int {
        return Int(arc4random_uniform(UInt32(number)))
    }

    func randomPointInRectangle(rectangle: CGRect) -> CGPoint {
        return CGPoint(x: randomInt(rectangle.size.width), y: randomInt(rectangle.size.height))
    }

    func makePathForViewBorder() {
        //        println("starting makePathForViewBorder")
        var currentPoint:CGPoint?
        let maskingPath = UIBezierPath();

        self.backgroundColor = UIColor.clearColor()

        // make a subRect inset by maxSquiggleAmplitude from our rect
        var asdf = self.bounds
        var fdas = self.frame

        var squigglyRect = CGRectInset(self.bounds, maxSquiggleAmplitude + borderWidth/2 + shadowWidth, maxSquiggleAmplitude + borderWidth/2 + shadowWidth)
        var maskingOffsetX = borderWidth/2
        var maskingOffsetY = borderWidth/2
        var squiggleCountX = Int(1 + squigglyRect.width / pixelsPerSquiggle)
        var squiggleCountY = Int(1 + squigglyRect.height / pixelsPerSquiggle)

        var segmentLength: Int


        maskingOffsetX = borderWidth/2
        maskingOffsetY = borderWidth/2

        // draw top left corner
        path.addArcWithCenter(CGPointMake(squigglyRect.origin.x + roundedEdgeRadius, squigglyRect.origin.y + roundedEdgeRadius), radius: roundedEdgeRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat((3/2.0)*M_PI), clockwise: true)

        maskingPath.addArcWithCenter(CGPointMake(squigglyRect.origin.x + maskingOffsetX + roundedEdgeRadius, squigglyRect.origin.y - maskingOffsetY + roundedEdgeRadius), radius: roundedEdgeRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat((3/2.0)*M_PI), clockwise: true)

        // topleft -> topright

        segmentLength = (Int(squigglyRect.width) - Int(roundedEdgeRadius) * 2) / squiggleCountX

        for _ in 0...squiggleCountX-1 {
            var randomX = Int.random(Int(path.currentPoint.x)...Int(path.currentPoint.x) + segmentLength)
            var randomY = Int.random(Int(path.currentPoint.y - maxSquiggleAmplitude)...Int(path.currentPoint.y + maxSquiggleAmplitude))
            var randomPoint = CGPointMake(CGFloat(randomX), CGFloat(randomY))
            var randomPointMask = CGPointMake(CGFloat(randomX) + maskingOffsetX, CGFloat(randomY) - maskingOffsetY)

            path.addQuadCurveToPoint(CGPointMake(path.currentPoint.x + CGFloat(segmentLength), path.currentPoint.y), controlPoint: randomPoint)
            maskingPath.addQuadCurveToPoint(CGPointMake(maskingPath.currentPoint.x + CGFloat(segmentLength) - 2 * maskingOffsetX, maskingPath.currentPoint.y), controlPoint: randomPointMask)
        }

        // top-right corner
        path.addArcWithCenter(CGPointMake(squigglyRect.origin.x + squigglyRect.size.width - roundedEdgeRadius, squigglyRect.origin.y + roundedEdgeRadius), radius: roundedEdgeRadius, startAngle: CGFloat((3/2.0)*M_PI), endAngle: 0, clockwise: true)

        // topright -> bottomright
        segmentLength = (Int(squigglyRect.height) - Int(roundedEdgeRadius) * 2) / squiggleCountY

        for _ in 0...squiggleCountY-1 {
            var randomX = Int.random(Int(path.currentPoint.x - CGFloat(maxSquiggleAmplitude))...Int(path.currentPoint.x + CGFloat(maxSquiggleAmplitude)))
            var randomY = Int.random(Int(path.currentPoint.y)...Int(path.currentPoint.y) + segmentLength)
            var randomPoint = CGPointMake(CGFloat(randomX), CGFloat(randomY))

            path.addQuadCurveToPoint(CGPointMake(path.currentPoint.x, path.currentPoint.y + CGFloat(segmentLength)), controlPoint: randomPoint)
        }

        // bottom-right corner
        path.addArcWithCenter(CGPointMake(squigglyRect.origin.x + squigglyRect.size.width - roundedEdgeRadius, squigglyRect.origin.y + squigglyRect.height - roundedEdgeRadius), radius: roundedEdgeRadius, startAngle: 0, endAngle: CGFloat(0.5*M_PI), clockwise: true)

        // bottomright -> bottomleft
        segmentLength = (Int(squigglyRect.width) - Int(roundedEdgeRadius) * 2) / squiggleCountX

        for _ in 0...squiggleCountX-1 {
            var randomX = Int.random(Int(path.currentPoint.x - CGFloat(segmentLength))...Int(path.currentPoint.x))
            var randomY = Int.random(Int(path.currentPoint.y - maxSquiggleAmplitude)...Int(path.currentPoint.y + maxSquiggleAmplitude))
            var randomPoint = CGPointMake(CGFloat(randomX), CGFloat(randomY))

            path.addQuadCurveToPoint(CGPointMake(path.currentPoint.x - CGFloat(segmentLength), path.currentPoint.y), controlPoint: randomPoint)
        }

        // bottom-left corner
        path.addArcWithCenter(CGPointMake(squigglyRect.origin.x + roundedEdgeRadius, squigglyRect.origin.y + squigglyRect.height - roundedEdgeRadius), radius: roundedEdgeRadius, startAngle: CGFloat(0.5*M_PI), endAngle: CGFloat(M_PI), clockwise: true)

        // bottomleft -> topleft
        segmentLength = (Int(squigglyRect.height) - Int(roundedEdgeRadius) * 2) / squiggleCountY

        for _ in 0...squiggleCountY-1 {
            var randomX = Int.random(Int(path.currentPoint.x - CGFloat(maxSquiggleAmplitude))...Int(path.currentPoint.x + CGFloat(maxSquiggleAmplitude)))
            var randomY = Int.random(Int(path.currentPoint.y - CGFloat(segmentLength))...Int(path.currentPoint.y))
            var randomPoint = CGPointMake(CGFloat(randomX), CGFloat(randomY))

            path.addQuadCurveToPoint(CGPointMake(path.currentPoint.x, path.currentPoint.y - CGFloat(segmentLength)), controlPoint: randomPoint)
        }
        path.closePath()
    }

    override func drawRect(rect: CGRect) {
        if path.empty {
            makePathForViewBorder()
        }

        let gc = UIGraphicsGetCurrentContext()

        // Draw border path, shadow, and fill the view
        CGContextAddPath(gc, path.CGPath)
        CGContextSetFillColorWithColor(gc, fillColor.CGColor)
        CGContextSetLineWidth(gc, borderWidth)
        CGContextSetStrokeColorWithColor(gc, borderColor.CGColor)
        CGContextSetShadowWithColor(gc, CGSizeMake(shadowWidth/2.0, shadowWidth/2.0), shadowWidth, shadowColor.CGColor)
        CGContextDrawPath(gc, kCGPathFillStroke)

        // Second needed rendering for filling over the inner shadow
        CGContextAddPath(gc, path.CGPath)
        CGContextSetFillColorWithColor(gc, fillColor.CGColor)
        CGContextSetLineWidth(gc, borderWidth)
        CGContextSetStrokeColorWithColor(gc, borderColor.CGColor)
        CGContextSetShadowWithColor(gc, CGSizeMake(0, 0), 0, shadowColor.CGColor)
        CGContextDrawPath(gc, kCGPathFillStroke)

        self.clipsToBounds = true;

        UIGraphicsEndImageContext()

        if(self.isClipToPath)
        {
            let maskLayer = CAShapeLayer(layer: self.layer)

            // Create a shape layer
            //        CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.frame = self.frame;
            
            // Set the path of the mask layer to be the Bezier path we calculated earlier
            maskLayer.path = path.CGPath;
            
            self.layer.mask = maskLayer;
        }
    }
}


// give us the frame that needs to show and a curvature radiues and we will calculate the position and offset for it to only show it's topmost part
class CurvedGuessView : UIView
{
    var radius:CGFloat = 0
    var circleView:UIView = UIView(frame: CGRectZero)
    var color:UIColor = UIColor(red: 2.0/255, green: 200.0/255, blue: 247.0/255, alpha: 0.7)

    init(frame: CGRect, radius: CGFloat, color: UIColor) {
        super.init(frame: frame)

        self.radius = radius
        self.color = color

        let circleBounds = CGRectMake(0, 0, self.radius*2, self.radius*2)

        self.circleView = UIView(frame: circleBounds)

        self.addSubview(self.circleView)
        self.circleView.center = CGPointMake(frame.width/2, self.circleView.center.y)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.circleView = UIView(frame: CGRectZero)
    }

    override func drawRect(rect: CGRect) {

        let gc = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(gc, color.CGColor)
        CGContextFillEllipseInRect(gc, circleView.frame)
        self.clipsToBounds = true;

        UIGraphicsEndImageContext()
    }
}


//let view = SquigglyView(frame: CGRectMake(0, 0, 300, 400), borderColor: UIColor.brownColor()) //SquigglyView(frame: CGRectMake(0, 0, 300, 400), maxAmplitudePixels: 0.25, maxFrequency: 3, roundedEdgeRadius: 8, borderWidth: 10, shadowWidth: 10)
//let view = SquigglyView(frame: CGRectMake(0, 0, 300, 400))
//let backgroundView = SquigglyView(frame: CGRectMake(0, 0, 600, 400), maxSquiggleAmplitude: 8, pixelsPerSquiggle: 250, roundedEdgeRadius: 24, borderWidth: 0, shadowWidth: 8, borderColor: UIColor(red: 2.0/255, green: 200.0/255, blue: 247.0/255, alpha: 1.0), fillColor: UIColor(red: 2.0/255, green: 200.0/255, blue: 247.0/255, alpha: 1.0))

//let backgroundView = SquigglyInnerOuterView(frame: CGRectMake(0, 0, 300, 400), borderColor: UIColor.brownColor())
//backgroundView.fillColor = UIColor.brownColor()
//backgroundView.isClipToPath = true

let view = UIView(frame: CGRectMake(0, 0, 300, 300))
view.backgroundColor = UIColor.orangeColor()
let curvedView = CurvedGuessView(frame: CGRectMake(0, 0, 300, 100), radius: 300, color: UIColor(red: 2.0/255, green: 200.0/255, blue: 247.0/255, alpha: 0.7))

view.addSubview(curvedView)

//let profileView1 = SquigglyView(frame: CGRectMake(20, 20, 275, 360), maxSquiggleAmplitude: 8, pixelsPerSquiggle: 200, roundedEdgeRadius: 24, borderWidth: 0, shadowWidth: 4, borderColor: UIColor.whiteColor(), fillColor: UIColor.whiteColor())
////
//let profileView2 = SquigglyView(frame: CGRectMake(305, 20, 275, 360), maxSquiggleAmplitude: 8, pixelsPerSquiggle: 250, roundedEdgeRadius: 24, borderWidth: 0, shadowWidth: 6, borderColor: UIColor.whiteColor(), fillColor: UIColor.whiteColor())

//backgroundView.addSubview(profileView1)
//backgroundView.addSubview(profileView2)

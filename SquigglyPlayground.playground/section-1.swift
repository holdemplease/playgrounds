// Playground - noun: a place where people can play

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
    var currentPoint:CGPoint?;
    var previousPoint1:CGPoint?;
    var previousPoint2:CGPoint?;
    let path = UIBezierPath();
    var maxAmplitudePixels:CGFloat?; // = 20;
    var maxFrequency:CGFloat?; // = 30;
    var _roundedEdgeRadius:CGFloat?;
    var _shadowWidth:CGFloat = 0.0;
    var _borderWidth:CGFloat = 0.0;
    let pi = M_PI;

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    func randomInt(number: CGFloat) -> Int {
        return Int(arc4random_uniform(UInt32(number)))
    }

    func randomPointInRectangle(rectangle: CGRect) -> CGPoint {
        return CGPoint(x: randomInt(rectangle.size.width), y: randomInt(rectangle.size.height))
    }

    init(frame: CGRect, maxAmplitudePixels: CGFloat, maxFrequency: Int, roundedEdgeRadius: CGFloat, borderWidth: CGFloat, shadowWidth: CGFloat) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.clearColor();

        _shadowWidth = shadowWidth;
        _borderWidth = borderWidth;

        // make a subRect inset by maxAmplitudePixels from our rect
        var squigglyRect = CGRectInset(frame, maxAmplitudePixels + _borderWidth + _shadowWidth, maxAmplitudePixels + _borderWidth + _shadowWidth);
        var segmentLength: Int

        // draw top left corner
        path.addArcWithCenter(CGPointMake(squigglyRect.origin.x + roundedEdgeRadius, squigglyRect.origin.y + roundedEdgeRadius), radius: roundedEdgeRadius, startAngle: CGFloat(pi), endAngle: CGFloat((3/2.0)*pi), clockwise: true);

        // topleft -> topright
        segmentLength = (Int(squigglyRect.width) - Int(roundedEdgeRadius) * 2) / maxFrequency;

        for _ in 0...maxFrequency-1 {
//            var debugView = UIView(frame: CGRectMake(path.currentPoint.x, path.currentPoint.y - CGFloat(roundedEdgeRadius), CGFloat(segmentLength), CGFloat(roundedEdgeRadius*2)));
//            debugView.backgroundColor = UIColor.blackColor();
//            debugView.alpha = 0.3;
//            addSubview(debugView);

            var randomX = Int.random(Int(path.currentPoint.x)...Int(path.currentPoint.x) + segmentLength);
            var randomY = Int.random(Int(path.currentPoint.y - roundedEdgeRadius)...Int(path.currentPoint.y + roundedEdgeRadius));
            var randomPoint = CGPointMake(CGFloat(randomX), CGFloat(randomY));

            path.addQuadCurveToPoint(CGPointMake(path.currentPoint.x + CGFloat(segmentLength), path.currentPoint.y), controlPoint: randomPoint);
        }

        // top-right corner
        path.addArcWithCenter(CGPointMake(squigglyRect.origin.x + squigglyRect.size.width - roundedEdgeRadius, squigglyRect.origin.y + roundedEdgeRadius), radius: roundedEdgeRadius, startAngle: CGFloat((3/2.0)*pi), endAngle: 0, clockwise: true);

        // topright -> bottomright
        segmentLength = (Int(squigglyRect.height) - Int(roundedEdgeRadius) * 2) / maxFrequency;

        for _ in 0...maxFrequency-1 {
//            var debugView = UIView(frame: CGRectMake(path.currentPoint.x - CGFloat(roundedEdgeRadius), path.currentPoint.y, CGFloat(roundedEdgeRadius*2), CGFloat(segmentLength)));
//            debugView.backgroundColor = UIColor.blackColor();
//            debugView.alpha = 0.3;
//            addSubview(debugView);

            var randomX = Int.random(Int(path.currentPoint.x - CGFloat(roundedEdgeRadius))...Int(path.currentPoint.x + CGFloat(roundedEdgeRadius)));
            var randomY = Int.random(Int(path.currentPoint.y)...Int(path.currentPoint.y) + segmentLength);
            var randomPoint = CGPointMake(CGFloat(randomX), CGFloat(randomY));

            path.addQuadCurveToPoint(CGPointMake(path.currentPoint.x, path.currentPoint.y + CGFloat(segmentLength)), controlPoint: randomPoint);
        }

        // bottom-right corner
        path.addArcWithCenter(CGPointMake(squigglyRect.origin.x + squigglyRect.size.width - roundedEdgeRadius, squigglyRect.origin.y + squigglyRect.height - roundedEdgeRadius), radius: roundedEdgeRadius, startAngle: 0, endAngle: CGFloat(0.5*pi), clockwise: true);

        // bottomright -> bottomleft
        segmentLength = (Int(squigglyRect.width) - Int(roundedEdgeRadius) * 2) / maxFrequency;

        for _ in 0...maxFrequency-1 {
//            var debugView = UIView(frame: CGRectMake(path.currentPoint.x - CGFloat(segmentLength), path.currentPoint.y - CGFloat(roundedEdgeRadius), CGFloat(segmentLength), CGFloat(roundedEdgeRadius*2)));
//            debugView.backgroundColor = UIColor.blackColor();
//            debugView.alpha = 0.3;
//            addSubview(debugView);

            var randomX = Int.random(Int(path.currentPoint.x - CGFloat(segmentLength))...Int(path.currentPoint.x));
            var randomY = Int.random(Int(path.currentPoint.y - roundedEdgeRadius)...Int(path.currentPoint.y + roundedEdgeRadius));
            var randomPoint = CGPointMake(CGFloat(randomX), CGFloat(randomY));

            path.addQuadCurveToPoint(CGPointMake(path.currentPoint.x - CGFloat(segmentLength), path.currentPoint.y), controlPoint: randomPoint);
        }

        // bottom-left corner
        path.addArcWithCenter(CGPointMake(squigglyRect.origin.x + roundedEdgeRadius, squigglyRect.origin.y + squigglyRect.height - roundedEdgeRadius), radius: roundedEdgeRadius, startAngle: CGFloat(0.5*pi), endAngle: CGFloat(pi), clockwise: true);

        // bottomleft -> topleft
        segmentLength = (Int(squigglyRect.height) - Int(roundedEdgeRadius) * 2) / maxFrequency;

        for _ in 0...maxFrequency-1 {
//            var debugView = UIView(frame: CGRectMake(path.currentPoint.x - CGFloat(roundedEdgeRadius), path.currentPoint.y - CGFloat(segmentLength), CGFloat(roundedEdgeRadius*2), CGFloat(segmentLength)));
//            debugView.backgroundColor = UIColor.blackColor();
//            debugView.alpha = 0.3;
//            addSubview(debugView);

            var randomX = Int.random(Int(path.currentPoint.x - CGFloat(roundedEdgeRadius))...Int(path.currentPoint.x + CGFloat(roundedEdgeRadius)));
            var randomY = Int.random(Int(path.currentPoint.y - CGFloat(segmentLength))...Int(path.currentPoint.y));
            var randomPoint = CGPointMake(CGFloat(randomX), CGFloat(randomY));

            path.addQuadCurveToPoint(CGPointMake(path.currentPoint.x, path.currentPoint.y - CGFloat(segmentLength)), controlPoint: randomPoint);
        }

        path.closePath();
    }

    override func drawRect(rect: CGRect) {
        let gc = UIGraphicsGetCurrentContext();

        CGContextAddPath(gc, path.CGPath);

        CGContextSetFillColorWithColor(gc, UIColor.whiteColor().CGColor)

        let borderColor = UIColor(red: 2.0/255, green: 200.0/255, blue: 247.0/255, alpha: 1.0)
        CGContextSetLineWidth(gc, _borderWidth)
        CGContextSetStrokeColorWithColor(gc, borderColor.CGColor);

        CGContextSetShadowWithColor(gc, CGSizeMake(_shadowWidth/2.0, _shadowWidth/2.0), _shadowWidth, UIColor.grayColor().CGColor);

        CGContextDrawPath(gc, kCGPathFillStroke);
        CGContextDrawPath(gc, kCGPathFill);
        UIGraphicsEndImageContext();
    }
}
//
let view = SquigglyView(frame: CGRectMake(0, 0, 300, 400), maxAmplitudePixels: 0.25, maxFrequency: 3, roundedEdgeRadius: 8, borderWidth: 10, shadowWidth: 10);

view

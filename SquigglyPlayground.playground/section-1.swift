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
    var roundedEdgeRadius:CGFloat?;
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


    init(frame: CGRect, maxAmplitudePixels: CGFloat, maxFrequency: Int, roundedEdgeRadius: CGFloat) {
        super.init(frame: frame);

        // make a subRect inset by maxAmplitudePixels from our rect
        var squigglyRect = CGRectInset(frame, maxAmplitudePixels, maxAmplitudePixels);
        var aView = UIView(frame: squigglyRect);

        aView.backgroundColor = UIColor.whiteColor();
        aView.alpha = 0.3;
        self.addSubview(aView);

        // draw top left corner
        path.addArcWithCenter(CGPointMake(squigglyRect.origin.x + roundedEdgeRadius, squigglyRect.origin.y + roundedEdgeRadius), radius: roundedEdgeRadius, startAngle: CGFloat(pi), endAngle: CGFloat((3/2.0)*pi), clockwise: true);

        // topleft -> topright
        var segmentLength = (Int(squigglyRect.width) - Int(roundedEdgeRadius) * 2) / maxFrequency;

        var index: Int;
        for index = 0; index < maxFrequency; index++ {
            var aView = UIView(frame: CGRectMake(path.currentPoint.x, path.currentPoint.y - CGFloat(roundedEdgeRadius), CGFloat(segmentLength), CGFloat(roundedEdgeRadius*2)));
            aView.backgroundColor = UIColor.blackColor();
            aView.alpha = 0.3;
            addSubview(aView);

            Int.random(0...15);
            var randomX = Int.random(Int(path.currentPoint.x)...Int(path.currentPoint.x) + segmentLength);
            var randomY = Int.random(Int(path.currentPoint.y - roundedEdgeRadius)...Int(path.currentPoint.y + roundedEdgeRadius));
            var randomPoint = CGPointMake(CGFloat(randomX), CGFloat(randomY));

            path.addQuadCurveToPoint(CGPointMake(path.currentPoint.x + CGFloat(segmentLength), path.currentPoint.y), controlPoint: randomPoint);
            randomPoint;
//            path.addQuadCurveToPoint(<#endPoint: CGPoint#>, controlPoint: <#CGPoint#>)
        }

//        path.addArcWithCenter(CGPointMake(squigglyRect.origin.x + squigglyRect.size.width - roundedEdgeRadius, squigglyRect.origin.y + roundedEdgeRadius), radius: roundedEdgeRadius, startAngle: CGFloat((3/2.0)*pi), endAngle: 0, clockwise: true);
//
//        // topright -> bottomright
//        path.addArcWithCenter(CGPointMake(squigglyRect.origin.x + squigglyRect.size.width - roundedEdgeRadius, squigglyRect.origin.y + squigglyRect.height - roundedEdgeRadius), radius: roundedEdgeRadius, startAngle: 0, endAngle: CGFloat(0.5*pi), clockwise: true);
//
//        // bottomright -> bottomleft
//        path.addArcWithCenter(CGPointMake(squigglyRect.origin.x + roundedEdgeRadius, squigglyRect.origin.y + squigglyRect.height - roundedEdgeRadius), radius: roundedEdgeRadius, startAngle: CGFloat(0.5*pi), endAngle: CGFloat(pi), clockwise: true);
//
//        // bottomleft -> topleft
//        path.closePath();
    }

    override func drawRect(rect: CGRect) {
        let gc = UIGraphicsGetCurrentContext();

        CGContextSetStrokeColorWithColor(gc, UIColor.yellowColor().CGColor);
        path.stroke();

        UIGraphicsEndImageContext();
    }
}

//let superview = UIView(frame: CGRectMake(0, 0, 300, 300));
//superview.backgroundColor = UIColor.orangeColor();
let view = SquigglyView(frame: CGRectMake(0, 0, 200, 200), maxAmplitudePixels: 20, maxFrequency: 2, roundedEdgeRadius: 20);

//superview.addSubview(view);

//superview.clipsToBounds = false;
view.backgroundColor = UIColor.purpleColor();
//view.center = superview.center;

//superview
view

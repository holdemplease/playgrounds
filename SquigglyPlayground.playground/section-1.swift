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

    let _path = UIBezierPath();
    var _maxSquiggleAmplitude:CGFloat = 8
    var _squiggleFrequency:Int = 3
    var _roundedEdgeRadius:CGFloat = 24
    var _shadowWidth:CGFloat = 10
    var _borderWidth:CGFloat = 10
    var _borderColor:UIColor = UIColor(red: 2.0/255, green: 200.0/255, blue: 247.0/255, alpha: 1.0)
    var _fillColor:UIColor = UIColor.whiteColor()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    //     default init
    override init(frame: CGRect) {
        super.init(frame: frame)
        makePathForViewBorder()
    }

    // custom init
    init(frame: CGRect, borderColor: UIColor) {
        super.init(frame: frame)

        _borderColor = borderColor
        makePathForViewBorder()
    }

    // custom init
    init(frame: CGRect, maxAmplitudePixels: CGFloat, maxFrequency: Int, roundedEdgeRadius: CGFloat, borderWidth: CGFloat, shadowWidth: CGFloat, borderColor: UIColor, fillColor: UIColor) {
        super.init(frame: frame)

        _shadowWidth = shadowWidth
        _borderWidth = borderWidth
        _squiggleFrequency = maxFrequency
        _maxSquiggleAmplitude = maxAmplitudePixels
        _roundedEdgeRadius = roundedEdgeRadius
        _borderColor = borderColor
        _fillColor = fillColor

        makePathForViewBorder()
    }

    func randomInt(number: CGFloat) -> Int {
        return Int(arc4random_uniform(UInt32(number)))
    }

    func randomPointInRectangle(rectangle: CGRect) -> CGPoint {
        return CGPoint(x: randomInt(rectangle.size.width), y: randomInt(rectangle.size.height))
    }

    func makePathForViewBorder() {
//        println("starting makePathForViewBorder")
        var currentPoint:CGPoint?;

        self.backgroundColor = UIColor.clearColor()

        // make a subRect inset by _maxSquiggleAmplitude from our rect
        var squigglyRect = CGRectInset(frame, _maxSquiggleAmplitude + _borderWidth + _shadowWidth, _maxSquiggleAmplitude + _borderWidth + _shadowWidth);
        var segmentLength: Int

        // draw top left corner
        _path.addArcWithCenter(CGPointMake(squigglyRect.origin.x + _roundedEdgeRadius, squigglyRect.origin.y + _roundedEdgeRadius), radius: _roundedEdgeRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat((3/2.0)*M_PI), clockwise: true);

        // topleft -> topright
        segmentLength = (Int(squigglyRect.width) - Int(_roundedEdgeRadius) * 2) / _squiggleFrequency;

        for _ in 0..._squiggleFrequency-1 {
            var randomX = Int.random(Int(_path.currentPoint.x)...Int(_path.currentPoint.x) + segmentLength);
            var randomY = Int.random(Int(_path.currentPoint.y - _maxSquiggleAmplitude)...Int(_path.currentPoint.y + _maxSquiggleAmplitude));
            var randomPoint = CGPointMake(CGFloat(randomX), CGFloat(randomY));

            _path.addQuadCurveToPoint(CGPointMake(_path.currentPoint.x + CGFloat(segmentLength), _path.currentPoint.y), controlPoint: randomPoint);
        }

        // top-right corner
        _path.addArcWithCenter(CGPointMake(squigglyRect.origin.x + squigglyRect.size.width - _roundedEdgeRadius, squigglyRect.origin.y + _roundedEdgeRadius), radius: _roundedEdgeRadius, startAngle: CGFloat((3/2.0)*M_PI), endAngle: 0, clockwise: true);

        // topright -> bottomright
        segmentLength = (Int(squigglyRect.height) - Int(_roundedEdgeRadius) * 2) / _squiggleFrequency;

        for _ in 0..._squiggleFrequency-1 {
            var randomX = Int.random(Int(_path.currentPoint.x - CGFloat(_maxSquiggleAmplitude))...Int(_path.currentPoint.x + CGFloat(_maxSquiggleAmplitude)));
            var randomY = Int.random(Int(_path.currentPoint.y)...Int(_path.currentPoint.y) + segmentLength);
            var randomPoint = CGPointMake(CGFloat(randomX), CGFloat(randomY));

            _path.addQuadCurveToPoint(CGPointMake(_path.currentPoint.x, _path.currentPoint.y + CGFloat(segmentLength)), controlPoint: randomPoint);
        }

        // bottom-right corner
        _path.addArcWithCenter(CGPointMake(squigglyRect.origin.x + squigglyRect.size.width - _roundedEdgeRadius, squigglyRect.origin.y + squigglyRect.height - _roundedEdgeRadius), radius: _roundedEdgeRadius, startAngle: 0, endAngle: CGFloat(0.5*M_PI), clockwise: true);

        // bottomright -> bottomleft
        segmentLength = (Int(squigglyRect.width) - Int(_roundedEdgeRadius) * 2) / _squiggleFrequency;

        for _ in 0..._squiggleFrequency-1 {
            var randomX = Int.random(Int(_path.currentPoint.x - CGFloat(segmentLength))...Int(_path.currentPoint.x));
            var randomY = Int.random(Int(_path.currentPoint.y - _maxSquiggleAmplitude)...Int(_path.currentPoint.y + _maxSquiggleAmplitude));
            var randomPoint = CGPointMake(CGFloat(randomX), CGFloat(randomY));

            _path.addQuadCurveToPoint(CGPointMake(_path.currentPoint.x - CGFloat(segmentLength), _path.currentPoint.y), controlPoint: randomPoint);
        }

        // bottom-left corner
        _path.addArcWithCenter(CGPointMake(squigglyRect.origin.x + _roundedEdgeRadius, squigglyRect.origin.y + squigglyRect.height - _roundedEdgeRadius), radius: _roundedEdgeRadius, startAngle: CGFloat(0.5*M_PI), endAngle: CGFloat(M_PI), clockwise: true);

        // bottomleft -> topleft
        segmentLength = (Int(squigglyRect.height) - Int(_roundedEdgeRadius) * 2) / _squiggleFrequency;

        for _ in 0..._squiggleFrequency-1 {
            var randomX = Int.random(Int(_path.currentPoint.x - CGFloat(_maxSquiggleAmplitude))...Int(_path.currentPoint.x + CGFloat(_maxSquiggleAmplitude)));
            var randomY = Int.random(Int(_path.currentPoint.y - CGFloat(segmentLength))...Int(_path.currentPoint.y));
            var randomPoint = CGPointMake(CGFloat(randomX), CGFloat(randomY));

            _path.addQuadCurveToPoint(CGPointMake(_path.currentPoint.x, _path.currentPoint.y - CGFloat(segmentLength)), controlPoint: randomPoint);
        }
        _path.closePath();
//        println("finishing makePathForViewBorder")

        // gay hack since drawRect gets called before this method finishes execution
        // TO DO: fix it so the init function finishes execution before drawRect gets called and you don't need to do this hack
        self.setNeedsDisplay()
    }

    override func drawRect(rect: CGRect) {
        let gc = UIGraphicsGetCurrentContext()

        // Draw border path, shadow, and fill the view
        CGContextAddPath(gc, _path.CGPath);
        CGContextSetFillColorWithColor(gc, _fillColor.CGColor)
        CGContextSetLineWidth(gc, _borderWidth)
        CGContextSetStrokeColorWithColor(gc, _borderColor.CGColor)
        CGContextSetShadowWithColor(gc, CGSizeMake(_shadowWidth/2.0, _shadowWidth/2.0), _shadowWidth, UIColor.grayColor().CGColor);
        CGContextDrawPath(gc, kCGPathFillStroke);

        // Second needed rendering for filling over the inner shadow
        CGContextAddPath(gc, _path.CGPath);
        CGContextSetFillColorWithColor(gc, _fillColor.CGColor)
        CGContextSetLineWidth(gc, _borderWidth)
        CGContextSetStrokeColorWithColor(gc, _borderColor.CGColor);
        CGContextSetShadowWithColor(gc, CGSizeMake(0, 0), 0, UIColor.grayColor().CGColor);
        CGContextDrawPath(gc, kCGPathFillStroke);

        UIGraphicsEndImageContext();
    }
}

//let view = SquigglyView(frame: CGRectMake(0, 0, 300, 400), borderColor: UIColor.brownColor()) //SquigglyView(frame: CGRectMake(0, 0, 300, 400), maxAmplitudePixels: 0.25, maxFrequency: 3, roundedEdgeRadius: 8, borderWidth: 10, shadowWidth: 10)
let view = SquigglyView(frame: CGRectMake(0, 0, 300, 400)) //SquigglyView(frame: CGRectMake(0, 0, 300, 400), maxAmplitudePixels: 0.25, maxFrequency: 3, roundedEdgeRadius: 8, borderWidth: 10, shadowWidth: 10, borderColor: UIColor.purpleColor(), fillColor: UIColor.grayColor())

view

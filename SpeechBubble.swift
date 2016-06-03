//
//  SpeechBubble.swift
//  Bark
//
//  Created by Sebastian on 6/3/16.
//  Copyright © 2016 Bourbonshake. All rights reserved.
//

import UIKit

class SpeechBubble: UIView {
    let strokeColor: UIColor = UIColor.grayColor()
    let fillColor: UIColor = UIColor.whiteColor()
    var triangleHeight: CGFloat!
    var radius: CGFloat!
    var borderWidth: CGFloat!
    var edgeCurve: CGFloat!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required convenience init(baseView: UIView, text: String, fontSize: CGFloat = 17) {
        // Calculate relative sizes
        let padding = fontSize * 0.7
        let triangleHeight = fontSize * 0.5
        let radius = fontSize * 1.2
        let borderWidth = fontSize * 0.25
        let margin = fontSize * 0.14 // margin between the baseview and balloon
        let edgeCurve = fontSize * 0.14 // smaller the curvier

        let label = UILabel()
        label.font = UIFont.systemFontOfSize(fontSize)
        label.text = text
        let labelSize = label.intrinsicContentSize()

        let width = labelSize.width + padding * 3 // 50% more padding on width
        let height = labelSize.height + triangleHeight + padding * 2
        let bubbleRect = CGRectMake(baseView.center.x - width / 2, baseView.center.y - (baseView.bounds.height / 2) - (height + margin), width, height)

        self.init(frame: bubbleRect)

        self.triangleHeight = triangleHeight
        self.radius = radius
        self.borderWidth = borderWidth
        self.edgeCurve = edgeCurve

        label.frame = CGRect(x: padding, y: padding, width: labelSize.width + padding, height: labelSize.height)
        label.textAlignment = .Center
        label.textColor = strokeColor
        self.addSubview(label)
    }

    override func drawRect(rect: CGRect) {
        let bubble = CGRectMake(0, 0, rect.width - radius * 2, rect.height - (radius * 2 + triangleHeight)).offsetBy(dx: radius, dy: radius)
        let path = UIBezierPath()
        let radius2 = radius - borderWidth // Radius adjasted for the border width

        path.addArcWithCenter(CGPointMake(bubble.maxX, bubble.minY), radius: radius2, startAngle: CGFloat(-M_PI_2), endAngle: 0, clockwise: true)
        path.addArcWithCenter(CGPointMake(bubble.maxX, bubble.maxY), radius: radius2, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true)
        path.addLineToPoint(CGPointMake(bubble.minX + bubble.width / 2 + triangleHeight * 1.2, bubble.maxY + radius2))

        // The speech bubble edge
        path.addQuadCurveToPoint(CGPointMake(bubble.minX + bubble.width / 2, bubble.maxY + radius2 + triangleHeight), controlPoint: CGPointMake(bubble.minX + bubble.width / 2 + edgeCurve, bubble.maxY + radius2 + edgeCurve))
        path.addQuadCurveToPoint(CGPointMake(bubble.minX + bubble.width / 2 - triangleHeight * 1.2, bubble.maxY + radius2), controlPoint: CGPointMake(bubble.minX + bubble.width / 2 - edgeCurve, bubble.maxY + radius2 + edgeCurve))
        // For non-curvy edges
        // path.addLineToPoint(CGPointMake(bubble.minX + bubble.width / 2, bubble.maxY + radius2 + triangleHeight))
        // path.addLineToPoint(CGPointMake(bubble.minX + bubble.width / 2 - triangleHeight, bubble.maxY + radius2))

        path.addArcWithCenter(CGPointMake(bubble.minX, bubble.maxY), radius: radius2, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI), clockwise: true)
        path.addArcWithCenter(CGPointMake(bubble.minX, bubble.minY), radius: radius2, startAngle: CGFloat(M_PI), endAngle: CGFloat(-M_PI_2), clockwise: true)
        path.closePath()

        fillColor.setFill()
        strokeColor.setStroke()
        path.lineWidth = borderWidth
        path.stroke()
        path.fill()
    }
}

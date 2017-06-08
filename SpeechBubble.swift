//
//  SpeechBubble.swift
//  Bark
//
//  Created by Sebastian on 6/3/16.
//  Copyright © 2016 Bourbonshake. All rights reserved.
//

import UIKit

class SpeechBubble: UIView {
    let strokeColor: UIColor = UIColor.gray
    let fillColor: UIColor = UIColor.white
    var triangleHeight: CGFloat!
    var radius: CGFloat!
    var borderWidth: CGFloat!
    var edgeCurve: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
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
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.text = text
        let labelSize = label.intrinsicContentSize
        
        let width = labelSize.width + padding * 3 // 50% more padding on width
        let height = labelSize.height + triangleHeight + padding * 2
        let bubbleRect = CGRect(x: baseView.center.x - width / 2, y: baseView.center.y - (baseView.bounds.height / 2) - (height + margin), width: width, height: height)
        
        self.init(frame: bubbleRect)
        
        self.triangleHeight = triangleHeight
        self.radius = radius
        self.borderWidth = borderWidth
        self.edgeCurve = edgeCurve
        
        label.frame = CGRect(x: padding, y: padding, width: labelSize.width + padding, height: labelSize.height)
        label.textAlignment = .center
        label.textColor = strokeColor
        self.addSubview(label)
    }
    
    override func draw(_ rect: CGRect) {
        let bubble = CGRect(x: 0, y: 0, width: rect.width - radius * 2, height: rect.height - (radius * 2 + triangleHeight)).offsetBy(dx: radius, dy: radius)
        let path = UIBezierPath()
        let radius2 = radius - borderWidth // Radius adjasted for the border width
        
        path.addArc(withCenter: CGPoint(x: bubble.maxX, y: bubble.minY), radius: radius2, startAngle: CGFloat(-(Double.pi / 2)), endAngle: 0, clockwise: true)
        path.addArc(withCenter: CGPoint(x: bubble.maxX, y: bubble.maxY), radius: radius2, startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
        path.addLine(to: CGPoint(x: bubble.minX + bubble.width / 2 + triangleHeight * 1.2, y: bubble.maxY + radius2))
        
        // The speech bubble edge
        path.addQuadCurve(to: CGPoint(x: bubble.minX + bubble.width / 2, y: bubble.maxY + radius2 + triangleHeight), controlPoint: CGPoint(x: bubble.minX + bubble.width / 2 + edgeCurve, y: bubble.maxY + radius2 + edgeCurve))
        path.addQuadCurve(to: CGPoint(x: bubble.minX + bubble.width / 2 - triangleHeight * 1.2, y: bubble.maxY + radius2), controlPoint: CGPoint(x: bubble.minX + bubble.width / 2 - edgeCurve, y: bubble.maxY + radius2 + edgeCurve))
        // For non-curvy edges
        // path.addLineToPoint(CGPointMake(bubble.minX + bubble.width / 2, bubble.maxY + radius2 + triangleHeight))
        // path.addLineToPoint(CGPointMake(bubble.minX + bubble.width / 2 - triangleHeight, bubble.maxY + radius2))
        
        path.addArc(withCenter: CGPoint(x: bubble.minX, y: bubble.maxY), radius: radius2, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
        path.addArc(withCenter: CGPoint(x: bubble.minX, y: bubble.minY), radius: radius2, startAngle: CGFloat(Double.pi), endAngle: CGFloat(-Double.pi / 2), clockwise: true)
        path.close()
        
        fillColor.setFill()
        strokeColor.setStroke()
        path.lineWidth = borderWidth
        path.stroke()
        path.fill()
    }
}

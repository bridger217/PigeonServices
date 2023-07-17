//
//  HeartFillView.swift
//  PigeonServices
//
//  Created by Bridge Dudley on 7/13/23.
//

import Foundation
import UIKit

class HeartFillView: UIView {
    private var fillPercentage: CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let width = rect.width
        let height = rect.height
        let x = (bounds.width - width) / 2
        let y = (bounds.height - height) / 2
        
        // Draw empty heart outline
        let emptyHeartPath = UIBezierPath(heartIn: CGRect(x: x, y: y, width: width, height: height))
        context.addPath(emptyHeartPath.cgPath)
        context.setStrokeColor(UIColor.gray.cgColor)
        context.setLineWidth(2)
        context.strokePath()
        
        // Draw filled heart shape
        let filledHeight = height * fillPercentage
        let filledHeartPath = UIBezierPath(heartIn: CGRect(x: x, y: y + (height - filledHeight), width: width, height: filledHeight))
        context.addPath(filledHeartPath.cgPath)
        context.setFillColor(UIColor.red.cgColor)
        context.fillPath()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first {
            updateFillPercentage(with: touch)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        if let touch = touches.first {
            updateFillPercentage(with: touch)
        }
    }
    
    private func updateFillPercentage(with touch: UITouch) {
        let location = touch.location(in: self)
        let fillPercentage = (bounds.height - location.y) / bounds.height
        self.fillPercentage = max(0.0, min(fillPercentage, 1.0))
        setNeedsDisplay()
    }
}

extension UIBezierPath {
    convenience init(heartIn rect: CGRect) {
        self.init()
        
        let width = rect.width
        let height = rect.height
        let x = rect.origin.x
        let y = rect.origin.y
        
        let topCurveHeight = height * 0.5
        let bottomCurveHeight = height * 0.4
        
        move(to: CGPoint(x: x + width / 2, y: y))
        
        // Top left curve
        addCurve(to: CGPoint(x: x, y: y + topCurveHeight),
                 controlPoint1: CGPoint(x: x + width * 0.1, y: y),
                 controlPoint2: CGPoint(x: x, y: y + topCurveHeight * 0.3))
        
        // Top right curve
        addCurve(to: CGPoint(x: x + width / 2, y: y + topCurveHeight + bottomCurveHeight),
                 controlPoint1: CGPoint(x: x, y: y + topCurveHeight * 1.7),
                 controlPoint2: CGPoint(x: x + width * 0.1, y: y + topCurveHeight + bottomCurveHeight * 0.7))
        
        // Bottom left curve
        addCurve(to: CGPoint(x: x + width, y: y + topCurveHeight),
                 controlPoint1: CGPoint(x: x + width * 0.9, y: y + topCurveHeight + bottomCurveHeight * 0.7),
                 controlPoint2: CGPoint(x: x + width, y: y + topCurveHeight * 1.7))
        
        // Bottom right curve
        addCurve(to: CGPoint(x: x + width / 2, y: y),
                 controlPoint1: CGPoint(x: x + width, y: y + topCurveHeight * 0.3),
                 controlPoint2: CGPoint(x: x + width * 0.9, y: y))
        
        close()
    }
}

//
//  ProgressCircle.swift
//  circleTest
//
//  Created by Mateusz Chojnacki on 2/8/18.
//  Copyright © 2018 Mateusz Chojnacki. All rights reserved.
//

import UIKit

class ProgressCircle: CAShapeLayer {
    
    var shapeLayer: CAShapeLayer?
    var currentView: UIView?
    
    override init() {
        super.init()
    }
    
    init(view: UIView) {
        super.init()
        self.currentView = view
        self.shapeLayer = CAShapeLayer()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        let center = CGPoint(x: (currentView?.bounds.width)!/2, y: (currentView?.bounds.height)!/2)
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = kCALineCapRound
        
        currentView?.layer.addSublayer(trackLayer)
        shapeLayer?.path = circularPath.cgPath
        shapeLayer?.strokeColor = UIColor.blue.cgColor
        shapeLayer?.lineWidth = 10
        shapeLayer?.fillColor = UIColor.clear.cgColor
        shapeLayer?.lineCap = kCALineCapRound
        
        shapeLayer?.strokeEnd = 0
        
        currentView?.layer.addSublayer(shapeLayer!)
    }
    
    func update(currentValue: Float){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = currentValue
        
        basicAnimation.duration = 2
        
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer?.add(basicAnimation, forKey: "urSoBasic")
    }
}


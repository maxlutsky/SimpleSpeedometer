//
//  SpeedometerView.swift
//  Animated Speedometer
//
//  Created by Max on 05/05/2021.
//

import UIKit

public struct GaugeElemet {
    let color: UIColor
    let thikness: CGFloat
    let percents: CGFloat
    
    public init(color: UIColor, thikness: CGFloat, percents: CGFloat) {
        self.color = color
        self.thikness = thikness
        self.percents = percents
    }
}

public class SpeedometerView: UIView {
    
    var needleColor = UIColor.black
    var needleWidth: CGFloat = 4
    let needle = CAShapeLayer()
    
    var currentProgress: CGFloat = 0
    
    dynamic var progress: CGFloat = 0.00 {
            didSet {
                let animation = CABasicAnimation()
                animation.keyPath = "transform.rotation.z"
                animation.fromValue = getRadians(degrees: currentProgress)
                animation.toValue = getRadians(degrees: progress)
                animation.duration = CFTimeInterval(abs(currentProgress - progress)/100)
                animation.isRemovedOnCompletion = false
                animation.fillMode = CAMediaTimingFillMode.forwards;
                needle.add(animation, forKey: "transform.rotation.z")
                currentProgress = progress
            }
        }
    
    init(){
        let frame = CGRect(x: 0, y: 0, width: CGFloat(UIScreen.main.bounds.width*0.8), height: 300)
        super.init(frame: frame)
        buildGauge(frame: frame)
        setupNeedle(in: frame)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildGauge(frame: frame)
        setupNeedle(in: frame)
    }
    
    public init(frame: CGRect, gaugeElements: [GaugeElemet]) {
        super.init(frame: frame)
        buildGauge(frame: frame, gaugeElements: gaugeElements)
        setupNeedle(in: frame)
    }
    
    func buildGauge(frame: CGRect, gaugeElements: [GaugeElemet]) {
        let needleBase = CAShapeLayer()
        needleBase.path = UIBezierPath(arcCenter: center,
                                          radius: frame.size.width/20,
                                          startAngle: 0,
                                          endAngle: 360,
                                          clockwise: true).cgPath
        needleBase.fillColor = UIColor.black.cgColor
        needleBase.strokeEnd = 1.0
        layer.addSublayer(needleBase)
        
        let radius = frame.size.width / 2
        let center = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
        var previousEndAngle: CGFloat?
        
        for element in gaugeElements {
            let speedometerPart = CAShapeLayer()
            speedometerPart.path = UIBezierPath(arcCenter: center,
                                                radius: radius - element.thikness/2,
                                                startAngle: previousEndAngle ?? CGFloat.pi,
                                                endAngle: (previousEndAngle ?? CGFloat.pi) + CGFloat.pi * element.percents / 100,
                                                clockwise: true).cgPath
            previousEndAngle = (previousEndAngle ?? CGFloat.pi) + CGFloat.pi * element.percents / 100
            speedometerPart.fillColor = UIColor.clear.cgColor
            speedometerPart.lineWidth = element.thikness
            speedometerPart.strokeColor = element.color.cgColor
            speedometerPart.strokeEnd = 1.0
            layer.addSublayer(speedometerPart)
        }
    }
    
    func buildGauge(frame: CGRect){
        let speedometerPart1 = CAShapeLayer()
        let speedometerPart2 = CAShapeLayer()
        let speedometerPart3 = CAShapeLayer()
        let needleBase = CAShapeLayer()
        
        
        let radius = (frame.size.width - 10)/2
        let thikness: CGFloat = 30
        let center = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
        
        let part1 = (CGFloat.pi * 3 / 2) - 0.3
        let part2 = (CGFloat.pi * 3 / 2) + 0.3
        
        let speedometerPath1 = UIBezierPath(arcCenter: center,
                                            radius: radius,
                                            startAngle: CGFloat.pi,
                                            endAngle: part1,
                                            clockwise: true)
        
        let speedometerPath2 = UIBezierPath(arcCenter: center,
                                            radius: radius,
                                            startAngle: part1,
                                            endAngle: part2,
                                            clockwise: true)

        let speedometerPath3 = UIBezierPath(arcCenter: center,
                                            radius: radius,
                                            startAngle: part2,
                                            endAngle: CGFloat(0),
                                            clockwise: true)
        
        let needleBasePath = UIBezierPath(arcCenter: center,
                                          radius: frame.size.width/20,
                                          startAngle: 0,
                                          endAngle: 360,
                                          clockwise: true)
        
        speedometerPart1.path = speedometerPath1.cgPath
        speedometerPart2.path = speedometerPath2.cgPath
        speedometerPart3.path = speedometerPath3.cgPath
        needleBase.path = needleBasePath.cgPath
        
        speedometerPart1.fillColor = UIColor.clear.cgColor
        speedometerPart2.fillColor = UIColor.clear.cgColor
        speedometerPart3.fillColor = UIColor.clear.cgColor
        needleBase.fillColor = UIColor.black.cgColor
        
        speedometerPart1.strokeColor = UIColor.red.cgColor
        speedometerPart2.strokeColor = UIColor.yellow.cgColor
        speedometerPart3.strokeColor = UIColor.green.cgColor
        
        speedometerPart1.lineWidth = thikness
        speedometerPart2.lineWidth = thikness
        speedometerPart3.lineWidth = thikness
        
        speedometerPart1.strokeEnd = 1.0
        speedometerPart2.strokeEnd = 1.0
        speedometerPart3.strokeEnd = 1.0
        needleBase.strokeEnd = 1.0
        
        layer.addSublayer(speedometerPart1)
        layer.addSublayer(speedometerPart2)
        layer.addSublayer(speedometerPart3)
        layer.addSublayer(needleBase)
    }
    
    required init?(coder: NSCoder) {
        let frame = CGRect(x: 0, y: 0, width: CGFloat(UIScreen.main.bounds.width*0.8), height: 300)
        super.init(frame: frame)
        buildGauge(frame: frame)
        setupNeedle(in: frame)
    }
    
    func setupNeedle(in rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 20, y: rect.height/2))
        path.addLine(to: CGPoint(x: rect.width/2, y: rect.height/1.9))
        path.addLine(to: CGPoint(x: rect.width/2, y: rect.height - rect.height/1.9))
        
        needle.path = path.cgPath
        needle.fillColor = UIColor.black.cgColor
        needle.frame = rect
        needle.strokeEnd = 1.0

        let point = CGPoint(x: 0.5, y: 0.5)
        setAnchorForLayer(anchor: point, layer: needle)
        layer.addSublayer(needle)
        
    }
    
    public func setValue(percents: Int) {
        if percents <= 100 && percents >= 0 {
            progress = CGFloat(percents * 180 / 100)
        }
    }
    
    func getRadians(degrees: CGFloat) -> CGFloat {
        degrees * CGFloat.pi / 180
    }
    
    func setAnchorForLayer(anchor: CGPoint, layer: CALayer){
        var newPoint = CGPoint(x: bounds.size.width * anchor.x, y: bounds.size.height * anchor.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = anchor
    }
}

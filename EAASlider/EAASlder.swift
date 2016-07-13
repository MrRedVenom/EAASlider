//
//  EAASlider.swift
//
//  Created by Андрей Ежов on 10.07.16.
//  Copyright © 2016 Ezhov Andrey. All rights reserved.
//

import UIKit
import Foundation

class EAAFakeView: UIView {
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return false
    }
}

class EAAFakeLabel: UILabel {
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return false
    }
}

class EAASlider: UIControl {
    
    var value: CGFloat = 3
    var minimumValue: CGFloat = 3
    var maximumValue: CGFloat = 8
    var title : NSString?
    
    var sliderBackgroundColor: UIColor?
    var font : UIFont = UIFont.systemFontOfSize(12)
    
    let valueLabel = EAAFakeLabel()
    let viewForLabel = EAAFakeView()
    
    private var widthConstr : NSLayoutConstraint?
    private var widthConstrConst : NSLayoutConstraint?
    
    private var xConstr : NSLayoutConstraint?
    private var yConstr : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    
    func setup() {
        
        sliderBackgroundColor = self.backgroundColor
        self.backgroundColor = UIColor.clearColor()
        
        self.addSubview(viewForLabel)
        viewForLabel.layer.cornerRadius = 5
        viewForLabel.layer.borderWidth = 1
        viewForLabel.layer.borderColor = UIColor.clearColor().CGColor
        viewForLabel.clipsToBounds = false
        viewForLabel.translatesAutoresizingMaskIntoConstraints = false
        
        title = "Battery, V"
        viewForLabel.addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.checkValue()
        valueLabel.textAlignment = NSTextAlignment.Center
        
        let hConstrLabel = NSLayoutConstraint(item: valueLabel,
                                              attribute: NSLayoutAttribute.Height,
                                              relatedBy: NSLayoutRelation.Equal,
                                              toItem: viewForLabel,
                                              attribute: NSLayoutAttribute.Height,
                                              multiplier: 1,
                                              constant: 0);
        let wConstrLabel = NSLayoutConstraint(item: valueLabel,
                                              attribute: NSLayoutAttribute.Width,
                                              relatedBy: NSLayoutRelation.Equal,
                                              toItem: nil,
                                              attribute: NSLayoutAttribute.NotAnAttribute,
                                              multiplier: 1,
                                              constant: 100);
        let xConstrLabel = NSLayoutConstraint(item: valueLabel,
                                              attribute: NSLayoutAttribute.CenterX,
                                              relatedBy: NSLayoutRelation.Equal,
                                              toItem: viewForLabel,
                                              attribute: NSLayoutAttribute.CenterX,
                                              multiplier: 1,
                                              constant: 0);
        let yConstrLabel = NSLayoutConstraint(item: valueLabel,
                                              attribute: NSLayoutAttribute.CenterY,
                                              relatedBy: NSLayoutRelation.Equal,
                                              toItem: viewForLabel,
                                              attribute: NSLayoutAttribute.CenterY,
                                              multiplier: 1,
                                              constant: 0);
        viewForLabel.addConstraints([hConstrLabel, wConstrLabel, xConstrLabel, yConstrLabel])
        
        
        let hConstr = NSLayoutConstraint(item: viewForLabel,
                                         attribute: NSLayoutAttribute.Height,
                                         relatedBy: NSLayoutRelation.Equal,
                                         toItem: nil,
                                         attribute: NSLayoutAttribute.NotAnAttribute,
                                         multiplier: 1,
                                         constant: 30);
        
        xConstr = NSLayoutConstraint(item: viewForLabel,
                                     attribute: NSLayoutAttribute.CenterX,
                                     relatedBy: NSLayoutRelation.Equal,
                                     toItem: self,
                                     attribute: NSLayoutAttribute.CenterX,
                                     multiplier: 1,
                                     constant: 0);
        
        widthConstr = NSLayoutConstraint(item: viewForLabel,
                                         attribute: NSLayoutAttribute.Width,
                                         relatedBy: NSLayoutRelation.Equal,
                                         toItem: self,
                                         attribute: NSLayoutAttribute.Width,
                                         multiplier: 1,
                                         constant: 0);
        
        yConstr = NSLayoutConstraint(item: viewForLabel,
                                     attribute: NSLayoutAttribute.CenterY,
                                     relatedBy: NSLayoutRelation.Equal,
                                     toItem: self,
                                     attribute: NSLayoutAttribute.CenterY,
                                     multiplier: 1.3,
                                     constant: 0);
        
        self.addConstraints([hConstr, xConstr!, widthConstr!, yConstr!])
    }
    
    func toDefaultConstr() {
        xConstr!.constant = 0
        widthConstrConst?.active = false
        widthConstr?.active = true
        yConstr!.constant = 0
    }
    
    func constrToCurrentPoint(point : CGPoint) {
        
        let x = CGFloat(fminf(fmaxf(Float(point.x), 0), Float(self.frame.width)))
        
        let const = fmin(fmax(point.x - self.frame.width/2, 40 - self.frame.width/2), self.frame.width/2 - 40)
        
        value = (maximumValue - minimumValue) * (x/self.frame.width) + minimumValue
        self.checkValue()
        
        xConstr!.constant = CGFloat(const)
        widthConstr?.active = false
        
        if widthConstrConst == nil {
            widthConstrConst = NSLayoutConstraint(item: viewForLabel,
                                                  attribute: NSLayoutAttribute.Width,
                                                  relatedBy: NSLayoutRelation.Equal,
                                                  toItem: nil,
                                                  attribute: NSLayoutAttribute.NotAnAttribute,
                                                  multiplier: 1,
                                                  constant: 80);
            self.addConstraint(widthConstrConst!)
        } else {
            widthConstrConst?.active = true
        }
        
        yConstr!.constant = -50
        
        self.setNeedsDisplay()
    }
    
    func checkValue () {
        valueLabel.text = String(format: "%.1f", value)
    }
    
    //MARK: Customization
    
    func setupBackgroundColor(color: UIColor) {
        sliderBackgroundColor = color
        self.viewForLabel.layer.backgroundColor = self.sliderBackgroundColor?.colorWithAlphaComponent(0.5).CGColor
        self.viewForLabel.layer.borderColor = self.sliderBackgroundColor?.CGColor
        setNeedsDisplay()
    }
    
    //MARK: Drawing
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let path = UIBezierPath(roundedRect: CGRectMake(1, 10, rect.width-2, rect.height-11), cornerRadius: 5)
        sliderBackgroundColor!.colorWithAlphaComponent(0.5).setFill()
        path.fill()
        
        sliderBackgroundColor!.setStroke()
        path.lineWidth = 1
        path.stroke()
        
        let pathFill = UIBezierPath(roundedRect: CGRectMake(1, 10, rect.width*(value - minimumValue)/(maximumValue-minimumValue), rect.height-11), cornerRadius: 5)
        sliderBackgroundColor!.colorWithAlphaComponent(0.4).setFill()
        pathFill.fill()
        
        if (title != nil) {
            let textSize = title!.sizeWithAttributes([NSFontAttributeName : font])
            let textRect = CGRectMake((rect.width - textSize.width - textSize.height)/2,
                                      10 - textSize.height/2,
                                      textSize.width+textSize.height,
                                      textSize.height+2)
            
            let titlePath = UIBezierPath(roundedRect: textRect, cornerRadius: textSize.height/2)
            UIColor.whiteColor().setFill()
            titlePath.fill()
            
            sliderBackgroundColor!.colorWithAlphaComponent(0.5).setFill()
            titlePath.fill()
            
            sliderBackgroundColor!.setStroke()
            titlePath.lineWidth = 1
            titlePath.stroke()
            
            let style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.Center
            
            title?.drawInRect(textRect, withAttributes:
                [NSFontAttributeName : font, NSParagraphStyleAttributeName : style])
        }
        
        let ctx = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(ctx, 1);
        for i in 0...3 {
            CGContextMoveToPoint(ctx, CGFloat(i)*self.frame.width/4, 15);
            CGContextAddLineToPoint(ctx, CGFloat(i)*self.frame.width/4, self.frame.height - 5);
        }
        
        sliderBackgroundColor!.colorWithAlphaComponent(0.3).setStroke()
        
        CGContextStrokePath(ctx);
    }
    
    //MARK: Tracking
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        constrToCurrentPoint(touch.previousLocationInView(self))
        animation {
            self.viewForLabel.layer.backgroundColor = self.sliderBackgroundColor?.colorWithAlphaComponent(0.5).CGColor
            self.viewForLabel.layer.borderColor = self.sliderBackgroundColor?.CGColor
        }
        
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        toDefaultConstr()
        animation {
            self.viewForLabel.layer.backgroundColor = UIColor.clearColor().CGColor
            self.viewForLabel.layer.borderColor = UIColor.clearColor().CGColor
        }
        
        super.endTrackingWithTouch(touch, withEvent: event)
    }
    
    override func cancelTrackingWithEvent(event: UIEvent?) {
        toDefaultConstr()
        animation {
            self.viewForLabel.layer.backgroundColor = UIColor.clearColor().CGColor
            self.viewForLabel.layer.borderColor = UIColor.clearColor().CGColor
        }
        
        super.cancelTrackingWithEvent(event)
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        constrToCurrentPoint(touch.previousLocationInView(self))
        self.layoutIfNeeded()
        self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        return true
    }
    
    //MARK: animation
    
    func animation(block : () -> Void) {
        UIView.animateWithDuration(0.5,
                                   delay: 0,
                                   usingSpringWithDamping: 0.6,
                                   initialSpringVelocity: 0.5,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: {
                                    block()
                                    self.layoutIfNeeded()
            },
                                   completion: nil)
    }
    
}

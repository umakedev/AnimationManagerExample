//
//  AnimationManager.swift
//  AnimationManagerExample
//
//  Created by Shai Balassiano on 22/02/2017.
//  Copyright © 2017 Umake. All rights reserved.
//

import Foundation
import pop
struct AnimationManager {
    
    enum Duration {
        case zero// = 0
        case defaultDuration// = 0.25
        case long// = 1
        case variable(Double)
        
        var rawValue: Double {
            switch self {
            case .zero:
                return 0
            case .defaultDuration:
                return 0.25
            case .long:
                return 1
            case .variable(let value):
                return max(0, value)
            }
        }
    }
    
    enum TimingFunctionType {
        case defaultType
        case linear
        case easeIn
        case easeOut
        case easeInEaseOut
        
        func name() -> String {
            switch self {
            case .defaultType:
                return kCAMediaTimingFunctionDefault
            case .linear:
                return kCAMediaTimingFunctionLinear
            case .easeIn:
                return kCAMediaTimingFunctionEaseIn
            case .easeOut:
                return kCAMediaTimingFunctionEaseOut
            case .easeInEaseOut:
                return kCAMediaTimingFunctionEaseInEaseOut
            }
        }
        
        func function() -> CAMediaTimingFunction {
            return CAMediaTimingFunction(name: name())
        }
    }
    
    class BasicAnimation {
        fileprivate func animation(property: String, toValue: Double, duration: Duration, beginTime: Double?, timingFunctionType: TimingFunctionType, completion: ((Bool) -> ())?) -> POPBasicAnimation
        {
            let basicAnimation = POPBasicAnimation(propertyNamed: property)
            basicAnimation?.timingFunction = timingFunctionType.function()
            basicAnimation?.toValue = toValue
            basicAnimation?.duration = duration.rawValue
            basicAnimation?.beginTime = beginTime ?? 0
            basicAnimation?.completionBlock = { (animaiton: POPAnimation?, success: Bool) in
                completion?(success)
            }
            
            return basicAnimation!
        }
    }
    
    class SpringAninmation
    {
        fileprivate func animation(property: String, toValue: CGFloat, beginTime: Double?, dynamicsMass: CGFloat, completion: ((Bool) -> ())?) -> POPSpringAnimation
        {
            let springAnimation = POPSpringAnimation(propertyNamed: property)
            springAnimation?.toValue = toValue
            springAnimation?.beginTime = beginTime ?? 0
            springAnimation?.dynamicsMass = dynamicsMass
            springAnimation?.completionBlock = { (animaiton: POPAnimation?, success: Bool) in
                completion?(success)
            }
            
            return springAnimation!
        }
    }
    
    struct View {
        let basic: Basic
        
        init(view: UIView) {
            self.basic = Basic(view: view)
        }
        
        class Basic: BasicAnimation
        {
            private weak var view: UIView?
            init(view: UIView) {
                self.view = view
            }
            
            func alpha(toValue: Double, beginTime: Double? = nil, duration: Duration = .defaultDuration, timingFunctionType: TimingFunctionType, completion: ((_ success: Bool) -> ())? = nil)
            {
                let alphaViewAnimation = animation(property: kPOPLayerPositionY, toValue: toValue, duration: duration, beginTime: beginTime, timingFunctionType: timingFunctionType, completion: completion)
                
                let key = "AnimationManager_Alpha"
                view?.pop_removeAnimation(forKey: key)
                view?.pop_add(alphaViewAnimation, forKey: key)
            }
        }
    }
    
    struct Layer
    {
        let basic: Basic
        let spring: Spring
        
        enum TransitionFrom
        {
            case top
            case bottom
            case left
            case right
            
            func function() -> String
            {
                switch self {
                case .top:
                    return kCATransitionFromTop
                case .bottom:
                    return kCATransitionFromBottom
                case .left:
                    return kCATransitionFromLeft
                case .right:
                    return kCATransitionFromRight
                }
                
            }
        }
        
        enum Transition
        {
            case fade
            case push
            case moveIn
            case reveal
            
            func function() -> String
            {
                switch self {
                case .fade:
                    return kCATransitionFade
                case .push:
                    return kCATransitionPush
                case .moveIn:
                    return kCATransitionMoveIn
                case .reveal:
                    return kCATransitionReveal
                }
                
            }
        }
        
        private weak var layer: CALayer?
        init(layer: CALayer)
        {
            self.layer = layer
            self.basic = Basic(layer: layer)
            self.spring = Spring(layer: layer)
        }
        
        class Basic: BasicAnimation
        {
            private weak var layer: CALayer?
            init(layer: CALayer)
            {
                self.layer = layer
            }
            
            func positionY(toValue: Double, duration: Duration = .defaultDuration, beginTime: Double? = nil, timingFunctionType: TimingFunctionType = .defaultType, completion: ((Bool) -> ())? = nil)
            {
                let positionYAnimation = animation(property: kPOPLayerPositionY, toValue: toValue, duration: duration, beginTime: beginTime, timingFunctionType: timingFunctionType, completion: completion)
                
                let key = "AnimationManager_PositionY"
                layer?.pop_removeAnimation(forKey: key)
                layer?.pop_add(positionYAnimation, forKey: key)
            }
            
            func positionX(toValue: Double, duration: Duration = .defaultDuration, beginTime: Double? = nil, timingFunctionType: TimingFunctionType = .defaultType, completion: ((Bool) -> ())? = nil)
            {
                let slideLayerAnimation = animation(property: kPOPLayerTranslationX, toValue: toValue, duration: duration, beginTime: beginTime, timingFunctionType: timingFunctionType, completion: completion)
                
                let key = "AnimationManager_PositionX"
                layer?.pop_removeAnimation(forKey: key)
                layer?.pop_add(slideLayerAnimation, forKey: nil)
            }
        }
        
        class Spring: SpringAninmation
        {
            private weak var layer: CALayer?
            init(layer: CALayer)
            {
                self.layer = layer
            }
            
            func positionY(toValue: CGFloat, beginTime: Double? = nil, dynamicsMass: CGFloat, completion: ((Bool) -> ())? = nil)
            {
                let positionYAnimation = animation(property: kPOPLayerPositionY, toValue: toValue, beginTime: beginTime, dynamicsMass: dynamicsMass, completion: completion)
                
                let key = "AnimationManager_PositionY"
                layer?.pop_removeAnimation(forKey: key)
                layer?.pop_add(positionYAnimation, forKey: key)
            }
            
            func positionX(toValue: CGFloat, beginTime: Double? = nil, dynamicsMass: CGFloat, completion: ((Bool) -> ())? = nil)
            {
                let slideLayerAnimation = animation(property: kPOPLayerTranslationX, toValue: toValue, beginTime: beginTime, dynamicsMass: dynamicsMass, completion: completion)
                
                let key = "AnimationManager_PositionX"
                layer?.pop_removeAnimation(forKey: key)
                layer?.pop_add(slideLayerAnimation, forKey: nil)
            }
        }
        
        func transition(type: Transition, from: TransitionFrom, duration: Duration = .defaultDuration, beginTime: Double? = nil, timingFunctionType: TimingFunctionType = .defaultType, completion: ((Bool) -> ())? = nil)
        {
            let animation: CATransition = CATransition()
            animation.timingFunction = timingFunctionType.function()
            animation.type = type.function()
            animation.subtype = from.function()
            animation.duration = duration.rawValue
            layer?.add(animation, forKey: nil)
        }
    }
    
    
    struct Constraint {
        let basic: Basic
        
        init(constraint: NSLayoutConstraint) {
            self.basic = Basic(constraint: constraint)
        }
        
        class Basic: BasicAnimation
        {
            private weak var constraint: NSLayoutConstraint?
            init(constraint: NSLayoutConstraint)
            {
                self.constraint = constraint
            }
            
            func set(constant: CGFloat, duration: Duration = .defaultDuration, beginTime: Double? = nil, timingFunctionType: TimingFunctionType = .defaultType, completion: ((_ success: Bool) -> ())? = nil)
            {
                let setConstantAnimation = animation(property: kPOPLayoutConstraintConstant, toValue: Double(constant), duration: duration, beginTime: beginTime, timingFunctionType: timingFunctionType, completion: completion)
                
                let key = "Constraint_setConstant"
                self.constraint?.pop_removeAnimation(forKey: key)
                self.constraint?.pop_add(setConstantAnimation, forKey: key)
            }
        }
    }
    
    struct ImageView
    {
        private weak var imageView: UIImageView?
        init(imageView: UIImageView)
        {
            self.imageView = imageView
        }
        
        func set(image: UIImage?, duration: Duration = .defaultDuration) {
            imageView?.image = image
            
            let transition = CATransition()
            transition.duration = duration.rawValue
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade;
            
            imageView?.layer.add(transition, forKey: nil);
            
        }
    }
}

extension NSLayoutConstraint {
    var animationManager: AnimationManager.Constraint {
        return AnimationManager.Constraint(constraint: self)
    }
}
extension UIView {
    var animationManager: AnimationManager.View {
        return AnimationManager.View(view: self)
    }
}

extension CALayer {
    var animationManager: AnimationManager.Layer {
        return AnimationManager.Layer(layer: self)
    }
}

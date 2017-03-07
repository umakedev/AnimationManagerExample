//
//  TopMenuViewController.swift
//  AnimationManagerExample
//
//  Created by Shai Balassiano on 22/02/2017.
//  Copyright © 2017 Umake. All rights reserved.
//

import UIKit
import pop

class TopMenuViewController: UIViewController
{
    @IBOutlet fileprivate weak var brushesStackView: UIStackView!
    @IBOutlet fileprivate weak var penButton: UIButton!
    @IBOutlet fileprivate weak var pencilButton: UIButton!
    @IBOutlet fileprivate weak var surfaceButton: UIButton!
    
    @IBOutlet fileprivate weak var paletteStackViewBackgroundView: UIView!
    @IBOutlet fileprivate weak var wrapperStackViewToggleConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var paletteStackView: UIStackView!
    @IBOutlet fileprivate weak var wrapperStackView: UIStackView!
    @IBOutlet fileprivate weak var duplicateButton: UIButton!
    @IBOutlet fileprivate weak var backButton: UIButton!
    @IBOutlet fileprivate weak var paletteView: UIView!
    
    private func orderedButtons() -> [UIButton] {
        return [pencilButton, penButton, surfaceButton]
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        togglePaletteStackView(show: false, animated: false)
    }
    
    func show()
    {
        togglePaletteStackView(show: true, animated: true)
    }
    
    func hide()
    {
        togglePaletteStackView(show: false, animated: true)
    }
    
    func togglePaletteStackView(show: Bool, animated: Bool) {
        
        for (index, button) in orderedButtons().enumerated() {
            
            let toValue = (show ? 1 : -1) * button.layer.anchorPoint.y * button.frame.height
            
            if animated {
                button.layer.animationManager.spring.positionY(toValue: toValue, beginTime: CACurrentMediaTime() + Double(index) / 10, dynamicsMass: 2.5, completion: nil)
            } else {
                button.translatesAutoresizingMaskIntoConstraints = true
                var position = button.layer.position
                position.y = toValue
                button.layer.position = position
            }
        }
        
        let toValue = show ? 0 : wrapperStackView.frame.height
        if animated {
            let basic = wrapperStackViewToggleConstraint.animationManager.basic
            basic.set(constant: toValue, completion: nil)
            wrapperStackViewToggleConstraint.animationManager.basic.set(constant: toValue, completion: nil)
        } else {
            wrapperStackViewToggleConstraint.constant = toValue
            view.layoutIfNeeded()
        }
    }
}

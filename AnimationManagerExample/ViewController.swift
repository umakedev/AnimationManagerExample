//
//  ViewController.swift
//  AnimationManagerExample
//
//  Created by Shai Balassiano on 22/02/2017.
//  Copyright © 2017 Umake. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    weak var topMenuViewController: TopMenuViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let topMenuViewController = segue.destination as? TopMenuViewController {
            self.topMenuViewController = topMenuViewController
        }
    }
    
    @IBAction func didTouchDown(hideTopMenuButton: UIButton)
    {
        topMenuViewController.show()
    }
    
    @IBAction func didTouchUp(hideTopMenuButton: UIButton)
    {
        topMenuViewController.hide()
    }
    
}


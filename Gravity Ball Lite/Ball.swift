//
//  Ball.swift
//  Gravity Ball Lite
//
//  Created by Christian Ondaatje on 12/5/14.
//  Copyright (c) 2014 P. Christian Ondaatje. All rights reserved.
//

import Foundation
import SpriteKit

// implements some basic functionality of gravity objects
class Ball: SKSpriteNode {
    var mass = CGFloat(0)
    var originalPosition = CGPointZero
    var margin = CGFloat(0)
    var velocity = CGPointZero
    var inFrame = false
    
    func isInFrame(view: SKView) -> Bool {
        if ((self.position.x > CGRectGetMaxX(view.frame) || self.position.x < CGRectGetMinX(view.frame)) ||
            (self.position.y > CGRectGetMaxY(view.frame) || self.position.y < CGRectGetMinY(view.frame))) {
                return false
        }else{
            return true
        }
    }
}

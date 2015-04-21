//
//  DistanceIndicator.swift
//  Gravity Ball Lite
//
//  Created by Christian Ondaatje on 12/5/14.
//  Copyright (c) 2014 P. Christian Ondaatje. All rights reserved.
//

import Foundation
import SpriteKit

// A little counter to show how far the hero is offscreen
class DistanceIndicator: SKLabelNode {
    var marginY = CGFloat(0)
    var marginX = CGFloat(0)
    
    func moveWithin(view: SKView, hero: Hero) {
        
        // distance indicator constants
        let maxDIX = CGRectGetMaxX(view.frame) - self.marginX
        let maxDIY = CGRectGetMaxY(view.frame) - self.marginY
        let minDIX = CGRectGetMinX(view.frame) + self.marginX
        let minDIY = CGRectGetMinY(view.frame) + self.marginY
        
        // if the hero is off the frame in the x direction at all
        if hero.isInFrame(view) == false {
            self.alpha = 1
            
            if hero.position.x > maxDIX {
                self.position.x = maxDIX
            }else if hero.position.x < minDIX {
                self.position.x = minDIX
            }else{
                self.position.x = hero.position.x
            }
            
            if hero.position.y > maxDIY {
                self.position.y = maxDIY
            }else if hero.position.y < minDIY {
                self.position.y = minDIY
            }else{
                self.position.y = hero.position.y
            }
        } else {
            self.alpha = 0
        }
        self.position.y -= CGFloat(5)
    }
}
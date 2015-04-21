//
//  Hero.swift
//  Gravity Ball Lite
//
//  Created by Christian Ondaatje on 12/5/14.
//  Copyright (c) 2014 P. Christian Ondaatje. All rights reserved.
//

import Foundation
import SpriteKit

class Hero: Ball {
    var touched = false
    var fired = false
    
    // support gravitational forces from multiple celestial bodies
    var influencers:[Ball] = []
}
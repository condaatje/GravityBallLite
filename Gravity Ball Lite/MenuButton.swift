//
//  MenuButton.swift
//  Gravity Ball Lite
//
//  Created by Christian Ondaatje on 12/5/14.
//  Copyright (c) 2014 P. Christian Ondaatje. All rights reserved.
//

import SpriteKit

class MenuButton: SKSpriteNode {
    var sizingFactor: Float = 0.0
    var touched = false
    override init() {
        let texture = SKTexture(imageNamed: "MenuButton")
        super.init(texture: texture, color: nil, size: texture.size())
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

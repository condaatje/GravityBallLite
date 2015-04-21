//
//  VictoryScene.swift
//  Gravity Ball Lite
//
//  Created by Christian Ondaatje on 12/5/14.
//  Copyright (c) 2014 P. Christian Ondaatje. All rights reserved.
//

import SpriteKit

class VictoryScene: SKScene {
    
    let congratsButton = SKLabelNode(text: "Congratulations")
    let lines = ["You have annihilated", "all known life", "in the universe", "Any remaining civilizations", "will believe they are alone...", "...but not for long"]
        
    override func didMoveToView(view: SKView) {
        let backgroundImage = SKSpriteNode(imageNamed: "Space15")
                
        // setup the background
        self.backgroundColor = UIColor(hex: 0x000000, alpha: 0.5)
        let skView = self.view as SKView!
        //backgroundImage.size = skView.bounds.size
        backgroundImage.setScale(0.2)
        backgroundImage.anchorPoint = CGPointMake(0.5, 0.75) // anchor to the center
        backgroundImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)) // put the image in the center of the frame
        backgroundImage.zPosition = -2
        self.addChild(backgroundImage)
        
        // position and display the victory text
        congratsButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - CGFloat(50))
        congratsButton.fontName = "Copperplate-Bold"
        self.addChild(congratsButton)

        var offset = 50
        var buttonScale = skView.frame.width * 0.0019
        
        for line in lines {
            let text = SKLabelNode(text: line)
            text.fontName = "Copperplate-Bold"
            text.position = CGPointMake(congratsButton.position.x, congratsButton.position.y - CGFloat(offset))
            text.setScale(buttonScale)
            self.addChild(text)
            offset += 30
        }
    }
    
    // go back to the main menu on finger tap
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) { // from here: https://www.youtube.com/watch?v=eQ15rvwSFt8
        var scene = GameScene(size: self.size)
        let skView = self.view as SKView!
        scene.size = skView.bounds.size
        skView.presentScene(scene)
    }
}

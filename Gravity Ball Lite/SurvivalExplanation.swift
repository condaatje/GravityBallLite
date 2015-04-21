//
//  SurvivalExplanation.swift
//  Gravity Ball Lite
//
//  Created by Christian Ondaatje on 12/5/14.
//  Copyright (c) 2014 P. Christian Ondaatje. All rights reserved.
//

import SpriteKit

class SurvivalExplanation: SKScene {
    
    // TODO: there's got to be a better way to do this, c'mon apple
    var surviveHead = SKLabelNode(text: "Survive")
    let lines = ["You are the captain of the last surviving","space pod, with crucial information","for your civilization's leaders.", "You must keep your pod as close as you", " can to your home planet to allow them", "to mount a rescue operation", "to bring you home safely", "good luck...", "...the fate of your species depends on you"]
    let surviveTail = SKLabelNode(text: "Touch anywhere to begin")
    
    override func didMoveToView(view: SKView) {
        
        // set up the background
        let backgroundImage = SKSpriteNode(imageNamed: "SurvivalExplanationBackground")
        let skView = self.view as SKView!
        backgroundImage.size = skView.bounds.size
        backgroundImage.anchorPoint = CGPointMake(0.5, 0.5) // anchor to the center
        backgroundImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)) // put the image in the center of the frame
        backgroundImage.zPosition = -2
        backgroundImage.alpha = 0.75
        self.addChild(backgroundImage)
        
        // display the survival instructions
        surviveHead.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - CGFloat(50))
        surviveHead.fontName = "Copperplate-Bold"
        self.addChild(surviveHead)
        
        // responsive
        var offset = skView.frame.height / 4
        var textSize = skView.frame.width * 0.0014
        
        for line in lines {
            let text = SKLabelNode(text: line)
            text.fontName = "Copperplate-Bold"
            text.position = CGPointMake(surviveHead.position.x, surviveHead.position.y - offset)
            text.setScale(textSize)
            self.addChild(text)
            offset += 20
        }
        
        surviveTail.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) + CGFloat(75))
        surviveTail.setScale(0.95)
        self.addChild(surviveTail)
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) { // from here: https://www.youtube.com/watch?v=eQ15rvwSFt8
        var scene = SurvivalScene(size: self.size)
        let skView = self.view as SKView!
        scene.size = skView.bounds.size
        
        skView.presentScene(scene)
    }
}
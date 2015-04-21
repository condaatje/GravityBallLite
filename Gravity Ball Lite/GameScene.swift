//
//  GameScene.swift
//  Gravity Ball Lite
//
//  Created by Christian Ondaatje on 12/1/14.
//  Copyright (c) 2014 P. Christian Ondaatje. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
        
    let survivalButton = SKLabelNode(text: "Survival Mode")
    let challengeButton = SKLabelNode(text: "Challenge Mode")

    override func didMoveToView(view: SKView) {
        
        // set up the background
        var backgroundImage = SKSpriteNode(imageNamed: "Space0")
        let skView = self.view as SKView!
        backgroundImage.size = skView.bounds.size
        //backgroundImage.setScale(1.2) // TODO: fix the intro sizing, this is so dumb
        backgroundImage.anchorPoint = CGPointMake(0.5, 0.5) // anchor to the center
        backgroundImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)) // put the image in the center of the frame
        
        // position and place the game-mode buttons
        let offset = skView.frame.height / 3
        survivalButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + offset)
        challengeButton.position = CGPointMake(survivalButton.position.x, survivalButton.position.y - CGFloat(50))
        survivalButton.fontName = "Copperplate-Bold"
        challengeButton.fontName = "Copperplate-Bold"
        self.addChild(backgroundImage)
        self.addChild(survivalButton)
        self.addChild(challengeButton)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) { // from here: https://www.youtube.com/watch?v=eQ15rvwSFt8
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            // if the user touches the survival button, go to the survival explanation
            if self.nodeAtPoint(location) == self.survivalButton {
                
                // create a new scene
                var scene = SurvivalExplanation(size: self.size)
                let skView = self.view as SKView!
                scene.size = skView.bounds.size
                
                // go to the new scene
                skView.presentScene(scene)
            }
            
            // if the user touches the challenge button, go to the challenge explanation
            if self.nodeAtPoint(location) == self.challengeButton {
                var scene = ChallengeExplanation(size: self.size)
                let skView = self.view as SKView!
                scene.size = skView.bounds.size
                skView.presentScene(scene)
            }
        }
    }
}

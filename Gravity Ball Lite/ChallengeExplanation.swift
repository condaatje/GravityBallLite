//
//  ChallengeExplanation.swift
//  Gravity Ball Lite
//
//  Created by Christian Ondaatje on 12/5/14.
//  Copyright (c) 2014 P. Christian Ondaatje. All rights reserved.
//

import SpriteKit

// TODO: rocket assset & firing animation
class ChallengeExplanation: SKScene {
    
    // TODO: Fonts & Bold & Stuff
    var challengeHead = SKLabelNode(text: "Challenge")
    let lines = ["You are the captain of an","elite assault pod,", "tasked with cleansing the universe","of all alien life.", "Failure is not an option:", "no species can be allowed","to survive...", "...lest they become a threat", "to your civilization"]
    let challengeTail = SKLabelNode(text: "Touch anywhere to begin")
    
    override func didMoveToView(view: SKView) {
        
        // setup the background
        let backgroundImage = SKSpriteNode(imageNamed: "ChallengeExplanationBackground")
        let skView = self.view as SKView!
        backgroundImage.size = skView.bounds.size
        backgroundImage.anchorPoint = CGPointMake(0.5, 0.5) // anchor to the center
        backgroundImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)) // put the image in the center of the frame
        backgroundImage.zPosition = -2
        backgroundImage.alpha = 0.75
        self.addChild(backgroundImage)
        
        // position and show the challenge tutorial text
        challengeHead.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - CGFloat(110))
        challengeHead.fontName = "Copperplate-Bold"
        self.addChild(challengeHead)
        
        // responsive
        var offset = skView.frame.height / 5
        var textSize = skView.frame.width * 0.0015
        
        for line in lines {
            let text = SKLabelNode(text: line)
            text.fontName = "Copperplate-Bold"
            text.position = CGPointMake(challengeHead.position.x, challengeHead.position.y - CGFloat(offset))
            text.setScale(textSize)
            self.addChild(text)
            offset += 20
        }
        
        challengeTail.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) + CGFloat(75))
        self.addChild(challengeTail)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var scene = Level1(size: self.size)
        let skView = self.view as SKView!
        scene.size = skView.bounds.size
        
        skView.presentScene(scene)
    }
}
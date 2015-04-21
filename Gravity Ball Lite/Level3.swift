//
//  Level3.swift
//  Gravity Ball Lite
//
//  Created by Christian Ondaatje on 12/5/14.
//  Copyright (c) 2014 P. Christian Ondaatje. All rights reserved.
//


import SpriteKit

// Large Meteor shoots across the screen on a loop
class Level3: GravityBoard {
    
    // sprites
    let enemyPlanet = Ball(imageNamed: "EnemyPlanet3")
    let meteor = Ball(imageNamed: "Meteor")
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        // put the hero bottom right
        hero.originalPosition = CGPointMake(maxX - hero.size.width, minY + CGFloat(75))
        hero.position = hero.originalPosition
        powerArrow.position = hero.originalPosition
        
        // smaller planet, smaller gravitational force
        enemyPlanet.mass = CGFloat(5.972 * pow(10, 23))
        meteor.mass = CGFloat(5.972 * pow(10, 25)) // make the meteor feel heavy so the user notices it's gravity
        
        hero.influencers.append(enemyPlanet)
        hero.influencers.append(meteor)
        
        enemyPlanet.position = CGPointMake(minX + CGFloat(50), maxY - CGFloat(30))
        enemyPlanet.anchorPoint = CGPointMake(0.5, 0.5)
        enemyPlanet.setScale(0.2)
        
        meteor.originalPosition = CGPointMake(minX - CGFloat(100), maxY - CGFloat(600))
        meteor.position = meteor.originalPosition
        meteor.anchorPoint = CGPointMake(0.5, 0.5)
        meteor.setScale(0.5)
        meteor.velocity.x = CGFloat(2)
        meteor.velocity.y = CGFloat(3)

        // setup the background
        let backgroundStat = BackgroundStats().specific(2)
        var backgroundImage = SKSpriteNode(imageNamed: backgroundStat.0)
        let skView = self.view as SKView!
        backgroundImage.setScale(backgroundStat.1)
        backgroundImage.anchorPoint = CGPointMake(0.5, 0.5) // anchor to the center
        backgroundImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)) // put the image in the center of the frame
        backgroundImage.zPosition = -2
        
        self.addChild(backgroundImage)
        self.addChild(enemyPlanet)
        self.addChild(meteor)
        self.nextScene = Level4(size: self.size)
    }
    
    override func reset() {
        super.reset()
        meteor.position = meteor.originalPosition
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        enemyPlanet.zRotation += 0.005

        // move and loop the meteor
        meteor.position.x += meteor.velocity.x
        meteor.position.y += meteor.velocity.y
        if meteor.position.y > maxY + meteor.size.height {
            meteor.position = meteor.originalPosition
        }
        
        // win if the hero hits the enemy planet
        if (Float(distanceBetween(hero.position, second: enemyPlanet.position)) <= Float((hero.size.width/2 + enemyPlanet.size.width/2))) {
            // create a new scene
            var scene = nextScene
            let skView = self.view as SKView!
            scene.size = skView.bounds.size
            
            // go to the new scene
            skView.presentScene(scene)
        }
        
        //lose if the hero hits another planet
        if (Float(distanceBetween(hero.position, second: meteor.position)) <= Float((hero.size.width/2 + meteor.size.width/2))) {
            reset()
        }

        
    }
}
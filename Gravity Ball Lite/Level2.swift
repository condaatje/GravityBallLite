//
//  Level2.swift
//  Gravity Ball Lite
//
//  Created by Christian Ondaatje on 12/5/14.
//  Copyright (c) 2014 P. Christian Ondaatje. All rights reserved.
//

import SpriteKit

// Stationary planet between hero and destination
class Level2: GravityBoard {
    
    // sprites
    let enemyPlanet = Ball(imageNamed: "EnemyPlanet2")
    let otherPlanet = Ball(imageNamed: "Meteor")

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)

        // put the hero bottom left
        hero.originalPosition = CGPointMake(minX + hero.size.width, maxY - hero.size.width)
        hero.position = hero.originalPosition
        powerArrow.position = hero.originalPosition

        // setup the physics - gameplay tinkering
        enemyPlanet.mass = CGFloat(5.972 * pow(10, 25)) // heavier, bigger planet
        otherPlanet.mass = CGFloat(5.972 * pow(10, 24))
        hero.influencers.append(enemyPlanet)
        hero.influencers.append(otherPlanet)

        // put the enemy planet around mid right
        enemyPlanet.anchorPoint = CGPointMake(0.5, 0.5)
        enemyPlanet.position = CGPointMake(maxX - CGFloat(50), midY)
        enemyPlanet.setScale(0.2)
        
        // put the other planet between the hero and the enemyPlanet
        otherPlanet.position = CGPointMake(midX + CGFloat(30), midY + CGFloat(100))
        otherPlanet.anchorPoint = CGPointMake(0.5, 0.5)
        otherPlanet.setScale(0.3)
        
        // setup the background
        let backgroundStat = BackgroundStats().specific(1)
        var backgroundImage = SKSpriteNode(imageNamed: backgroundStat.0)
        let skView = self.view as SKView!
        backgroundImage.setScale(backgroundStat.1)
        backgroundImage.anchorPoint = CGPointMake(0.5, 0.5) // anchor to the center
        backgroundImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)) // put the image in the center of the frame
        backgroundImage.zPosition = -2
        self.addChild(backgroundImage)
        
        self.nextScene = Level3(size: self.size)
        self.addChild(enemyPlanet)
        self.addChild(otherPlanet)

    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        enemyPlanet.zRotation += 0.005
        
        //lose if the hero hits another planet
        if (Float(distanceBetween(hero.position, second: otherPlanet.position)) <= Float((hero.size.width/2 + otherPlanet.size.width/2))) {
            reset()
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
    }
}
//
//  Level1.swift
//  Gravity Ball Lite
//
//  Created by Christian Ondaatje on 12/5/14.
//  Copyright (c) 2014 P. Christian Ondaatje. All rights reserved.
//

import SpriteKit

// 'Tutorial' - one stationary planet.
class Level1: GravityBoard {
    
    let enemyPlanet = Ball(imageNamed: "EnemyPlanet1")
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        //TODO: rocket
       // self.hero = Hero(imageNamed: "Hero")
        
        // put the attack hero in the bottom left with a bit of padding
        hero.originalPosition = CGPointMake(minX + hero.size.width, minY + CGFloat(75))
        hero.position = hero.originalPosition
        powerArrow.position = hero.originalPosition

        // set up the physics - gameplay tinkering
        enemyPlanet.mass = CGFloat(5.972 * pow(10, 24))
        hero.influencers.append(enemyPlanet)

        enemyPlanet.position = CGPointMake(midX, midY)
        enemyPlanet.anchorPoint = CGPointMake(0.5, 0.5)
        enemyPlanet.setScale(0.2)
        
        // setup the background
        let backgroundStat = BackgroundStats().specific(0)
        var backgroundImage = SKSpriteNode(imageNamed: backgroundStat.0)
        let skView = self.view as SKView!
        backgroundImage.setScale(backgroundStat.1)
        backgroundImage.anchorPoint = CGPointMake(0.5, 0.5) // anchor to the center
        backgroundImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)) // put the image in the center of the frame
        backgroundImage.zPosition = -2
        self.addChild(backgroundImage)
        
        self.addChild(enemyPlanet)
        self.nextScene = Level2(size: self.size)
        
        // can add different tints for different levels like so:
        // self.backgroundColor = UIColor(hex: 0x300000)
        // self.backgroundImage.alpha = 0.5
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
    
        enemyPlanet.zRotation += 0.005
        
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
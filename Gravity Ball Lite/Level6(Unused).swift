//
//  Level6.swift
//  Gravity Ball Lite
//
//  Created by Christian Ondaatje on 3/16/15.
//  Copyright (c) 2015 P. Christian Ondaatje. All rights reserved.
//

import SpriteKit

// TODO: level with a moon that orbits and goes behind, with changing size and gravity.

// this is a clone of level5, and is not included in the game yet.
// 5cos(x), 10sin(y) for elliptical
// var behind: bool. alpha changes if intersecting base planet and behind == true
class Level6: GravityBoard {
    
    // sprites
    let enemyPlanet = HomePlanet()
    let moon = Ball(imageNamed: "Moon")
    var theta = CGFloat(0)
    let orbitFactor = (x: CGFloat(1), y: CGFloat(2))
    let radius = CGFloat(100)
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        // put the hero top right
        hero.originalPosition = CGPointMake(maxX - CGFloat(50), maxY - CGFloat(100))
        hero.position = hero.originalPosition
        powerArrow.position = hero.originalPosition
        
        // setup the physics
        enemyPlanet.mass = CGFloat(5.972 * pow(10, 24))
        hero.influencers.append(enemyPlanet)
        hero.influencers.append(moon)
        
        // put earth right in the middle
        enemyPlanet.originalPosition = CGPointMake(midX, midY)
        enemyPlanet.position = enemyPlanet.originalPosition
        enemyPlanet.anchorPoint = CGPointMake(0.5, 0.5)
        enemyPlanet.setScale(0.2)
        
        moon.position = enemyPlanet.originalPosition
        moon.mass = CGFloat(7.34767309 * pow(10,24)) // 100 times more massive than the actual moon
        moon.position.y -= radius
        moon.setScale(0.2)
        
        var backgroundImage = SKSpriteNode(imageNamed: "Space?")
        self.addChild(backgroundImage)
        
        self.nextScene = VictoryScene(size: self.size)
        self.addChild(enemyPlanet)
        self.addChild(moon)
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        enemyPlanet.zRotation -= 0.005
        
        theta += 0.01
        moon.position.y += orbitFactor.y * sin(theta)//distanceBetween(moon.position, second: enemyPlanet.position) * sin(theta)
        moon.position.x += orbitFactor.x * cos(theta)//distanceBetween(moon.position, second: enemyPlanet.position) * cos(theta)
        
        // win if the hero hits the enemy planet
        if (Float(distanceBetween(hero.position, second: enemyPlanet.position)) <= Float((hero.size.width/2 + enemyPlanet.size.width/2))) {
            // create a new scene
            var scene = nextScene
            let skView = self.view as SKView!
            scene.size = skView.bounds.size
            
            // go to the new scene
            skView.presentScene(scene)
        }
        
        
        //lose if the hero hits the moon
        if (Float(distanceBetween(hero.position, second: moon.position)) <= Float((hero.size.width/2 + moon.size.width/2))) {
            reset()
        }
    }
}
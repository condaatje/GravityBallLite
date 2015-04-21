//
//  SurvivalScene.swift
//  Gravity Ball Lite
//
//  Created by Christian Ondaatje on 12/5/14.
//  Copyright (c) 2014 P. Christian Ondaatje. All rights reserved.
//

import SpriteKit

//TODO: random position

// Survival mode is a more realistic gravity simulation. I went for accuracy over gameplay here.
class SurvivalScene: GravityBoard {
    let homePlanet = HomePlanet()
    let stats = (velocity: SKLabelNode(text: "velocities"), position: SKLabelNode(text: "positions"))
    let scoreboard = SKLabelNode(text: "Score: 0")
    
    let earthDiameter = CGFloat(12742) // diameter of the earth is 12742 KM
    var theta = CGFloat(0)
    let moon = Ball(imageNamed: "Moon")
    let orbitFactor = CGFloat(1)
    let radius = CGFloat(100)
    
    
    override func didMoveToView(view: SKView) {
        // self.hero = Hero(imageNamed: "SurvivalHero")
        super.didMoveToView(view)
        
        homePlanet.mass = CGFloat(5.972 * pow(10, 24)) // mass of the home planet (earth's mass for now)
        
        
        // starting positions and scales
        stats.velocity.position = CGPointMake(minX + CGFloat(150), maxY + CGFloat(-100))
        stats.position.position = CGPointMake(minX + CGFloat(150), maxY + CGFloat(-120))
        scoreboard.position = CGPointMake(midX - CGFloat(100), maxY + CGFloat(-30))
        scoreboard.zPosition = -1
        stats.velocity.setScale(0.5)
        stats.position.setScale(0.5)
        hero.originalPosition = randomPosition(CGPointMake(maxX, minX), yBounds: CGPointMake(maxY, minY), margin: CGFloat(50))
        hero.position = hero.originalPosition
        powerArrow.position = hero.originalPosition
        homePlanet.originalPosition = CGPointMake(midX, midY)
        homePlanet.position = homePlanet.originalPosition
        homePlanet.anchorPoint = CGPointMake(0.5, 0.5)
        homePlanet.setScale(0.2)
        
        
        moon.position = homePlanet.originalPosition
        moon.mass = CGFloat(7.34767309 * pow(10,23)) // 10 times more massive than the moon in real life
        moon.position.y -= radius
        moon.setScale(0.1)
        
        
        // make the hero gravitate towards the homePlanet and the moon
        hero.influencers.append(homePlanet)
        hero.influencers.append(moon)
        
        // change the power behind dragging and releasing for more realism
        velocityFactor = CGFloat(0.005)
        
        // set the scale to be the right amount of kilometers per pixel for every device, so the amount of pixels used for earth's width vs the amount of pixels in the frame
        scale = CGFloat((earthDiameter/(CGFloat(pow(Float(homePlanet.size.width),2))/CGFloat(pow(Float(view.frame.width),2)))))
        
        // setup the background
        let backgroundStat = BackgroundStats().rando()
        var backgroundImage = SKSpriteNode(imageNamed: backgroundStat.0)
        let skView = self.view as SKView!
        backgroundImage.setScale(backgroundStat.1)
        backgroundImage.anchorPoint = CGPointMake(0.5, 0.5) // anchor to the center
        backgroundImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)) // put the image in the center of the frame
        backgroundImage.zPosition = -2
        
        self.addChild(backgroundImage)
        self.addChild(homePlanet)
        self.addChild(moon)
        self.addChild(scoreboard)
        
        // Uncomment for debugging stats
        //self.addChild(stats.position)
        //self.addChild(stats.velocity)
    }

    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        theta += 0.01
        moon.position.y += orbitFactor * sin(theta)
        moon.position.x += orbitFactor * cos(theta)
        
        hero.inFrame = hero.isInFrame(self.view!)
        
        homePlanet.zRotation -= 0.005
        moon.zRotation += 0.01

        
        // change the points based on whether the hero is in the frame and how close it is to the homePlanet
        if hero.fired && hero.inFrame {
            points += scoreFactor / CGFloat(distanceBetween(hero.position, second: homePlanet.position))
        }
        
        // update the labels
        scoreboard.text = String(format: "Score: %i", Int(points))
        //stats.velocity.text = String(format: "velocity X: %.2f velocity Y: %.2f", Float(hero.velocity.x), Float(hero.velocity.y))
        //stats.position.text = String(format: "position X: %i position Y: %i", Int(hero.position.x - homePlanet.position.x), Int(hero.position.y - homePlanet.position.y))
        
        // loss conditions: if the hero hits the home planet or the moon, you lose
        if (Float(distanceBetween(hero.position, second: homePlanet.position)) < Float((hero.size.width/2 + homePlanet.size.width/2))) {
            reset()
        }
        if (Float(distanceBetween(hero.position, second: moon.position)) <= Float((hero.size.width/2 + moon.size.width/2))) {
            reset()
        }

    }
    
    override func reset() {
        super.reset()
        hero.originalPosition = randomPosition(CGPointMake(maxX, minX), yBounds: CGPointMake(maxY, minY), margin: CGFloat(50))
        hero.position = hero.originalPosition
        powerArrow.position = hero.originalPosition
        points = 0
        stats.velocity.text = "velocities"
        stats.position.text = "positions"
    }
}
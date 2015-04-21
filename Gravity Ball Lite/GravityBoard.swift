//
//  GravityBoard.swift
//  Gravity Ball Lite
//
//  Created by Christian Ondaatje on 12/5/14.
//  Copyright (c) 2014 P. Christian Ondaatje. All rights reserved.
//
import Foundation
import SpriteKit

//TODO: collision method & animation

// Implements the physics and basic setup of the game
class GravityBoard: SKScene {
        
    // init sprites
    //TODO: default is a rocket
    var hero = Hero(imageNamed: "Hero") // default to the Ball Hero
    let retryButton = SKSpriteNode(imageNamed: "RetryButton")
    let indicatorArrow = ArrowIndicator(imageNamed: "Arrow")
    let powerArrow = Arrow(imageNamed: "PowerArrow")
    let menuButton = MenuButton()
    let distanceIndicator = DistanceIndicator(text: "0")
    
    // init game variables
    var nextScene = SKScene()
    var points = CGFloat(0)
    var maxX = CGFloat(0)
    var maxY = CGFloat(0)
    var minX = CGFloat(0)
    var minY = CGFloat(0)
    var midX = CGFloat(0)
    var midY = CGFloat(0)
    
    // Finagle for gameplay changes
    var velocityFactor = CGFloat(0.005)
    
    // TODO: untie gravity calculations from pixels this is just dumb for iPads.
    var scale = CGFloat(1000000) // 1 pixel will be 1000 Kilometers by default
    var gravitationalConstant = CGFloat(6.673 * pow(10,-11)) // real gravity by default.
    var scoreFactor = CGFloat(10)
    
    // TODO: implement scale changes based on device
    let device = UIDevice.currentDevice()
    let indicatorFactor = CGFloat(0.1) // TODO: ask testers about indicatorFactor
    
    override func didMoveToView(view: SKView) {
        
        // setup the board
        initVariables()
        anchor()
        size()
        addChildren()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            // if the user touches the hero ball, indicate that the program should start calculating velocity
            if ((hero.fired == false) && (nodeAtPoint(location) != retryButton || nodeAtPoint(location) != menuButton)) {
                hero.touched = true
                powerArrow.alpha = 1
                let touch = touches.anyObject() as UITouch
                powerArrow.constraints = [SKConstraint.orientToPoint(touch.locationInNode(self), offset: SKRange(constantValue: 0.0))]
                powerArrow.xScale = CGFloat(hypotf(Float(abs(touch.locationInNode(self).x - hero.position.x)), Float(abs(abs(touch.locationInNode(self).y - self.frame.minY) - hero.position.y)))*powerArrow.sizingFactor) // TODO: clean up this formula
            }
            
            // retry/reset if the user touches the retry button
            if nodeAtPoint(location) == retryButton {
                retryButton.runAction(SKAction.sequence([SKAction.fadeAlphaTo(0.25, duration: 0.05), SKAction.fadeAlphaTo(0.75, duration: 0.3)])) // learned about sequences here: http://stackoverflow.com/questions/26047010/fading-a-shadow-together-with-the-skspritenode-that-casts-it
                reset()
                notify()
            }
            
            // animate menu button press
            if nodeAtPoint(touch.locationInNode(self)) == menuButton {
                menuButton.runAction(SKAction.sequence([SKAction.fadeAlphaTo(0.25, duration: 0.05), SKAction.fadeAlphaTo(0.75, duration: 0.3)]))
                menuButton.touched = true
            }
        }
    }
    
    func notify() {
        NSNotificationCenter.defaultCenter().postNotificationName("hideAd", object: nil)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        // extend the power arrow
        if hero.touched == true && hero.fired == false {
            powerArrow.alpha = 1
            let touch = touches.anyObject() as UITouch
            powerArrow.constraints = [SKConstraint.orientToPoint(touch.locationInNode(self), offset: SKRange(constantValue: 0.0))]
            powerArrow.xScale = CGFloat(hypotf(Float(abs(touch.locationInNode(self).x - hero.position.x)), Float(abs(abs(touch.locationInNode(self).y - self.frame.minY) - hero.position.y)))*powerArrow.sizingFactor) // TODO: clean up this formula
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            // calculate the speed at which the user fired the hero
            if hero.touched == true && hero.fired == false {
                let location = touch.locationInNode(self)
                hero.velocity.x = (location.x - hero.position.x) * velocityFactor //TODO: examine effects of the velocityFactor on gameplay
                hero.velocity.y = (location.y - hero.position.y) * velocityFactor
                hero.fired = true
                hero.touched = false
            }
            
            // take the user to the main menu if they touch the menu button
            if nodeAtPoint(touch.locationInNode(self)) == menuButton  && menuButton.touched {
              //menuButton.runAction(SKAction.sequence([SKAction.fadeAlphaTo(0.25, duration: 0.05), SKAction.fadeAlphaTo(0.75, duration: 0.3)]))
                var scene = GameScene(size: self.size)
                let skView = self.view as SKView!
                scene.size = skView.bounds.size
                
                skView.presentScene(scene)
            }
        }
        
        powerArrow.alpha = 0
    }
    
    // TODO: think about multithreading
    override func update(currentTime: NSTimeInterval) {
        hero.inFrame = hero.isInFrame(self.view!)
        
        distanceIndicator.text = String(format: "%i", Int(distanceBetween(indicatorArrow.position, second: hero.position) * indicatorFactor))
        
        moveIndicatorArrow()
        moveHero()
    }
    
    func initVariables() {
        maxX = CGRectGetMaxX(self.frame)
        maxY = CGRectGetMaxY(self.frame)
        minX = CGRectGetMinX(self.frame)
        minY = CGRectGetMinY(self.frame)
        midX = CGRectGetMidX(self.frame)
        midY = CGRectGetMidY(self.frame)
        hero.velocity = CGPointZero
        
        indicatorArrow.margin = CGFloat(5)
        distanceIndicator.marginX = CGFloat(45)
        distanceIndicator.marginY = CGFloat(35)
        
        powerArrow.alpha = 0
        indicatorArrow.alpha = 0
        distanceIndicator.alpha = 0
        retryButton.alpha = 0.75
        menuButton.alpha = 0.75
        
        // lateral positions
        hero.position = hero.originalPosition
        retryButton.position = CGPointMake(maxX, maxY) // TODO: account for statusBar with if !self.preferStatusBarHidden()
        indicatorArrow.position = CGPointMake(midX, midY - CGFloat(100))
        indicatorArrow.constraints = [SKConstraint.orientToNode(hero, offset: SKRange(constantValue: 0.0))]// from http://www.raywenderlich.com/80917/sprite-kit-inverse-kinematics-swift,
        powerArrow.position = hero.originalPosition
        menuButton.position = CGPointMake(maxX, maxY - retryButton.size.height - CGFloat(2))
        
        // z positions
        indicatorArrow.zPosition = 2
        distanceIndicator.zPosition = 2
        powerArrow.zPosition = -1
        
        // just a black background by default
        self.backgroundColor = UIColor(hex: 0x000000, alpha: 0.5)
    }
    
    func distanceBetween(first: CGPoint, second: CGPoint) -> CGFloat {
        return CGFloat(hypotf(Float(second.x - first.x), Float(second.y - first.y))) //http://stackoverflow.com/questions/21251706/ios-spritekit-how-to-calculate-the-distance-between-two-nodes
    }
    
    func anchor() {
        hero.anchorPoint = CGPointMake(0.5, 0.5)
        retryButton.anchorPoint = CGPointMake(1, 1)
        menuButton.anchorPoint = CGPointMake(1, 1)
        indicatorArrow.anchorPoint = CGPointMake(1.0, 0.5) // the tip of the arrow
        powerArrow.anchorPoint = CGPointMake(0.0, 0.5) // the base of the arrow
    }
    
    func size() {
        hero.setScale(0.25)
        indicatorArrow.setScale(0.25)
        distanceIndicator.setScale(0.5)
        powerArrow.sizingFactor = Float(0.014)
        retryButton.setScale(0.20)
        menuButton.setScale(0.20)
    }
    
    func addChildren() {
        self.addChild(hero)
        self.addChild(retryButton)
        self.addChild(indicatorArrow)
        self.addChild(powerArrow)
        self.addChild(menuButton)
        self.addChild(distanceIndicator)
    }
    
    
    func moveIndicatorArrow() {
        indicatorArrow.moveWithin(self.view!, hero: hero)
        distanceIndicator.moveWithin(self.view!, hero: hero)
    }
    
    func moveHero() {
        if hero.fired == true {
            // calculate acceleration due to gravity from all celestial bodies in the game board
            for puller in hero.influencers {
            
                // Newton's gravity & force equations, combined to find acceleration
                // also some trig to find direction
                let xDistance = (puller.position.x - hero.position.x) * scale
                let yDistance = (puller.position.y - hero.position.y) * scale
                let distanceSquared = CGFloat(pow((xDistance), 2) + pow((yDistance), 2)) // d^2 = x^2 + y^2
                let acceleration = (gravitationalConstant * puller.mass) / distanceSquared // decayFactor)
                let beta = abs(atan(xDistance / yDistance))
                let theta = abs(atan(yDistance / xDistance))
                let deltaVX = (acceleration * sin(beta)) * sign(xDistance)
                let deltaVY = (acceleration * sin(theta)) * sign(yDistance)

                hero.velocity.x += deltaVX
                hero.velocity.y += deltaVY
            }
        }
        
        // move the hero
        hero.position.x += hero.velocity.x
        hero.position.y += hero.velocity.y
    }
    
    func reset() {
        hero.touched = false
        hero.fired = false
        hero.velocity.x = 0.0
        hero.velocity.y = 0.0
        hero.position = hero.originalPosition
    }

    
    final func sign(value: CGFloat) -> CGFloat {
        if value < 0 {
            return CGFloat(-1)
        }
        if value > 0 {
            return CGFloat(1)
        }
        else {
            return CGFloat(1)
        }
    }
    
    func randomPosition(xBounds: CGPoint, yBounds: CGPoint, margin: CGFloat) -> CGPoint {
    //random function derived from this one: http://www.raywenderlich.com/84434/sprite-kit-swift-tutorial-beginners

        var randX = CGFloat(Float(arc4random())) % (xBounds.x - xBounds.y) // cgpoint hack
        var randY = CGFloat(Float(arc4random())) % (yBounds.x - yBounds.y)
        
        // enforce the margin
        if ((randX > maxX || randX < minX) ||
            (randY > maxY || randY < minY)) {
                if (randX > maxX) {
                    randX = maxX - CGFloat(margin)
                }else if (randX < minX) {
                    randX = minX + CGFloat(margin)
                }else if abs(randX - minX) < margin{
                    randX = minX + margin
                }else if abs(randX - maxX) < margin {
                    randX = maxX - margin
                }
                
                if (randY > maxY) {
                    randY = maxY - margin
                }else if (randY < minY) {
                    randY = minY + margin
                }else if abs(randY - minY) < margin{
                    randY = minY + margin
                }else if abs(randY - maxY) < margin {
                    randY = maxY - margin
                }
        }
        
        return CGPointMake(randX, randY)
    }
    
    //TODO: collision function
}
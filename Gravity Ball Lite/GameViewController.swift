//
//  GameViewController.swift
//  Gravity Ball Lite
//
//  Created by Christian Ondaatje on 12/5/14.
//  Copyright (c) 2014 P. Christian Ondaatje. All rights reserved.
//

import UIKit
import SpriteKit
import iAd

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, ADBannerViewDelegate {

    var ad = ADBannerView()
    var screenHeight = UIScreen.mainScreen().bounds.height
    
    func loadAd() {
        
        ad = ADBannerView(frame: CGRectZero)
        ad.delegate = self
        ad.hidden = true
        ad.frame = CGRectMake(0, screenHeight - 50, 0, 0) // put it at the bottom. use 0,21,0,0 for top
        
        self.view.addSubview(ad)
    }
    override func viewDidAppear(animated: Bool) {
        loadAd()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as SKView
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
       
            // resize the game frame to accomodate the ad
            scene.size.height = skView.frame.height - ad.frame.height
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
    }
  
    override func viewWillLayoutSubviews() {
        // tells the banner to hide/show when the notification center recieves such a message.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: NSSelectorFromString("hideAd"), name: "hideAd", object: nil)
    }
    
//    override func viewDidDisappear(animated: Bool) {
//        ad.delegate = nil
//        ad.removeFromSuperview()
//    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        ad.alpha = 1
        UIView.commitAnimations()
        ad.hidden = false
        ad.frame = CGRectMake(0, screenHeight - 50, 0, 0) // put it at the bottom. use 0,21,0,0 for top
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        ad.hidden = true
        UIView.commitAnimations()
        ad.center = CGPoint(x: ad.center.x, y: view.bounds.size.height + view.bounds.size.height) // put it off the screen
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    // allows us to access the appdelegate in here.
    func appdelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }
    
    // Leave the game to the ad link
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    func hideAd() {
        ad.hidden = true
        ad.center = CGPoint(x: ad.center.x, y: view.bounds.size.height + view.bounds.size.height) // put it off the screen
    }
    
    // keep this out until we can deal with positioning to accomodate it.
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

//
//  GravityBackground.swift
//  Gravitas
//
//  Created by Tester on 3/17/15.
//  Copyright (c) 2015 Development. All rights reserved.
//

import SpriteKit
import Foundation

// random functionality is useful
struct BackgroundStats {
    // keep all the background images that work here.
    let strings: [(String, CGFloat)] = [("Space3",0.5), ("Space4",0.5), ("Space7",0.5), ("Space9",0.5), ("Space10",0.9), ("Space11",0.4)]
        
//        ("Space12",0.62), ("Space13",0.3), ("Space14",0.3), ("Space15",0.2), ("Space16",0.65), ("Space17",0.3), ("Space18",0.7), ("Space19",0.3), ("Space20",0.39), ("Space21",0.38)]
    
    func specific(i: Int) -> (String, CGFloat) {
        return strings[i]
    }
    
    func rando() -> (String, CGFloat) {
        return strings[Int(arc4random_uniform(UInt32(strings.count)))]
    }
}
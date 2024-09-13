//
//  PhysicsNodeProtocol.swift
//  Assteroids
//
//  Created by Marcus Kim on 8/29/24.
//

import Foundation
import SpriteKit

protocol PhysicsNodeProtocol: SKSpriteNode {
    
    init(systemName: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: CGFloat, zRotation: CGFloat, name: String)
    init(named: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: CGFloat, zRotation: CGFloat, name: String)
    
    func createPhysicsBody(size: CGSize) // create SKPhysicsBody and customize
    
}

// TODO: - Use inheritance to define basic architecture and inheritance "tree"
/*
 1) define a generic game element class (super duper node; the superest of nodes)
 
 --------
 
 2) define a generic stationary element class that inherits from generic game element class (e.g. score node)
 3) define a generic moving element class that inherits from generic game element class (e.g. spaceship, alien, assteroid, missile)
 
 --------
 
 4) define a stationary button class that inherits from stationary element class (e.g., left & right rotate, thrust, and trigger - things that respond to gestures)
 
 --------
 
 define a collidable protocol
 define a user controlled protocol
 define an automovable protocol
 
 */

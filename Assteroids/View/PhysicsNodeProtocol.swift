//
//  PhysicsNodeProtocol.swift
//  Assteroids
//
//  Created by Marcus Kim on 8/29/24.
//

import Foundation
import SpriteKit

protocol PhysicsNodeProtocol: SKSpriteNode {
    
    init(systemName: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: CGFloat, zRotation: CGFloat, name: String, _ assteroidType: String)
    init(named: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: CGFloat, zRotation: CGFloat, name: String, _ assteroidType: String)
    
    func createPhysicsBody(size: CGSize) // create SKPhysicsBody and customize
    
}


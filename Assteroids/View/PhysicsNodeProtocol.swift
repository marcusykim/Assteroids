//
//  PhysicsNodeProtocol.swift
//  Assteroids
//
//  Created by Marcus Kim on 8/29/24.
//

import Foundation
import SpriteKit

protocol PhysicsNodeProtocol: SKSpriteNode {
    
    init(systemName: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: CGFloat, zRotation: CGFloat, name: String, category: UInt32)
    init(named: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: CGFloat, zRotation: CGFloat, name: String, category: UInt32)
    
    func createPhysicsBody(size: CGSize) // create SKPhysicsBody and customize
    
}


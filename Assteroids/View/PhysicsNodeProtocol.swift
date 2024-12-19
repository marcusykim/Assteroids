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


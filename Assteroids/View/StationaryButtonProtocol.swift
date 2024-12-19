//
//  Button.swift
//  Assteroids
//
//  Created by Marcus Kim on 6/25/24.
//

import Foundation
import SpriteKit

protocol StationaryButtonProtocol: SKSpriteNode {
    var anchorPoint: CGPoint { get set }
    //var size: CGSize { get set }
    var position: CGPoint { get set }
    var zPosition: CGFloat { get set }
    var spaceship: SKSpriteNode { get set }

    init(systemName: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: CGFloat, rotationDirection: String, spaceship: SKSpriteNode, name: String)
    init(named: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: CGFloat, rotationDirection: String, spaceship: SKSpriteNode, name: String)
    
}



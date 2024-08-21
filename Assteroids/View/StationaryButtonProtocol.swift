//
//  Button.swift
//  Assteroids
//
//  Created by Marcus Kim on 6/25/24.
//

import Foundation
import SpriteKit

protocol StationaryButtonProtocol: SKSpriteNode {
    var asset: UIImage { get set }
    var anchorPoint: CGPoint { get set }
    var size: CGSize { get set }
    var position: CGPoint { get set }
    var zPosition: CGFloat { get set }
    var spaceship: SKSpriteNode { get set }

    init(systemName: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: CGFloat, rotationDirection: String?, spaceship: SKSpriteNode)
    init(named: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: CGFloat, rotationDirection: String?, spaceship: SKSpriteNode)
    
    func withTintColor(_ color: UIColor) -> UIImage
}


/*
 
 stationary button protocol has init methods for size, position, anchorpoint, image, etc. all necessary for buttons
 
 class Rotate: StationaryButtonProtocol {
 
    //required properties
 
 
    init(systemName: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: CGFloat) {
        // initialization
    }
    init(named: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: CGFloat) {
        // initialization
    }
 
    init(rotationDirection: String, systemName: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: CGFloat) {
        // initialization
    }
 
 
 }
 
 */

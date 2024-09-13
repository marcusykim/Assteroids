//
//  SpaceshipNode.swift
//  Assteroids
//
//  Created by Marcus Kim on 6/15/24.
//

import Foundation
import SpriteKit

class SpaceshipNode: SKSpriteNode, PhysicsNodeProtocol{
    
    required init(systemName: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: CGFloat, zRotation: CGFloat, name: String) {
        var asset: UIImage {
            
            var newImage = UIImage()
            
            if let safeAsset = UIImage(systemName: systemName)?.withTintColor(.white) {
                let data = safeAsset.pngData()
                newImage = UIImage(data: data!)!
                
            }
            
            return newImage
        }
        let texture = SKTexture(image: asset)
        super.init(texture: texture, color: .white, size: size)
        self.anchorPoint = anchorPoint
        self.position = position
        self.zPosition = zPosition
        self.name = name
        
        createPhysicsBody(size: size)
        
    }
    
    required init(named: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: CGFloat, zRotation: CGFloat, name: String) {
        var asset: UIImage {
            
            var newImage = UIImage()
            
            if let safeAsset = UIImage(named: named)?.withTintColor(.white) {
                let data = safeAsset.pngData()
                newImage = UIImage(data: data!)!
                
            }
            
            return newImage
        }
        
        
        let texture = SKTexture(image: asset)
        super.init(texture: texture, color: .white, size: size)
        self.anchorPoint = anchorPoint
        self.position = position
        self.zPosition = zPosition
        self.name = name
    
        createPhysicsBody(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createPhysicsBody(size: CGSize) {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        
        //init(physicsBody: SKPhysicsBody(rectangleOf: ))
        
        self.physicsBody?.isDynamic = true
        self.physicsBody?.linearDamping = 1.0
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)  // Ensure no initial velocity
        self.physicsBody?.angularVelocity = 0  // Ensure no initial angular velocity
        self.physicsBody?.affectedByGravity = false
    }
    
    
}

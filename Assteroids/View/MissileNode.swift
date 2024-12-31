//
//  MissileNode.swift
//  Assteroids
//
//  Created by Marcus Kim on 6/15/24.
//

import Foundation
import SpriteKit

class MissileNode: SKSpriteNode, PhysicsNodeProtocol {
    
    let missileCategory: UInt32 = K.missileCategory
    let largeAssteroidCategory: UInt32 = K.largeAssteroidCategory
    let mediumAssteroidCategory: UInt32 = K.mediumAssteroidCategory
    let smallAssteroidCategory: UInt32 = K.smallAssteroidCategory
    
    required init(systemName: String = K.missileAssetName, anchorPoint: CGPoint = CGPoint(x: 0, y: 0), size: CGSize, position: CGPoint, zPosition: CGFloat = 10.0, zRotation: CGFloat, name: String = "missile", _ assteroidCategory: UInt32 = K.largeAssteroidCategory) {
        var asset: UIImage {
            
            var newImage = UIImage()
            
            if let safeAsset = UIImage(systemName: systemName)?.withTintColor(.white) {
                let data = safeAsset.pngData()
                newImage = UIImage(data: data!)!
                
            }
            
            return newImage
        }
        
        let texture = SKTexture(image: asset)
        super.init(texture: texture, color: .white, size: texture.size())
        self.anchorPoint = anchorPoint
        self.position = position
        self.zPosition = zPosition
        self.zRotation = zRotation
        self.name = name
        
        createPhysicsBody(size: size)
        
        
    }
    
    required init(named: String, anchorPoint: CGPoint = CGPoint(x: 0, y: 0), size: CGSize, position: CGPoint, zPosition: CGFloat = 10.0, zRotation: CGFloat, name: String = "missile", _ assteroidCategory: UInt32 = K.largeAssteroidCategory) {
        var asset: UIImage {
            
            var newImage = UIImage()
            
            if let safeAsset = UIImage(systemName: named)?.withTintColor(.white) {
                let data = safeAsset.pngData()
                newImage = UIImage(data: data!)!
                
            }
            
            return newImage
        }
        
        let texture = SKTexture(image: asset)
        super.init(texture: texture, color: .white, size: texture.size())
        self.anchorPoint = anchorPoint
        self.position = position
        self.zPosition = zPosition
        self.zRotation = zRotation
        self.name = name
        
        createPhysicsBody(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createPhysicsBody(size: CGSize) {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.linearDamping = 1.0
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 0) // Ensure no initial velocity
        self.physicsBody?.angularVelocity = 0  // Ensure no initial angular velocity
        self.physicsBody?.affectedByGravity = false
    }
    
    func fireMissile(_ missileCategory: UInt32, _ largeAssteroidCategory: UInt32, _ mediumAssteroidCategory: UInt32, _ smallAssteroidCategory: UInt32) -> Date { // put into MissileNode class
        
        let angleInRadians = self.zRotation
        
        let forceMagnitude: CGFloat = 7500.0
        
        let deltaX = forceMagnitude * cos(angleInRadians)
        let deltaY = forceMagnitude * sin(angleInRadians)
        
        let force = CGVector(dx: deltaX, dy: deltaY)
        
        func applyCustomForce(_ force: CGVector) {
            print("Applying force: \(force) to missile at position: \(self.position)")
            
            self.physicsBody?.applyForce(force)
        }
        
        applyCustomForce(force)
        self.physicsBody?.categoryBitMask = missileCategory
        self.physicsBody?.contactTestBitMask = largeAssteroidCategory | mediumAssteroidCategory | smallAssteroidCategory
        self.physicsBody?.affectedByGravity = false

        return Date()
        
    }
}



//
//  SpaceshipNode.swift
//  Assteroids
//
//  Created by Marcus Kim on 6/15/24.
//

import Foundation
import SpriteKit

// TODO: - move this createMissile() method to SpaceshipNode class
// TODO: - Move this handleFiring() method into SpaceshipNode class
// TODO: - Done. Put this activateThrust() method inside SpaceshipNode class. Make sure it works

class SpaceshipNode: SKSpriteNode, PhysicsNodeProtocol{
    
    var velocity: CGVector = CGVector(dx: 0, dy: 0)
    
    required init(systemName: String = K.spaceshipAssetName, anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5), size: CGSize = CGSize(width: 50.0, height: 50.0), position: CGPoint = CGPoint(x: 0, y: 0), zPosition: CGFloat = 10, zRotation: CGFloat = CGFloat.pi / 2, name: String = "spaceship", category: UInt32 = K.largeAssteroidCategory) {
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
        
        createFlame()
        createPhysicsBody(size: size)
        
    }
    
    required init(named: String = K.spaceshipAssetName, anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5), size: CGSize = CGSize(width: 50.0, height: 50.0), position: CGPoint = CGPoint(x: 0.0, y: 0.0), zPosition: CGFloat = 10, zRotation: CGFloat = CGFloat.pi / 2, name: String = "spaceship", category: UInt32 = K.largeAssteroidCategory) {
        var asset: UIImage {
            
            var newImage = UIImage()
            
            if let safeAsset = UIImage(named: named)?.withTintColor(.white) {
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
        
        createFlame()
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
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 0) // Ensure no initial velocity
        self.physicsBody?.angularVelocity = 0  // Ensure no initial angular velocity
        self.physicsBody?.affectedByGravity = false
    }
    
    func activateThrust(thrusting: Bool) {
        guard thrusting else {
            self.removeAllActions()
            return
        }

            let distance: CGFloat = 200.0

            // Function to update acceleration direction based on current rotation
            func updateAccelerationDirection(_ elapsedTime: CGFloat) {
                let angleInRadians = self.zRotation
                let deltaX = distance * cos(angleInRadians)
                let deltaY = distance * sin(angleInRadians)

                self.velocity = CGVector(dx: deltaX * elapsedTime, dy: deltaY * elapsedTime)
                self.physicsBody?.velocity = self.velocity
            }

            // Continuous acceleration
            let accelerationAction = SKAction.repeatForever(SKAction.customAction(withDuration: 99999.9) { _, elapsedTime in
                // Adjust acceleration based on the current rotation
                updateAccelerationDirection(elapsedTime)
            })

            // Run the custom action
            self.run(accelerationAction)
    
    }
    
    func createFlame() {
        if let flameImage = UIImage(systemName: K.flameAssetName)?.withTintColor(.white) {
            
            let data = flameImage.pngData()
            let newImage = UIImage(data: data!)
            let texture = SKTexture(image: newImage!)
            let flame = SKSpriteNode(texture: texture)
            flame.scale(to: CGSize(width: 32.0, height: 48.0))
            flame.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            //spaceship.size = CGSize(width: CGFloat(50.0), height: CGFloat(50.0))
        
            flame.position = self.position
            //flame.position.y -= 5
            
            flame.position = CGPoint(x: -50, y: 0)
            flame.zRotation = self.zRotation
            flame.isHidden = false
            flame.name = K.flameAssetName
            
            self.addChild(flame)
            
        }
    }
    
    
}

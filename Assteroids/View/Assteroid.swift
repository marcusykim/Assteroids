//
//  Assteroid.swift
//  Assteroids
//
//  Created by Marcus Kim on 6/15/24.


import Foundation
import SpriteKit

//TODO: - be able to generate all Assteroids

/*
 
 Find a way eliminate the need to define so many different category bitmasks. There my be a way to handle collision between the missiles and assteroids of all sizes, by creating a piece of state to track what size assteroid was involved in the collision. this state variable might be fed into a switch statement that handles collision differently depending on the assteroid size. We need to handle collisions differently for each size of assteroid because they do different things, i.e., large produces medium, medium produce small, small get removed from the screen (dereferenced)
 
 
 We will use the category bitmasks we assign to each assteroid as an identifier that a method can use to handle collisions differently depending on the bitmask. We just need to ensure that we assign category bit masks whenever we generate a large, medium, or small assteroid
 
 We want to consolidate all the collision handling related to assteroids being shot by a missile into on method that can handle all three cases of large, medium, and small assteroids. Basically, this collision handling method will execute the splitting of the assteroids
 
 From the splitting method, aka, the collision handling method, we will call an assteroid generating method that generates the appropriate sized assteroid depending on what category bitmask we send to it from the splitting method
 
 
 
 */


class Assteroid: SKSpriteNode, PhysicsNodeProtocol {
    
    var assteroidCategory: UInt32 = K.largeAssteroidCategory
    var missileCategory: UInt32 = K.missileCategory
    
    //TODO: - figure out how to flexibly create small, medium, or large assteroid depending on some certain parameter that we pass during instiation of the Assteroid object. 
    
    required init(systemName: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint = CGPoint(x: 0.0, y: 0.0), zPosition: CGFloat, zRotation: CGFloat, name: String, _ assteroidCategory: UInt32) {
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
        
        let randomNegX = Int.random(in: -426 ... -150)
        let randomPosX = Int.random(in: 150...426)
        let randomNegY = Int.random(in: -196 ... -75)
        let randomPosY = Int.random(in: 75...196)
        
        let xCoordinate = [randomNegX, randomPosX]
        let yCoordinate = [randomNegY, randomPosY]
        self.position = CGPoint(x: xCoordinate[Int.random(in: 0...1)], y: yCoordinate[Int.random(in: 0...1)])
        self.zPosition = zPosition
        self.zRotation = zRotation
        self.anchorPoint = anchorPoint
        self.name = name
        self.assteroidCategory = assteroidCategory
        
        createPhysicsBody(size: size)
    }
    
    required init(named: String = K.assAssetName, anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5), size: CGSize = CGSize(width: CGFloat(75.0), height: CGFloat(75.0)), position: CGPoint = CGPoint(x: 0.0, y: 0.0), zPosition: CGFloat = CGFloat(10.0), zRotation: CGFloat = CGFloat(10.0), name: String = "assteroid", _ assteroidCategory: UInt32 = K.largeAssteroidCategory) {
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
        
        let randomNegX = Int.random(in: -426 ... -150)
        let randomPosX = Int.random(in: 150...426)
        let randomNegY = Int.random(in: -196 ... -75)
        let randomPosY = Int.random(in: 75...196)
        
        let xCoordinate = [randomNegX, randomPosX]
        let yCoordinate = [randomNegY, randomPosY]
        self.position = CGPoint(x: xCoordinate[Int.random(in: 0...1)], y: yCoordinate[Int.random(in: 0...1)])
        self.zPosition = zPosition
        self.zRotation = zRotation
        self.anchorPoint = anchorPoint
        self.name = name
        self.assteroidCategory = assteroidCategory
        
        createPhysicsBody(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createPhysicsBody(size: CGSize) {
        
        let velocity = 1 //Int.random(in: 1...2)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        self.physicsBody?.velocity = CGVector(dx: velocity, dy: velocity)  // Ensure no initial velocity
        self.physicsBody?.angularVelocity = CGFloat(integerLiteral: velocity)  // Ensure no initial angular velocity
        self.physicsBody?.categoryBitMask = assteroidCategory
        self.physicsBody?.contactTestBitMask = missileCategory
        self.physicsBody?.affectedByGravity = false
    }
    
    
}

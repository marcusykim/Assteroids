//
//  Assteroid.swift
//  Assteroids
//
//  Created by Marcus Kim on 6/15/24.


import Foundation
import SpriteKit

//TODO: - be able to generate all Assteroids

class Assteroid: SKSpriteNode, PhysicsNodeProtocol {
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
        super.init(texture: texture, color: .white, size: texture.size())
        self.anchorPoint = anchorPoint
        self.position = position
        self.zPosition = zPosition
        self.zRotation = zRotation
        self.name = name
        
        createFlame()
        createPhysicsBody(size: size)
    }
    
    required init(named: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: CGFloat, zRotation: CGFloat, name: String) {
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createPhysicsBody(size: CGSize) {
        
    }
    
    
}

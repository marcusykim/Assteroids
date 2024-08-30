//
//  SpaceshipNode.swift
//  Assteroids
//
//  Created by Marcus Kim on 6/15/24.
//

import Foundation
import SpriteKit

class SpaceshipNode: SKSpriteNode {
    required init(systemName: String, anchorPoint: CGPoint, size: CGSize = CGSize(width: 50, height: 50), position: CGPoint, zPosition: CGFloat = 0, rotationDirection: String, spaceship: SKSpriteNode, name: String) {
        self.rotationDirection = rotationDirection
       // self.asset = UIImage(systemName: systemName)?.withTintColor(.white) ?? UIImage()
        self.spaceship = spaceship
        
        
        //self.size = size
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
        
    }

    required init(named: String, anchorPoint: CGPoint, size: CGSize = CGSize(width: 50, height: 50), position: CGPoint, zPosition: CGFloat = 0, rotationDirection: String, spaceship: SKSpriteNode, name: String) {
        
        
        self.rotationDirection = rotationDirection
        
        self.spaceship = spaceship
        
        print(spaceship)
        //self.size = size
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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

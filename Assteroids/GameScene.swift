//
//  GameScene.swift
//  Assteroids
//
//  Created by Marcus Y. Kim on 11/8/23.
//


import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    

    
    override func sceneDidLoad() {
        
        if let view = self.view {
            self.size = view.bounds.size
        }
        
        //print(self.size)
        //
        //        print(self.size.width)
        //
        //        print(self.size.height)
        
        if let symbolImage = UIImage(systemName: "paperplane") {
            let texture = SKTexture(image: symbolImage)
            
            // Step 2: Create an SKSpriteNode with the SKTexture
            let spriteNode = SKSpriteNode(texture: texture)
            
            spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            //            let anchorOffsetX = (spriteNode.size.width / 2) / spriteNode.size.width
            //            let anchorOffsetY = (spriteNode.size.height / 2) / spriteNode.size.height
            
            // Adjust the anchor point
            //spriteNode.anchorPoint = CGPoint(x: 0.5 + anchorOffsetX, y: 0.5 + anchorOffsetY)
            
            
            spriteNode.size = CGSize(width: CGFloat(50.0), height: CGFloat(50.0))
            
            //            print(spriteNode.size.width)
            //
            //            print(spriteNode.size.height)
            
            // Set position, scale, or any other properties as needed
            spriteNode.position = CGPoint(x: 0, y: 0)
            //spriteNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
            
            //            print(self.size.width)
            //            print(self.size.width / 2)
            //            print(self.size.height)
            //            print(self.size.height / 2)
            
            // print(spriteNode.position)
            
            print("Sprite anchor point: \(spriteNode.anchorPoint)")
            
            
            // Add the spriteNode to your scene or another SKNode
            self.addChild(spriteNode)
            
            // Convert the anchor point to the scene's coordinate system
            let anchorPointInScene = spriteNode.convert(spriteNode.anchorPoint, to: self)
            
            // Check if the converted anchor point is within the visible area
            let isVisible = self.frame.contains(anchorPointInScene)
            
            if isVisible {
                print("Anchor point is within the visible area.")
            } else {
                print("Anchor point is outside the visible area.")
            }
        }
        
        print(self.children)
        
        
    }
}


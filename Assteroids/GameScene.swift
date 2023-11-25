//
//  GameScene.swift
//  Assteroids
//
//  Created by Marcus Y. Kim on 11/8/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var scoreLabel: SKLabelNode!
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var score: Int = 0 {
         didSet {
             // Update the label text when the score changes
             scoreLabel.text = "Score: \(score)"
         }
     }
    
    override func sceneDidLoad() {
        
        if let view = self.view {
            self.size = view.bounds.size
        }
       
        self.addChild(generateSpaceShip()!)
        
        scoreLabel = SKLabelNode(text: "99990")
        scoreLabel.fontSize = 30
        scoreLabel.position = CGPoint(x: -250.0, y: 125.0)
        scoreLabel.color = .white
        scoreLabel.horizontalAlignmentMode = .right

        addChild(scoreLabel)
        
        
    }
    
    
    // Call this whenever the game starts, the user dies, and when we need to add ships to our lives gallery
    func generateSpaceShip() -> SKSpriteNode? {
        if let paperPlaneSymbolImage = UIImage(systemName: "paperplane")?.withTintColor(.white) {
            
            let data = paperPlaneSymbolImage.pngData()
            let newImage = UIImage(data: data!)
            let texture = SKTexture(image: newImage!)
            let spriteNode = SKSpriteNode(texture: texture)
            
            spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            spriteNode.size = CGSize(width: CGFloat(50.0), height: CGFloat(50.0))
            spriteNode.position = CGPoint(x: 0, y: 0)
            
           
            
            //            let anchorPointInScene = spriteNode.convert(spriteNode.anchorPoint, to: self)
            //
            //            let isVisible = self.frame.contains(anchorPointInScene)
            //
            //            if isVisible {
            //                print("Anchor point is within the visible area.")
            //            } else {
            //                print("Anchor point is outside the visible area.")
            //            }
            
            return spriteNode
            
        }
        
        return nil
    }
    
    func incrementScore() {
            // Call this method when the player earns points
            score += 10 // Adjust the score based on your game's rules
        }
    
}


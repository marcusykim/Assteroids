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
    var customContainer: CustomContainerNode!
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var score: Int = 0 {
         didSet {
             // Update the label text when the score changes
             scoreLabel.text = "Score: \(score)"
         }
     }
    
    override func sceneDidLoad() {
        
        customContainer = CustomContainerNode()
        
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

        customContainer.position.x = scoreLabel.position.x
        customContainer.position.y = scoreLabel.position.y - 10
        
        generateLife()
        
    }
    
    
    // Call this whenever the game starts, the user dies, and when we need to add ships to our lives gallery
    func generateSpaceShip(position: CGPoint = CGPoint(x: 0, y: 0)) -> SKSpriteNode? {
        if let paperPlaneSymbolImage = UIImage(systemName: "paperplane")?.withTintColor(.white) {
            
            let data = paperPlaneSymbolImage.pngData()
            let newImage = UIImage(data: data!)
            let texture = SKTexture(image: newImage!)
            let spriteNode = SKSpriteNode(texture: texture)
            
            spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            spriteNode.size = CGSize(width: CGFloat(50.0), height: CGFloat(50.0))
            spriteNode.position = position
            
           
            
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
    
    func generateLife() {
        if let paperPlaneSymbolImage = UIImage(systemName: "paperplane")?.withTintColor(.white) {
            
            let data = paperPlaneSymbolImage.pngData()
            let newImage = UIImage(data: data!)
            let texture = SKTexture(image: newImage!)
            let spriteNode = SKSpriteNode(texture: texture)
            
            spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            spriteNode.size = CGSize(width: CGFloat(50.0), height: CGFloat(50.0))
                
            customContainer.addNode(spriteNode)
            //customContainer.addNode(spriteNode)
                
            addChild(customContainer)
            //            let anchorPointInScene = spriteNode.convert(spriteNode.anchorPoint, to: self)
            //
            //            let isVisible = self.frame.contains(anchorPointInScene)
            //
            //            if isVisible {
            //                print("Anchor point is within the visible area.")
            //            } else {
            //                print("Anchor point is outside the visible area.")
            //            }
            
        }
    }
    
    func incrementScore() {
            // Call this method when the player earns points
            score += 10 // Adjust the score based on your game's rules
        }
    
}

class CustomContainerNode: SKNode {
    
    var childNodes: [SKSpriteNode] = []

    func addNode(_ node: SKSpriteNode) {
        // Add the node to the container
        
        addChild(node)
        
        // Add the node to the array for reference
        childNodes.append(node)
        
        // Arrange nodes based on their position in the array or any other logic
        arrangeNodes()
    }

    private func arrangeNodes() {
        // Your logic to arrange nodes, for example, line them up horizontally
        var offsetX: CGFloat = 0

        for node in childNodes {
            node.position = CGPoint(x: offsetX, y: 0)
            offsetX += node.size.width + 10  // Adjust the spacing between nodes
        }
    }
}

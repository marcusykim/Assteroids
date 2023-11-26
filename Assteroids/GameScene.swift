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
    let imageName = "FlippedButt"
    
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
        scoreLabel.color = .white
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.scene?.anchorPoint = CGPoint(x: 1.0, y: 0.5)

        
        scoreLabel.position = CGPoint(x: -245, y: 120)
        customContainer.position = CGPoint(x: -255, y: 100)
        
        addChild(scoreLabel)
        generateLife()
        
        // Replace with the name of your image file
        if let texture = SKTextureAtlas(named: imageName).textureNamed(imageName) as? SKTexture {
            let imageNode = SKSpriteNode(texture: texture)
                    // Set the position, scale, or any other properties as needed
                    imageNode.position = CGPoint(x: size.width / 2, y: size.height / 2)

                    // Add the SKSpriteNode to the scene
                    addChild(imageNode)
                } else {
                    print("Failed to load texture for image: \(imageName)")
                }
        
        
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
            
            
                
            for _ in 0..<3 {
                
                let data = paperPlaneSymbolImage.pngData()
                let newImage = UIImage(data: data!)
                let texture = SKTexture(image: newImage!)
                let spriteNode = SKSpriteNode(texture: texture)
                
                spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                spriteNode.size = CGSize(width: CGFloat(20.0), height: CGFloat(20.0))
                customContainer.addNode(spriteNode)
            }
                
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
            offsetX += node.size.width - 45  // Adjust the spacing between nodes
        }
    }
}

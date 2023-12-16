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
    var spaceship: SKSpriteNode!
    var rotating = false
    
    var leftArrowNode: SKSpriteNode!
    var rightArrowNode: SKSpriteNode!
    var thrustNode: SKSpriteNode!
    var triggerNode: SKSpriteNode!
    
    var score: Int = 0 {
         didSet {
             // Update the label text when the score changes
             scoreLabel.text = "Score: \(score)"
         }
     }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
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
        
        self.addChild(generatePoop(position: CGPoint(x: 150, y: 0))!)
        
        self.addChild(generateButt(position: CGPoint(x: -150, y: 0))!)
        
       generateButtons()
        
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        
        if self.view != nil {
            print("view exists")
        } else {
            print("view does not exist")
        }
        
        self.view?.addGestureRecognizer(tapGesture)
        
        if let tapGestureRecognizers = self.view?.gestureRecognizers?.compactMap({ $0 as? UILongPressGestureRecognizer }), !tapGestureRecognizers.isEmpty {
            // There is at least one UILongPressGestureRecognizer
            print("Tap gesture recognizer exists.")
        } else {
            // No UILongPressRecognizer is added to the view
            print("No tap gesture recognizer.")
        }
        
        
        
        
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        print("handleLongPress called")
        
        let tapLocationInView = gestureRecognizer.location(in: self.view)

        let tapLocationInScene = convertPoint(fromView: tapLocationInView)
          
        if let tappedNode = self.atPoint(tapLocationInScene) as? SKSpriteNode {
       
            print("inside optional binding")
            
            if leftArrowNode == tappedNode{
              
                print("Left arrow pressed!")
                
                switch gestureRecognizer.state {
                        case .began:
                            // Start rotating when the long press begins
                            rotating = true
                    rotateSpaceship(direction: leftArrowNode)
                        case .ended, .cancelled:
                            // Stop rotating when the long press ends or is cancelled
                            rotating = false
                            rotateSpaceship(direction: leftArrowNode)
                        default:
                            break
                        }
            } else if rightArrowNode == tappedNode{
                print("Right arrow pressed!")
                
                switch gestureRecognizer.state {
                        case .began:
                            // Start rotating when the long press begins
                            rotating = true
                            rotateSpaceship(direction: rightArrowNode)
                        case .ended, .cancelled:
                            // Stop rotating when the long press ends or is cancelled
                            rotating = false
                    rotateSpaceship(direction: rightArrowNode)
                        default:
                            break
                        }
            }
        }
           
        }
    
    func rotateSpaceship(direction: SKSpriteNode) {
            // Check if rotating is enabled
            guard rotating else {
                spaceship.removeAction(forKey: "rotateAction")
                return
            }

            // Rotate the spaceship continuously
        
        if direction == leftArrowNode {
            let rotateAction = SKAction.rotate(byAngle: CGFloat.pi/2, duration: 0.5)
        } else if direction == rightArrowNode {
            
        }
        
            
            let repeatAction = SKAction.repeatForever(rotateAction)
            spaceship.run(repeatAction, withKey: "rotateAction")
        }
    
    // Call this whenever the game starts, the user dies, and when we need to add ships to our lives gallery
    func generateSpaceShip(position: CGPoint = CGPoint(x: 0, y: 0)) -> SKSpriteNode? {
        if let paperPlaneSymbolImage = UIImage(systemName: "paperplane")?.withTintColor(.white) {
            
            let data = paperPlaneSymbolImage.pngData()
            let newImage = UIImage(data: data!)
            let texture = SKTexture(image: newImage!)
            spaceship = SKSpriteNode(texture: texture)
            
            spaceship.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            spaceship.size = CGSize(width: CGFloat(50.0), height: CGFloat(50.0))
            spaceship.position = position
            
            return spaceship
            
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
            
        }
    }
    
    func incrementScore() {
            // Call this method when the player earns points
            score += 10 // Adjust the score based on your game's rules
        }
    
    func generatePoop(position: CGPoint = CGPoint(x: 0, y: 0)) -> SKSpriteNode? {
        if let poop = UIImage(named: "PoopWhite")?.withTintColor(.white) {
            
            let texture = SKTexture(image: poop)
            let spriteNode = SKSpriteNode(texture: texture)
            
            spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            spriteNode.size = CGSize(width: CGFloat(50.0), height: CGFloat(50.0))
            spriteNode.position = position
            
            return spriteNode
        }
        return nil
    }
    
    
    func generateButt(position: CGPoint = CGPoint(x: 0, y: 0)) -> SKSpriteNode? {
        
        if let butt = UIImage(named: "FlippedButt")?.withTintColor(.white) {
            
            let texture = SKTexture(image: butt)
            let spriteNode = SKSpriteNode(texture: texture)
            
            spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            spriteNode.size = CGSize(width: CGFloat(100.0), height: CGFloat(100.0))
            spriteNode.position = CGPoint(x: -150, y: 0)
            
            return spriteNode
        }
        
        
        return nil
    }
    
    func generateButtons() {
        if let leftArrow = UIImage(systemName: "arrowtriangle.left.square.fill")?.withTintColor(.white) {
            
            let data = leftArrow.pngData()
            let newImage = UIImage(data: data!)
            let texture = SKTexture(image: newImage!)
            leftArrowNode = SKSpriteNode(texture: texture)
            
            leftArrowNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            leftArrowNode.size = CGSize(width: CGFloat(30.0), height: CGFloat(30.0))
            leftArrowNode.position = CGPoint(x: -312.5, y: -120)
            
            self.addChild(leftArrowNode)
            
        }
        
        if let rightArrow = UIImage(systemName: "arrowtriangle.right.square.fill")?.withTintColor(.white) {
            
            let data = rightArrow.pngData()
            let newImage = UIImage(data: data!)
            let texture = SKTexture(image: newImage!)
            rightArrowNode = SKSpriteNode(texture: texture)
            
            rightArrowNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            rightArrowNode.size = CGSize(width: CGFloat(30.0), height: CGFloat(30.0))
            rightArrowNode.position = CGPoint(x: -258, y: -120)
            
            self.addChild(rightArrowNode)
            
        }
        
        if let thrust = UIImage(named: "thrust")?.withTintColor(.white) {
            
            let texture = SKTexture(image: thrust)
            thrustNode = SKSpriteNode(texture: texture)
            
            thrustNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            thrustNode.size = CGSize(width: CGFloat(35.0), height: CGFloat(35.0))
            thrustNode.position = CGPoint(x: 312.5, y: -120)
            
            self.addChild(thrustNode)
            
        }

        if let trigger = UIImage(named: "Crosshair")?.withTintColor(.white) {
            
            let texture = SKTexture(image: trigger)
            triggerNode = SKSpriteNode(texture: texture)
            
            triggerNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            triggerNode.size = CGSize(width: CGFloat(50.0), height: CGFloat(50.0))
            triggerNode.position = CGPoint(x: 258, y: -120)
            
            self.addChild(triggerNode)
            
        }


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
            offsetX += node.size.width - 37.5  // Adjust the spacing between nodes
        }
    }
}

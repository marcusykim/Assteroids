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
    var thrusting = false
    var firing = false
    var flame: SKSpriteNode!
    
    var leftArrowNode: SKSpriteNode!
    var rightArrowNode: SKSpriteNode!
    var thrustNode: SKSpriteNode!
    var triggerNode: SKSpriteNode!
    var buttNode: [Int: SKSpriteNode] = [:]
    
    var score: Int = 0 {
         didSet {
             // Update the label text when the score changes
             scoreLabel.text = "Score: \(score)"
         }
     }
    
    override func didMove(to view: SKView) {
        
        print("\(UIScreen.main.bounds.width)     \(UIScreen.main.bounds.height)")
        
        print(self.view!.bounds.size)
        
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
        
        generateButt()
        
        generateButtons()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.01
        
        self.view?.addGestureRecognizer(longPressGesture)
        
        //        if self.view != nil {
        //            print("view exists")
        //        } else {
        //            print("view does not exist")
        //        }
//        if let tapGestureRecognizers = self.view?.gestureRecognizers?.compactMap({ $0 as? UILongPressGestureRecognizer }), !tapGestureRecognizers.isEmpty {
//            // There is at least one UILongPressGestureRecognizer
//            print("Tap gesture recognizer exists.")
//        } else {
//            // No UILongPressRecognizer is added to the view
//            print("No tap gesture recognizer.")
//        }
        
        
        
        
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
            } else if thrustNode == tappedNode {
                print("thrust pressed!")
                
                switch gestureRecognizer.state {
                        case .began:
                            // Start rotating when the long press begins
                            thrusting = true
                            activateThrust(thrustNode: thrustNode)
                        case .ended, .cancelled:
                            // Stop rotating when the long press ends or is cancelled
                            thrusting = false
                            activateThrust(thrustNode: thrustNode)
                        default:
                            break
                        }
            } else if triggerNode == tappedNode {
                print("trigger pressed!")
                
                switch gestureRecognizer.state {
                        case .began:
                            // Start rotating when the long press begins
                            firing = true
                            handleFiring()
                        case .ended, .cancelled:
                            // Stop rotating when the long press ends or is cancelled
                            thrusting = false
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
            let rotateAction = SKAction.rotate(byAngle: CGFloat.pi, duration: 1.0)
            let repeatAction = SKAction.repeatForever(rotateAction)
            spaceship.run(repeatAction, withKey: "rotateAction")
        } else if direction == rightArrowNode {
            let rotateAction = SKAction.rotate(byAngle: -CGFloat.pi, duration: 1.0)
            let repeatAction = SKAction.repeatForever(rotateAction)
            spaceship.run(repeatAction, withKey: "rotateAction")
        }
        
        }
    
    func activateThrust(thrustNode: SKSpriteNode) {
        
        guard thrusting else {
            spaceship.removeAllActions()
            return
        }
        
        
        
        if thrustNode == self.thrustNode {
            let distance: CGFloat = 200.0 // Adjust the distance to fit your needs
            let angleInRadians = spaceship.zRotation // Get the current rotation angle in radians

            // Calculate the new position
            let deltaX = distance * cos(angleInRadians)
            let deltaY = distance * sin(angleInRadians)

            let accelerationAction = SKAction.repeatForever(SKAction.customAction(withDuration: 99999.9) { _, elapsedTime in
                            // Adjust acceleration as needed
                                        let velocity = CGVector(dx: deltaX * elapsedTime, dy: deltaY * elapsedTime)  // Example acceleration
                                        self.spaceship.physicsBody?.velocity = velocity
                                    })

                        // Run the custom action
            spaceship.run(accelerationAction)
            
        }
        
        
    }
    
    func handleFiring() {
        // Create a missile
        let missile = createMissile()!
        missile.position = spaceship.position
        addChild(missile)

        let angleInRadians = spaceship.zRotation
        
        let forceMagnitude: CGFloat = 2500.0
        
        let deltaX = forceMagnitude * cos(angleInRadians)
        let deltaY = forceMagnitude * sin(angleInRadians)
        
        // Apply an upward force to the missile
        
        let force = CGVector(dx: deltaX, dy: deltaY)
        
        // Apply the force to the missile's physics body
        missile.physicsBody?.applyForce(force)
    }
    
    func createMissile() -> SKSpriteNode? {
        
        if let paperPlaneSymbolImage = UIImage(systemName: "hand.point.right.fill")?.withTintColor(.white) {
            
            let data = paperPlaneSymbolImage.pngData()
            let newImage = UIImage(data: data!)
            let texture = SKTexture(image: newImage!)
            let missile = SKSpriteNode(texture: texture)
            
            missile.zRotation = spaceship.zRotation
            
            missile.physicsBody = SKPhysicsBody(rectangleOf: missile.size)
            missile.physicsBody?.collisionBitMask = 0
            missile.physicsBody?.isDynamic = true
            missile.physicsBody?.affectedByGravity = false
            missile.physicsBody?.mass = 0.1
            
            return missile
            
        }
        
        return nil
        
        //let missile = SKSpriteNode(color: .white, size: CGSize(width: 5, height: 15))
        
//        if let missileImage = UIImage(named: "missile")?.withTintColor(.white) {
//            
//            let texture = SKTexture(image: missileImage)
//            let missile = SKSpriteNode(texture: texture)
//
//            missile.physicsBody = SKPhysicsBody(rectangleOf: missile.size)
//                missile.physicsBody?.collisionBitMask = 0
//                missile.physicsBody?.isDynamic = true
//                missile.physicsBody?.affectedByGravity = false
//                missile.physicsBody?.mass = 0.1
//            // Additional configuration (e.g., texture, physics properties)
//            return missile
//        }
        
        
     
    }
    
    func removeMissile(_ missile: SKSpriteNode) {
        missile.removeFromParent()
    }

    override func update(_ currentTime: TimeInterval) {
        // Check if the spaceship is out of bounds
        checkOutOfBounds(for: self.spaceship)
        
        for counter in 1...1 {
            checkOutOfBounds(for: self.buttNode[counter]!)
        }
        
        flame.position = spaceship.position
        flame.zRotation = spaceship.zRotation
        
        // Other update logic if needed
    }
    
    func checkOutOfBounds(for node: SKSpriteNode) {
        let screenWidth = self.size.width
        let screenHeight = self.size.height

        // Check if the spaceship is out of bounds on the right side
        if node.position.x > screenWidth / 2 + node.size.width / 2 {
            node.position.x = -screenWidth / 2 - node.size.width / 2
        }

        // Check if the spaceship is out of bounds on the left side
        if node.position.x < -screenWidth / 2 - node.size.width / 2 {
            node.position.x = screenWidth / 2 + node.size.width / 2
        }

        // Check if the spaceship is out of bounds at the top
        if node.position.y > screenHeight / 2 + node.size.height / 2 {
            node.position.y = -screenHeight / 2 - node.size.height / 2
        }

        // Check if the spaceship is out of bounds at the bottom
        if node.position.y < -screenHeight / 2 - node.size.height / 2 {
            node.position.y = screenHeight / 2 + node.size.height / 2
        }
        
        
        
    }
    
    // Call this whenever the game starts, the user dies, and when we need to add ships to our lives gallery
    func generateSpaceShip(position: CGPoint = CGPoint(x: 0, y: 0)) -> SKSpriteNode? {
        if let paperPlaneSymbolImage = UIImage(systemName: "hand.point.right")?.withTintColor(.white) {
            
            let data = paperPlaneSymbolImage.pngData()
            let newImage = UIImage(data: data!)
            let texture = SKTexture(image: newImage!)
            spaceship = SKSpriteNode(texture: texture)
            
            spaceship.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            //spaceship.size = CGSize(width: CGFloat(50.0), height: CGFloat(50.0))
            spaceship.position = position
            spaceship.zRotation = CGFloat.pi / 2
            
            spaceship.physicsBody = SKPhysicsBody(rectangleOf: spaceship.size)
            spaceship.physicsBody?.isDynamic = true
            spaceship.physicsBody?.linearDamping = 1.0
            spaceship.physicsBody?.velocity = CGVector(dx: 0, dy: 0)  // Ensure no initial velocity
            spaceship.physicsBody?.angularVelocity = 0  // Ensure no initial angular velocity
            spaceship.physicsBody?.affectedByGravity = false
            
            if let paperPlaneSymbolImage = UIImage(systemName: "flame")?.withTintColor(.white) {
                
                let data = paperPlaneSymbolImage.pngData()
                let newImage = UIImage(data: data!)
                let texture = SKTexture(image: newImage!)
                flame = SKSpriteNode(texture: texture)
                flame.scale(to: CGSize(width: 32.0, height: 48.0))
                
                flame.anchorPoint = CGPoint(x: 0.0, y: 1.0)
                //spaceship.size = CGSize(width: CGFloat(50.0), height: CGFloat(50.0))
                
                flame.position = spaceship.position
                flame.position.y -= 5
                flame.zRotation = CGFloat.pi
                
                addChild(flame)
                
            }
            
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
    
    func generateButt(position: CGPoint = CGPoint(x: 0, y: 0))// -> SKSpriteNode?
    {
        
        for counter in 1...1 {
            
            if let butt = UIImage(named: "FlippedButt")?.withTintColor(.white) {
                
                let texture = SKTexture(image: butt)
                let spriteNode = SKSpriteNode(texture: texture)
                
                spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                spriteNode.size = CGSize(width: CGFloat(100.0), height: CGFloat(100.0))
                
                let randomNegX = Int.random(in: -426 ... -150)
                let randomPosX = Int.random(in: 150...426)
                let randomNegY = Int.random(in: -196 ... -75)
                let randomPosY = Int.random(in: 75...196)
                
                let xCoordinate = [randomNegX, randomPosX]
                let yCoordinate = [randomNegY, randomPosY]
                
                
                spriteNode.position = CGPoint(x: xCoordinate[Int.random(in: 0...1)], y: yCoordinate[Int.random(in: 0...1)])
                
                let velocity = Int.random(in: 5...20)
                
                spriteNode.physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size)
                spriteNode.physicsBody?.isDynamic = true
                spriteNode.physicsBody?.velocity = CGVector(dx: velocity, dy: velocity)  // Ensure no initial velocity
                spriteNode.physicsBody?.angularVelocity = CGFloat(integerLiteral: velocity)  // Ensure no initial angular velocity
                spriteNode.physicsBody?.affectedByGravity = false
                
                self.addChild(spriteNode)
                self.buttNode[counter] = spriteNode
                
                
                
            }
            
            
        }
        
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

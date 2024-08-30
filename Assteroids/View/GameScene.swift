//
//  GameScene.swift
//  Assteroids
//
//  Created by Marcus Y. Kim on 11/8/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    
    //MARK: - TODOS
    
    //TODO: Create subclasses of of SKSpriteNode in their own files/classes and instantiate the classes with the variable names below
        // scoreCounterNode
        // liveGallery
        // rotateLeftNode
        // rotateRightNode
        // spaceshipNode
        // triggerNode
        // poopNode
        // thrustNode
        // smallAssteroidNode
        // mediumAssteroidNode
        // largeAssteroidNode
    
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
    var velocity: CGVector!
    var missile: [Int: SKSpriteNode?] = [:]
    var whenMissileFired: Date!
    let maxSecondsForMissiles: Double = 1.25
    
    var leftArrowNode: RotateButton!
    var rightArrowNode: RotateButton!
    var thrustNode: SKSpriteNode!
    var triggerNode: SKSpriteNode!
    var buttNode: [Int: SKSpriteNode] = [:]
    var mediumButtNode: [Int: SKSpriteNode] = [:]
    var smallButtNode: [Int: SKSpriteNode] = [:]
    
    let buttNodeMax: Int = 9
    let missileCategory: UInt32 = 0b0001
    let asteroidCategory: UInt32 = 0b0010
    let mediumAsteroidCategory: UInt32 = 0b0100
    let smallAsteroidCategory: UInt32 = 0b1000
    
    var score: Int = 0 {
         didSet {
             scoreLabel.text = "Score: \(score)"
         }
        
        //modifier1
        //modifier2
        // scoreNode object
        
        // return score node object
     }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
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
        
        // makeButton(node: SKSpriteNode) pass the data to this method and pass in a different node for each button
        generateButtons()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.01
        
        self.view?.addGestureRecognizer(longPressGesture)
        
    }
    
    // @objc func rotateSpaceship(_ gestureRecognizer: UILongPressGestureRecognizer)
        // we can detect in each of these functions what node has been pressed by using the tapped location in an if statement to check if the appropriate node has be longpressed
    // @objc func thrust(_ gestureRecognizer: UILongPressGestureRecognizer)
    // @objc func trigger(_ gestureRecognizer: UILongPressGestureRecognizer)
    
    // if the handleLongPress method was in another class, we could call it by object.handleLongPress(gestureRecognizer)
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        print("handleLongPress called")
        
        let tapLocationInView = gestureRecognizer.location(in: self.view)
        let tapLocationInScene = convertPoint(fromView: tapLocationInView)
        
        if let rotateTappedNode = self.atPoint(tapLocationInScene) as? RotateButton {
            
            
            print("inside rotation optional binding") // this is being successfully executed
            
            if rotateTappedNode.name == K.leftArrowName { // this is being evaluated, so at least we know that we need to somehow downcast RotateButton into an SKSpriteNode
              
                print("Left arrow pressed!")
                
                switch gestureRecognizer.state {
                        case .began:
                            // Start rotating when the long press begins
                            rotating = true
                            rotateTappedNode.rotateSpaceship()
                        case .ended, .cancelled:
                            // Stop rotating when the long press ends or is cancelled
                            rotating = false
                            rotateTappedNode.rotateSpaceship()
                    
                    // rotateLeftButton.rotateSpaceship()
                    
                        default:
                            break
                        }
            } else if rotateTappedNode.name == K.rightArrowName {
                print("Right arrow pressed!")
                
                switch gestureRecognizer.state {
                        case .began:
                            // Start rotating when the long press begins
                            rotating = true
                    rotateTappedNode.rotateSpaceship()
                        case .ended, .cancelled:
                            // Stop rotating when the long press ends or is cancelled
                            rotating = false
                        rotateTappedNode.rotateSpaceship()
                    
                    // rotateRightButton.rotateSpaceship()
                        default:
                            break
                        }
            }
        }
        
        
        if let tappedNode = self.atPoint(tapLocationInScene) as? SKSpriteNode {
            print("inside optional binding")
            if thrustNode == tappedNode {
                print("thrust pressed!")
                
                switch gestureRecognizer.state {
                        case .began:
                            // Start rotating when the long press begins
                            thrusting = true
                            activateThrust(thrustNode: thrustNode)
                        case .ended, .cancelled:
                            // Stop rotating when the long press ends or is cancelled
                    
                            print("thrust ended")
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
    
    
    //TODO: - Package UILongPressGestureRecognizer along with the rotation functionality
    
//    func rotateSpaceship(direction: SKSpriteNode) {
//            // Check if rotating is enabled
//            guard rotating else {
//                spaceship.removeAction(forKey: "rotateAction")
//                return
//            }
//        
//        if direction == leftArrowNode {
//            let rotateAction = SKAction.rotate(byAngle: CGFloat.pi, duration: 1.0)
//            let repeatAction = SKAction.repeatForever(rotateAction)
//            spaceship.run(repeatAction, withKey: "rotateAction")
//        } else if direction == rightArrowNode {
//            let rotateAction = SKAction.rotate(byAngle: -CGFloat.pi, duration: 1.0)
//            let repeatAction = SKAction.repeatForever(rotateAction)
//            spaceship.run(repeatAction, withKey: "rotateAction")
//        }
//        
//        }
    
    
    
    
    
    func activateThrust(thrustNode: SKSpriteNode) {
        guard thrusting else {
            spaceship.removeAllActions()
            return
        }

        if thrustNode == self.thrustNode {
            let distance: CGFloat = 200.0

            // Function to update acceleration direction based on current rotation
            func updateAccelerationDirection(_ elapsedTime: CGFloat) {
                let angleInRadians = spaceship.zRotation
                let deltaX = distance * cos(angleInRadians)
                let deltaY = distance * sin(angleInRadians)

                self.velocity = CGVector(dx: deltaX * elapsedTime, dy: deltaY * elapsedTime)
                self.spaceship.physicsBody?.velocity = self.velocity
            }

            // Continuous acceleration
            let accelerationAction = SKAction.repeatForever(SKAction.customAction(withDuration: 99999.9) { _, elapsedTime in
                // Adjust acceleration based on the current rotation
                updateAccelerationDirection(elapsedTime)
            })

            // Run the custom action
            spaceship.run(accelerationAction)
        }
    }
    
    func handleFiring() {
        // Create a missile
        let tempMissile = createMissile()!
        tempMissile.position = spaceship.position
        addChild(tempMissile)

        let angleInRadians = spaceship.zRotation
        
        let forceMagnitude: CGFloat = 2500.0
        
        let deltaX = forceMagnitude * cos(angleInRadians)
        let deltaY = forceMagnitude * sin(angleInRadians)
        
        // Apply an upward force to the missile
        
        let force = CGVector(dx: deltaX, dy: deltaY)
        
        // Apply the force to the missile's physics body
        tempMissile.physicsBody?.applyForce(force)
        tempMissile.physicsBody?.categoryBitMask = missileCategory
        tempMissile.physicsBody?.contactTestBitMask = asteroidCategory | mediumAsteroidCategory
        //tempMissile.physicsBody?.contactTestBitMask = asteroidCategory
        tempMissile.physicsBody?.affectedByGravity = false

        whenMissileFired = Date()
        
        if missile.isEmpty {
            missile[1] = tempMissile
        } else {
            missile[missile.keys.max()! + 1] = tempMissile
        }
        
        print(self.missile.keys.max()!)
        
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
        
    }
    
    func removeMissile(_ missile: SKSpriteNode) {
        missile.removeFromParent()
    }
    var mediumButtNodeCounter = 0
    var smallButtNodeCounter = 0
    
    
    override func update(_ currentTime: TimeInterval) {
        // Check if the spaceship is out of bounds
        
        // Call all methods from here?
        
        
        checkOutOfBounds(for: self.spaceship)
        
        var counter: Int = 1
        
        for _ in missile {
            checkOutOfBounds(for: self.missile[counter]!!)
            
            let removeAction = SKAction.sequence([
                        SKAction.wait(forDuration: maxSecondsForMissiles),
                        SKAction.removeFromParent()
                        
                    ])

            if let safeMissile = self.missile[counter] {
                safeMissile!.run(removeAction)
                
            }
            counter += 1
        }
        
        if !missile.isEmpty {
            
            let elapsedTime = Date().timeIntervalSince(whenMissileFired)
            
            //print("elapsedTime: \(elapsedTime)")
            //print("maxSecondsForMissiles: \(maxSecondsForMissiles)")
            
            if elapsedTime > maxSecondsForMissiles {
                
                print("inside elapsedTime if statement")
                self.missile.removeValue(forKey: self.missile.keys.max()!)
            }
        }
        
        counter = 0
        
        for counter in 0...buttNodeMax {
            //print("buttNode: ", buttNode)
            checkOutOfBounds(for: self.buttNode[counter]!)
        }
        
        
        
        for mediumButtNodeCounter in 0...self.mediumButtNode.count {
            
            if mediumButtNode[mediumButtNodeCounter] != nil {
                //print("mediumButtNode in update: ", mediumButtNode)
                checkOutOfBounds(for: self.mediumButtNode[mediumButtNodeCounter]!)
            }
        }
        
        
        for smallButtNodeCounter in 0...self.mediumButtNode.count {
            
            if smallButtNode[smallButtNodeCounter] != nil {
                //print("mediumButtNode in update: ", mediumButtNode)
                checkOutOfBounds(for: self.smallButtNode[smallButtNodeCounter]!)
            }
        }
        
        if thrusting == true {
            flame.isHidden.toggle()
        }
        
        if thrusting == false {
            flame.isHidden = true
        }
 
        
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
    
// TODO: - put all the spaceship functionality in the Spaceship Class
   
    func generateSpaceShip(position: CGPoint = CGPoint(x: 0, y: 0)) -> SKSpriteNode? {
        if let paperPlaneSymbolImage = UIImage(systemName: "hand.point.right")?.withTintColor(.white) {
            
            let data = paperPlaneSymbolImage.pngData()
            let newImage = UIImage(data: data!)
            let texture = SKTexture(image: newImage!)
            spaceship = SKSpriteNode(texture: texture)
            spaceship.name = "spaceship"
            spaceship.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            //spaceship.size = CGSize(width: CGFloat(50.0), height: CGFloat(50.0))
            spaceship.position = position
            spaceship.zRotation = CGFloat.pi / 2
            
            spaceship.physicsBody = SKPhysicsBody(rectangleOf: spaceship.size)
            
            //init(physicsBody: SKPhysicsBody(rectangleOf: ))
            
            spaceship.physicsBody?.isDynamic = true
            spaceship.physicsBody?.linearDamping = 1.0
            spaceship.physicsBody?.velocity = CGVector(dx: 0, dy: 0)  // Ensure no initial velocity
            spaceship.physicsBody?.angularVelocity = 0  // Ensure no initial angular velocity
            spaceship.physicsBody?.affectedByGravity = false
            
            if let flameImage = UIImage(systemName: "flame")?.withTintColor(.white) {
                
                let data = flameImage.pngData()
                let newImage = UIImage(data: data!)
                let texture = SKTexture(image: newImage!)
                flame = SKSpriteNode(texture: texture)
                flame.scale(to: CGSize(width: 32.0, height: 48.0))
                
                flame.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                //spaceship.size = CGSize(width: CGFloat(50.0), height: CGFloat(50.0))
                
                flame.position = spaceship.position
                //flame.position.y -= 5
                
                flame.position = CGPoint(x: -50, y: 0)
                flame.zRotation = spaceship.zRotation
                flame.isHidden = true
                spaceship.addChild(flame)
                
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
        
        for counter in 0...buttNodeMax {
            
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
                
                let velocity = Int.random(in: 1...3)
                
                spriteNode.physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size)
                spriteNode.physicsBody?.isDynamic = true
                spriteNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                spriteNode.physicsBody?.velocity = CGVector(dx: velocity, dy: velocity)  // Ensure no initial velocity
                spriteNode.physicsBody?.angularVelocity = CGFloat(integerLiteral: velocity)  // Ensure no initial angular velocity
                spriteNode.physicsBody?.categoryBitMask = asteroidCategory
                spriteNode.physicsBody?.contactTestBitMask = missileCategory
                spriteNode.physicsBody?.affectedByGravity = false
                
                self.addChild(spriteNode)
                self.buttNode[counter] = spriteNode
                
                
                
            }
            
            
        }
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
          
        let collisionMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

                if collisionMask == (missileCategory | asteroidCategory) {
                    if let collidedMissileNode = contact.bodyA.node as? SKSpriteNode, let collidedButtNode = contact.bodyB.node as? SKSpriteNode {
                    
                        missileDidCollideWithAsteroid(missile: collidedMissileNode, asteroid: collidedButtNode)
                    }
                } else if collisionMask == (missileCategory | mediumAsteroidCategory) {
                    // Handle collision between missile and medium asteroid
                    if let collidedMissileNode = contact.bodyA.node as? SKSpriteNode, let collidedButtNode = contact.bodyB.node as? SKSpriteNode {
                                           
                        missileDidCollideWithMediumAsteroid(missile: collidedMissileNode, asteroid: collidedButtNode)
                    }
                    
                } else if collisionMask == (missileCategory | smallAsteroidCategory) {
                    if let collidedMissileNode = contact.bodyA.node as? SKSpriteNode, let collidedButtNode = contact.bodyB.node as? SKSpriteNode {
                                           
                        missileDidCollideWithSmallAsteroid(missile: collidedMissileNode, asteroid: collidedButtNode)
                    }
                }
        }
    
    func missileDidCollideWithAsteroid(missile: SKSpriteNode, asteroid: SKSpriteNode) {

        splitAsteroid(originalAsteroid: asteroid)

        // Remove the missile from the scene
        missile.removeFromParent()
    }
    
    func splitAsteroid(originalAsteroid: SKSpriteNode) {
   
        originalAsteroid.removeFromParent()

  
        if let mediumAsteroid1 = UIImage(named: "FlippedButt")?.withTintColor(.white) {
            
            let texture = SKTexture(image: mediumAsteroid1)
            let spriteNode = SKSpriteNode(texture: texture)
            
            spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            spriteNode.size = CGSize(width: CGFloat(75.0), height: CGFloat(75.0))
            
            spriteNode.position = CGPoint(x: originalAsteroid.position.x + 20, y: originalAsteroid.position.y + 20)
            
            let velocity = Int.random(in: 4...7)
            
            spriteNode.physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size)
            spriteNode.physicsBody?.isDynamic = true
            spriteNode.physicsBody?.velocity = CGVector(dx: velocity, dy: velocity)  // Ensure no initial velocity
            spriteNode.physicsBody?.angularVelocity = CGFloat(integerLiteral: velocity)  // Ensure no initial angular velocity
            spriteNode.physicsBody?.categoryBitMask = mediumAsteroidCategory
            spriteNode.physicsBody?.contactTestBitMask = missileCategory
            spriteNode.physicsBody?.affectedByGravity = false
            
            mediumButtNode[self.mediumButtNodeCounter] = spriteNode
            print("mediumButtNodeCounter: ", mediumButtNodeCounter)
            print("mediumButtNode: ", mediumButtNode)
            addChild(spriteNode)
            self.mediumButtNodeCounter += 1
        }


        if let mediumAsteroid2 = UIImage(named: "FlippedButt")?.withTintColor(.white) {
            
            let texture = SKTexture(image: mediumAsteroid2)
            let spriteNode = SKSpriteNode(texture: texture)
            
            spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            spriteNode.size = CGSize(width: CGFloat(75.0), height: CGFloat(75.0))
        
            spriteNode.position = CGPoint(x: originalAsteroid.position.x - 20, y: originalAsteroid.position.y - 20)
            let velocity = Int.random(in: 3...6)
            
            spriteNode.physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size)
            spriteNode.physicsBody?.isDynamic = true
            spriteNode.physicsBody?.velocity = CGVector(dx: velocity, dy: velocity)  // Ensure no initial velocity
            spriteNode.physicsBody?.angularVelocity = CGFloat(integerLiteral: velocity)  // Ensure no initial angular velocity
            spriteNode.physicsBody?.categoryBitMask = mediumAsteroidCategory
            spriteNode.physicsBody?.contactTestBitMask = missileCategory
            spriteNode.physicsBody?.affectedByGravity = false
            
            mediumButtNode[mediumButtNodeCounter] = spriteNode
            addChild(spriteNode)
            mediumButtNodeCounter += 1
            
        }
        

    }

    
    func missileDidCollideWithMediumAsteroid(missile: SKSpriteNode, asteroid: SKSpriteNode) {

        // Call the function to split the asteroid
        splitMediumAsteroid(originalAsteroid: asteroid)

        // Remove the missile from the scene
        missile.removeFromParent()
    }
    
    func splitMediumAsteroid(originalAsteroid: SKSpriteNode) {
        // Remove the original asteroid from the scene
        originalAsteroid.removeFromParent()

        
        if let smallAsteroid1 = UIImage(named: "FlippedButt")?.withTintColor(.white) {
            
            let texture = SKTexture(image: smallAsteroid1)
            let spriteNode = SKSpriteNode(texture: texture)
            
            spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            spriteNode.size = CGSize(width: CGFloat(50.0), height: CGFloat(50.0))
            
            spriteNode.position = CGPoint(x: originalAsteroid.position.x + 20, y: originalAsteroid.position.y + 20)
         
            
            
            let velocity = Int.random(in: 4...7)
            
            spriteNode.physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size)
            spriteNode.physicsBody?.isDynamic = true
            spriteNode.physicsBody?.velocity = CGVector(dx: velocity, dy: velocity)  // Ensure no initial velocity
            spriteNode.physicsBody?.angularVelocity = CGFloat(integerLiteral: velocity)  // Ensure no initial angular velocity
            spriteNode.physicsBody?.categoryBitMask = smallAsteroidCategory
            spriteNode.physicsBody?.contactTestBitMask = missileCategory
            spriteNode.physicsBody?.affectedByGravity = false
            
            smallButtNode[self.smallButtNodeCounter] = spriteNode
//            print("mediumButtNodeCounter: ", mediumButtNodeCounter)
//            print("mediumButtNode: ", mediumButtNode)
            addChild(spriteNode)
            self.smallButtNodeCounter += 1
        }
     

        if let smallAsteroid2 = UIImage(named: "FlippedButt")?.withTintColor(.white) {
            
            let texture = SKTexture(image: smallAsteroid2)
            let spriteNode = SKSpriteNode(texture: texture)
            
            spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            spriteNode.size = CGSize(width: CGFloat(50.0), height: CGFloat(50.0))
            
            spriteNode.position = CGPoint(x: originalAsteroid.position.x - 20, y: originalAsteroid.position.y - 20)
            
            let velocity = Int.random(in: 3...6)
            
            spriteNode.physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size)
            spriteNode.physicsBody?.isDynamic = true
            spriteNode.physicsBody?.isDynamic = true
            spriteNode.physicsBody?.angularVelocity = CGFloat(integerLiteral: velocity)  // Ensure no initial angular velocity
            spriteNode.physicsBody?.categoryBitMask = smallAsteroidCategory
            spriteNode.physicsBody?.contactTestBitMask = missileCategory
            spriteNode.physicsBody?.affectedByGravity = false
            
            smallButtNode[smallButtNodeCounter] = spriteNode
            addChild(spriteNode)
            smallButtNodeCounter += 1
            
        }
        
     
        
        
    }
   
    func missileDidCollideWithSmallAsteroid(missile: SKSpriteNode, asteroid: SKSpriteNode) {

        asteroid.removeFromParent()
        missile.removeFromParent()
    }
    
    func generateButtons() {
        let leftArrowNode = RotateButton(systemName: "arrowtriangle.left.square.fill", anchorPoint: CGPoint(x: 0.5, y: 0.5), size: CGSize(width: CGFloat(30.0), height: CGFloat(30.0)), position: CGPoint(x: -312.5, y: -120), zPosition: 20, rotationDirection: K.left, spaceship: spaceship, name: K.leftArrowName)
            
            self.addChild(leftArrowNode)
        
            print(leftArrowNode)
            
        let rightArrowNode = RotateButton(systemName: "arrowtriangle.right.square.fill", anchorPoint: CGPoint(x: 0.5, y: 0.5), size: CGSize(width: CGFloat(30.0), height: CGFloat(30.0)), position: CGPoint(x: -258, y: -120), zPosition: 20, rotationDirection: K.right, spaceship: spaceship, name: K.rightArrowName)
            
            self.addChild(rightArrowNode)
            print(rightArrowNode)
        
        //UIImage(systemName: "arrowtriangle.left.square.fill")?.withTintColor(.white) {
//
//            let data = leftArrow.pngData()
//            let newImage = UIImage(data: data!)
//            let texture = SKTexture(image: newImage!)
//            leftArrowNode = SKSpriteNode(texture: texture)
//
//            leftArrowNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//            leftArrowNode.size = CGSize(width: CGFloat(30.0), height: CGFloat(30.0))
//            leftArrowNode.position = CGPoint(x: -312.5, y: -120)
        
        //}
//
//        if let rightArrow = UIImage(systemName: "arrowtriangle.right.square.fill")?.withTintColor(.white) {
//
//            let data = rightArrow.pngData()
//            let newImage = UIImage(data: data!)
//            let texture = SKTexture(image: newImage!)
//            rightArrowNode = SKSpriteNode(texture: texture)
//
//            rightArrowNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//            rightArrowNode.size = CGSize(width: CGFloat(30.0), height: CGFloat(30.0))
//            rightArrowNode.position = CGPoint(x: -258, y: -120)
//            rightArrowNode.zPosition = 20
//
//            self.addChild(rightArrowNode)
//
//        }
        
        
        if let thrust = UIImage(named: "thrust")?.withTintColor(.white) {
            
            let texture = SKTexture(image: thrust)
            thrustNode = SKSpriteNode(texture: texture)
            
            thrustNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            thrustNode.size = CGSize(width: CGFloat(35.0), height: CGFloat(35.0))
            thrustNode.position = CGPoint(x: 312.5, y: -120)
            thrustNode.zPosition = 20
            
            self.addChild(thrustNode)
            
        }

        if let trigger = UIImage(named: "Crosshair")?.withTintColor(.white) {
            
            let texture = SKTexture(image: trigger)
            triggerNode = SKSpriteNode(texture: texture)
            
            triggerNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            triggerNode.size = CGSize(width: CGFloat(50.0), height: CGFloat(50.0))
            triggerNode.position = CGPoint(x: 258, y: -120)
            triggerNode.zPosition = 20
            
            self.addChild(triggerNode)
            
        }


    }
    
}




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
    let imageName = "FlippedAss"
    var spaceship: SpaceshipNode!
    var rotating = false
    var thrusting = false
    var firing = false
    //var flame: SKSpriteNode!
    var velocity: CGVector!
    var missileDictionary: [Int: SKSpriteNode?] = [:]
    var whenMissileFired: Date!
    let maxSecondsForMissiles: Double = 1.25
    
    var leftArrowNode: RotateButton!
    var rightArrowNode: RotateButton!
    var thrustNode: SKSpriteNode!
    var triggerNode: SKSpriteNode!
    var largeAssNodesInAction: [Int: SKSpriteNode] = [:]
    var mediumAssNodesInAction: [Int: SKSpriteNode] = [:]
    var smallAssNodesInAction: [Int: SKSpriteNode] = [:]
    
    let assNodeMax: Int = 10
    let missileCategory: UInt32 = K.missileCategory
    let largeAssteroidCategory: UInt32 = K.largeAssteroidCategory
    let mediumAssteroidCategory: UInt32 = K.mediumAssteroidCategory
    let smallAssteroidCategory: UInt32 = K.smallAssteroidCategory
    var currentAssteroidCategory: UInt32 = K.largeAssteroidCategory
    
    var score: Int = 0 {
         didSet {
             scoreLabel.text = "Score: \(score)"
         }
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
       
        //self.addChild(generateSpaceShip()!)
        
        spaceship = SpaceshipNode(systemName: K.spaceshipAssetName)
        
        self.addChild(spaceship)
        
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
        
        for _ in 0...assNodeMax {
            generateAssteroids(K.largeAssteroidCategory)
        }
        
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
                            rotateTappedNode.stopRotation()
                    
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
                        rotateTappedNode.stopRotation()
                    
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
                    spaceship.activateThrust(thrusting: thrusting)
                        case .ended, .cancelled:
                            // Stop rotating when the long press ends or is cancelled
                    
                            print("thrust ended")
                            thrusting = false
                    spaceship.activateThrust(thrusting: thrusting)
                        default:
                            break
                        }
            } else if triggerNode == tappedNode {
                print("trigger pressed!")
                
                switch gestureRecognizer.state {
                        case .began:
                            firing = true
                            let missile = MissileNode(size: spaceship.size, position: spaceship.position, zRotation: spaceship.zRotation)
                            addChild(missile)
                            whenMissileFired = missile.fireMissile(missileCategory, largeAssteroidCategory, mediumAssteroidCategory, smallAssteroidCategory) // returns a Date data type
                    
                            if missileDictionary.isEmpty {
                                missileDictionary[1] = missile
                            } else {
                                missileDictionary[missileDictionary.keys.max()! + 1] = missile
                            }
                    
                            print(self.missileDictionary.keys.max()!)
                    
                        case .ended, .cancelled:
                            // Stop rotating when the long press ends or is cancelled
                            thrusting = false
                        default:
                            break
                        }
            }
        }
           
        }
    
    // TODO: - Move this handleFiring() method into SpaceshipNode class
    
//    func fireMissile() { // put into MissileNode class
//        
//        //missile = MissileNode()
//        //missile.fire()
//        
//        // Create a missile
//        let tempMissile = createMissile()! //MissileNode()
//        tempMissile.position = spaceship.position
//        addChild(tempMissile)
//
//        let angleInRadians = spaceship.zRotation
//        
//        let forceMagnitude: CGFloat = 2500.0
//        
//        let deltaX = forceMagnitude * cos(angleInRadians)
//        let deltaY = forceMagnitude * sin(angleInRadians)
//        
//        // Apply an upward force to the missile
//        
//        let force = CGVector(dx: deltaX, dy: deltaY)
//        
//        // Apply the force to the missile's physics body
//        tempMissile.physicsBody?.applyForce(force)
//        tempMissile.physicsBody?.categoryBitMask = missileCategory
//        tempMissile.physicsBody?.contactTestBitMask = asteroidCategory | mediumAsteroidCategory
//        //tempMissile.physicsBody?.contactTestBitMask = asteroidCategory
//        tempMissile.physicsBody?.affectedByGravity = false
//
//        whenMissileFired = Date()
//        
//        
//    //TODO: - create MissileNode class, add the following logic to handleLongPress()
//        
//        // can we add this to handleLongPress()
//        
//        // 1. triggerNode pressed
//        // 2. var missile = MissileNode()
//        // 3. missile.fire()
//        // 4. this immediately below \/
////        if missileDictionary.isEmpty {
////            missileDictionary[1] = tempMissile
////        } else {
////            missileDictionary[missileDictionary.keys.max()! + 1] = tempMissile
////        }
////        
//        print(self.missileDictionary.keys.max()!)
//        
//    }
    
    // TODO: - move this createMissile() method to MissileNode class
    
    func createMissile() -> SKSpriteNode? {
        
        if let missileImage = UIImage(systemName: K.missileAssetName)?.withTintColor(.white) {
            
            let data = missileImage.pngData()
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
    var mediumAssNodeCounter = 0
    var smallAssNodeCounter = 0
    
    
    override func update(_ currentTime: TimeInterval) {
       
        checkOutOfBounds(for: self.spaceship)
        
        var counter: Int = 1
        
        for _ in missileDictionary {
            checkOutOfBounds(for: self.missileDictionary[counter]!!)
            
            let removeAction = SKAction.sequence([
                        SKAction.wait(forDuration: maxSecondsForMissiles),
                        SKAction.removeFromParent()
                        
                    ])

            if let safeMissile = self.missileDictionary[counter] {
                safeMissile!.run(removeAction)
                
            }
            counter += 1
        }
        
        if !missileDictionary.isEmpty {
            
            let elapsedTime = Date().timeIntervalSince(whenMissileFired)
            
            if elapsedTime > maxSecondsForMissiles {
                
                print("inside elapsedTime if statement")
                self.missileDictionary.removeValue(forKey: self.missileDictionary.keys.max()!)
            }
        }
        
        counter = 0
        
        
        // TODO: - The below loop throws an exception. We are currently checking the dictionary for entries that have not been created yet
        
        for counter in 1...assNodeMax {
            //print("assNode: ", assNode)
            checkOutOfBounds(for: self.largeAssNodesInAction[counter]!)
        }
        
        
        
        for mediumAssNodeCounter in 0...self.mediumAssNodesInAction.count {
            
            if mediumAssNodesInAction[mediumAssNodeCounter] != nil {
                //print("mediumAssNode in update: ", mediumAssNode)
                checkOutOfBounds(for: self.mediumAssNodesInAction[mediumAssNodeCounter]!)
            }
        }
        
        
        for smallAssNodeCounter in 0...self.mediumAssNodesInAction.count {
            
            if smallAssNodesInAction[smallAssNodeCounter] != nil {
                //print("mediumAssNode in update: ", mediumAssNode)
                checkOutOfBounds(for: self.smallAssNodesInAction[smallAssNodeCounter]!)
            }
        }
        
        if thrusting == true {
            spaceship.childNode(withName: "flame")?.isHidden.toggle()
        }
        
        if thrusting == false {
            spaceship.childNode(withName: "flame")?.isHidden = true
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
    
    
  
    // TODO: - We want the below generateAssteroids() method to handle the creation of assteroids of all sizes
    
    /*
        we might call this method repeatedly from a loop elsewhere. That way, we can dedicate this method to just one purpose, which is to create a single assteroid of a specified size each time it's called. we were able to specify different sizes with a switch statement, see Assteroid class
     
        for medium assteroids: we'll need to call this method twice when a missile collides with a large assteroid, once for each medium assteroid being created. we'll need to pass into the initializer the mediumAssteroidCategory variable. From there we'll need to create an assteroid of a smaller size by adjusting the size: CGSize() during instantiation. we did this as mentioned before with a switch statement 
     
        
     
     */

    func generateAssteroids(_ currentAssteroidCategory: UInt32) {
        
        var currentAssteroid: Assteroid
        
        print("0b" + String(currentAssteroidCategory, radix: 2))
        
        switch currentAssteroidCategory {
            case K.largeAssteroidCategory:
                do {
                    let highestKey = self.largeAssNodesInAction.keys.max() ?? 0
                    let nextKey = highestKey + 1
                    
                    currentAssteroid = Assteroid(K.largeAssteroidCategory)
                    addChild(currentAssteroid)
                    
                    largeAssNodesInAction[nextKey] = currentAssteroid
                    
                    print("key \(nextKey): \(String(describing: largeAssNodesInAction[nextKey]))")
                }
            case K.mediumAssteroidCategory:
                do {
                    let highestKey = self.mediumAssNodesInAction.keys.max() ?? 0
                    let nextKey = highestKey + 1
                    
                    currentAssteroid = Assteroid(K.mediumAssteroidCategory)
                    addChild(currentAssteroid)
                    
                    mediumAssNodesInAction[nextKey] = currentAssteroid
                }
            case K.smallAssteroidCategory:
                do {
                    let highestKey = self.smallAssNodesInAction.keys.max() ?? 0
                    let nextKey = highestKey + 1
                    
                    currentAssteroid = Assteroid(K.smallAssteroidCategory)
                    addChild(currentAssteroid)
                    
                    smallAssNodesInAction[nextKey] = currentAssteroid
                }
            default:
                return
        }
            
            
            //print(largeAssNodesInAction)
            
//            if let ass = UIImage(named: "flippedAss")?.withTintColor(.white) {
//                
//                print(largeAssNodesInAction)
//                
//                let texture = SKTexture(image: ass)
//                let spriteNode = SKSpriteNode(texture: texture)
//                
//                spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//                spriteNode.size = CGSize(width: CGFloat(100.0), height: CGFloat(100.0))
//                
//                let randomNegX = Int.random(in: -426 ... -150)
//                let randomPosX = Int.random(in: 150...426)
//                let randomNegY = Int.random(in: -196 ... -75)
//                let randomPosY = Int.random(in: 75...196)
//                
//                let xCoordinate = [randomNegX, randomPosX]
//                let yCoordinate = [randomNegY, randomPosY]
//                
//                spriteNode.position = CGPoint(x: xCoordinate[Int.random(in: 0...1)], y: yCoordinate[Int.random(in: 0...1)])
//                
//                let velocity = Int.random(in: 1...3)
//                
//                spriteNode.physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size)
//                spriteNode.physicsBody?.isDynamic = true
//                spriteNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
//                spriteNode.physicsBody?.velocity = CGVector(dx: velocity, dy: velocity)  // Ensure no initial velocity
//                spriteNode.physicsBody?.angularVelocity = CGFloat(integerLiteral: velocity)  // Ensure no initial angular velocity
//                spriteNode.physicsBody?.categoryBitMask = largeAssteroidCategory
//                spriteNode.physicsBody?.contactTestBitMask = missileCategory
//                spriteNode.physicsBody?.affectedByGravity = false
//                
//                self.addChild(spriteNode)
//                self.largeAssNodesInAction[counter] = spriteNode
//                
//                
//                
//            }
            
            
        
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
          
        let collisionMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

                if collisionMask == (missileCategory | largeAssteroidCategory) {
                    if let collidedMissileNode = contact.bodyA.node as? SKSpriteNode, let collidedAssNode = contact.bodyB.node as? SKSpriteNode {
                    
                        missileDidCollideWithAsteroid(missile: collidedMissileNode, asteroid: collidedAssNode)
                    }
                } else if collisionMask == (missileCategory | mediumAssteroidCategory) {
                    // Handle collision between missile and medium asteroid
                    if let collidedMissileNode = contact.bodyA.node as? SKSpriteNode, let collidedAssNode = contact.bodyB.node as? SKSpriteNode {
                                           
                        missileDidCollideWithMediumAsteroid(missile: collidedMissileNode, asteroid: collidedAssNode)
                    }
                    
                } else if collisionMask == (missileCategory | smallAssteroidCategory) {
                    if let collidedMissileNode = contact.bodyA.node as? SKSpriteNode, let collidedAssNode = contact.bodyB.node as? SKSpriteNode {
                                           
                        missileDidCollideWithSmallAsteroid(missile: collidedMissileNode, asteroid: collidedAssNode)
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

  
        if let mediumAsteroid1 = UIImage(named: "FlippedAss")?.withTintColor(.white) {
            
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
            spriteNode.physicsBody?.categoryBitMask = mediumAssteroidCategory
            spriteNode.physicsBody?.contactTestBitMask = missileCategory
            spriteNode.physicsBody?.affectedByGravity = false
            
            mediumAssNodesInAction[self.mediumAssNodeCounter] = spriteNode
            print("mediumAssNodeCounter: ", mediumAssNodeCounter)
            print("mediumAssNode: ", mediumAssNodesInAction)
            addChild(spriteNode)
            self.mediumAssNodeCounter += 1
        }


        if let mediumAsteroid2 = UIImage(named: "FlippedAss")?.withTintColor(.white) {
            
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
            spriteNode.physicsBody?.categoryBitMask = mediumAssteroidCategory
            spriteNode.physicsBody?.contactTestBitMask = missileCategory
            spriteNode.physicsBody?.affectedByGravity = false
            
            mediumAssNodesInAction[mediumAssNodeCounter] = spriteNode
            addChild(spriteNode)
            mediumAssNodeCounter += 1
            
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

        
        if let smallAsteroid1 = UIImage(named: "FlippedAss")?.withTintColor(.white) {
            
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
            spriteNode.physicsBody?.categoryBitMask = smallAssteroidCategory
            spriteNode.physicsBody?.contactTestBitMask = missileCategory
            spriteNode.physicsBody?.affectedByGravity = false
            
            smallAssNodesInAction[self.smallAssNodeCounter] = spriteNode
//            print("mediumAssNodeCounter: ", mediumAssNodeCounter)
//            print("mediumAssNode: ", mediumAssNode)
            addChild(spriteNode)
            self.smallAssNodeCounter += 1
        }
     

        if let smallAsteroid2 = UIImage(named: "FlippedAss")?.withTintColor(.white) {
            
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
            spriteNode.physicsBody?.categoryBitMask = smallAssteroidCategory
            spriteNode.physicsBody?.contactTestBitMask = missileCategory
            spriteNode.physicsBody?.affectedByGravity = false
            
            smallAssNodesInAction[smallAssNodeCounter] = spriteNode
            addChild(spriteNode)
            smallAssNodeCounter += 1
            
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



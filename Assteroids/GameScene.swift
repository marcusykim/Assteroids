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
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}

/*
 
 This Swift code defines a class named `GameScene` that is a subclass of `SKScene` (SpriteKit scene). It appears to be part of a game development project, possibly involving asteroids (judging from the project name "Assteroids"). Let's go through the code line by line:

 ```swift
 //  GameScene.swift
 //  Assteroids
 //  Created by Marcus Y. Kim on 11/8/23.
 ```
 - These lines are comments providing information about the file, including its name, the project it belongs to (Assteroids), and the creation date along with the author's name.

 ```swift
 import SpriteKit
 import GameplayKit
 ```
 - Imports the SpriteKit and GameplayKit frameworks, which are commonly used for game development in Swift.

 ```swift
 class GameScene: SKScene {
 ```
 - Defines a class named `GameScene` that inherits from `SKScene` (a SpriteKit scene).

 ```swift
 var entities = [GKEntity]()
 var graphs = [String : GKGraph]()
 ```
 - Declares two arrays: `entities` to store GameplayKit entities, and `graphs` to store GameplayKit graphs.

 ```swift
 private var lastUpdateTime: TimeInterval = 0
 private var label: SKLabelNode?
 private var spinnyNode: SKShapeNode?
 ```
 - Declares private variables to store the last update time, a label node, and a shape node (presumably for some graphical effect).

 ```swift
 override func sceneDidLoad() {
 ```
 - Overrides the `sceneDidLoad` method, which is called when the scene is loaded.

 ```swift
     self.lastUpdateTime = 0
 ```
 - Initializes the `lastUpdateTime` variable to 0.

 ```swift
     self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
     if let label = self.label {
         label.alpha = 0.0
         label.run(SKAction.fadeIn(withDuration: 2.0))
     }
 ```
 - Retrieves a label node named "helloLabel" from the scene, sets its alpha to 0, and fades it in over 2 seconds.

 ```swift
     let w = (self.size.width + self.size.height) * 0.05
     self.spinnyNode = SKShapeNode(rectOf: CGSize(width: w, height: w), cornerRadius: w * 0.3)
 ```
 - Calculates the size of a shape node (`spinnyNode`) based on the scene size and creates a rectangular shape node with rounded corners.

 ```swift
     if let spinnyNode = self.spinnyNode {
         spinnyNode.lineWidth = 2.5
         spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
         spinnyNode.run(SKAction.sequence([
             SKAction.wait(forDuration: 0.5),
             SKAction.fadeOut(withDuration: 0.5),
             SKAction.removeFromParent()
         ]))
     }
 ```
 - Configures the shape node (`spinnyNode`) by setting its line width, making it rotate continuously, and applying a sequence of actions to wait, fade out, and remove from the parent.

 The rest of the code defines methods for handling touches (`touchDown`, `touchMoved`, `touchUp`, `touchesBegan`, `touchesMoved`, `touchesEnded`, `touchesCancelled`) and the `update` method, which is called before each frame is rendered. The `update` method calculates the time since the last update and updates the entities accordingly.
 */

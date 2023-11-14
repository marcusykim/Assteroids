//
//  GameViewController.swift
//  Assteroids
//
//  Created by Marcus Y. Kim on 11/8/23.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

/*
 
 Sure, let's go through the code line by line:

 ```swift
 import UIKit
 import SpriteKit
 import GameplayKit
 ```
 - Imports the necessary frameworks: UIKit for the basic iOS functionality, SpriteKit for game development, and GameplayKit for game-related functionality.

 ```swift
 class GameViewController: UIViewController {
 ```
 - Defines a class named `GameViewController` that is a subclass of `UIViewController`, indicating that this class manages a view hierarchy.

 ```swift
     override func viewDidLoad() {
         super.viewDidLoad()
 ```
 - Overrides the `viewDidLoad` method, which is called after the view controller's view has been loaded into memory.

 ```swift
         // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
         // including entities and graphs.
         if let scene = GKScene(fileNamed: "GameScene") {
 ```
 - Attempts to load a `GKScene` from a file named "GameScene.sks" (SpriteKit Scene file), which contains gameplay-related content like entities and graphs.

 ```swift
             // Get the SKScene from the loaded GKScene
             if let sceneNode = scene.rootNode as! GameScene? {
 ```
 - Tries to retrieve the root node of the loaded `GKScene` and cast it as a `GameScene` (presumably a subclass of `SKScene`).

 ```swift
                 // Copy gameplay related content over to the scene
                 sceneNode.entities = scene.entities
                 sceneNode.graphs = scene.graphs
 ```
 - Copies the entities and graphs from the loaded `GKScene` to the `GameScene` instance.

 ```swift
                 // Set the scale mode to scale to fit the window
                 sceneNode.scaleMode = .aspectFill
 ```
 - Sets the scale mode of the `GameScene` to `.aspectFill`, which means it will scale to fill the window while maintaining the aspect ratio.

 ```swift
                 // Present the scene
                 if let view = self.view as! SKView? {
                     view.presentScene(sceneNode)
                     
                     view.ignoresSiblingOrder = true
                     view.showsFPS = true
                     view.showsNodeCount = true
                 }
 ```
 - Presents the `GameScene` in the `SKView` associated with the view controller. Additionally, sets some properties of the `SKView` such as ignoring sibling order, showing FPS (frames per second), and showing node count (number of nodes in the scene).

 ```swift
             }
         }
     }
 ```

 ```swift
     override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
         if UIDevice.current.userInterfaceIdiom == .phone {
             return .allButUpsideDown
         } else {
             return .all
         }
     }
 ```
 - Overrides the `supportedInterfaceOrientations` property to specify the supported interface orientations. It returns `.allButUpsideDown` for iPhones and `.all` for other devices.

 ```swift
     override var prefersStatusBarHidden: Bool {
         return true
     }
 ```
 - Overrides the `prefersStatusBarHidden` property to specify whether the status bar should be hidden. It returns `true`, indicating that the status bar should be hidden.
 */

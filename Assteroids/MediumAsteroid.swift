//
//  MediumAsteroid.swift
//  Assteroids
//
//  Created by Marcus Y. Kim on 1/23/24.
//

import SpriteKit
import GameplayKit

// Step 1: Define Smaller Asteroid Class
class SmallerAsteroid: SKSpriteNode {
    // Your implementation for smaller asteroids
    
    func splitAsteroid(originalAsteroid: SKSpriteNode) {
        // Remove the original asteroid from the scene
        originalAsteroid.removeFromParent()

        // Create smaller asteroids
        let smallerAsteroid1 = SmallerAsteroid(texture: SKTexture(imageNamed: "smallerAsteroidTexture"))
        let smallerAsteroid2 = SmallerAsteroid(texture: SKTexture(imageNamed: "smallerAsteroidTexture"))

        // Set positions relative to the original asteroid
        smallerAsteroid1.position = CGPoint(x: originalAsteroid.position.x + 20, y: originalAsteroid.position.y + 20)
        smallerAsteroid2.position = CGPoint(x: originalAsteroid.position.x - 20, y: originalAsteroid.position.y - 20)

        // Add smaller asteroids to the scene
        addChild(smallerAsteroid1)
        addChild(smallerAsteroid2)
    }

    // Step 3: Handle Missile Collisions (Example)
    func missileDidCollideWithAsteroid(missile: SKSpriteNode, asteroid: SKSpriteNode) {
        // Your collision logic...

        // Call the function to split the asteroid
        splitAsteroid(originalAsteroid: asteroid)

        // Remove the missile from the scene
        missile.removeFromParent()
    }
}

// Step 2: Create a Function to Split Asteroids


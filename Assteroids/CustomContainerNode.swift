//
//  CustomContainerNode.swift
//  Assteroids
//
//  Created by Marcus Y. Kim on 1/23/24.
//

import SpriteKit
import GameplayKit

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

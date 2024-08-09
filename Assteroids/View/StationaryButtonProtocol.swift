//
//  Button.swift
//  Assteroids
//
//  Created by Marcus Kim on 6/25/24.
//

import Foundation
import SpriteKit

protocol StationaryButtonProtocol: SKSpriteNode {
    
    var asset: UIImage {  //UIImage(systemName: ".name") // UIImage(named: "asset name")
        get
        set
    }
    
    var texture: SKTexture { // self.texture = texture
        get
        set
    }
    
    var anchorPoint: CGPoint {
        get
        set
    }
    
    var size: CGSize {
        get
        set
    }
    
    var position: CGPoint {
        get
        set
    }
    
    var zPosition: Int {
        get
        set
    }
    
    init(systemName: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: CGFloat)
    init(named: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: CGFloat)
    // self.asset = asset
    
    // anchorPoint = anchorPoint
    
    func withTintColor() -> UIImage
    
}


/*
 
 stationary button protocol has init methods for size, position, anchorpoint, image, etc. all necessary for buttons
 
 class Rotate: StationaryButtonProtocol {
 
    //required properties
 
 
    init(systemName: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: CGFloat) {
        // initialization
    }
    init(named: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: CGFloat) {
        // initialization
    }
 
    init(rotationDirection: String, systemName: String, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: CGFloat) {
        // initialization
    }
 
 
 }
 
 */

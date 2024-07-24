//
//  Button.swift
//  Assteroids
//
//  Created by Marcus Kim on 6/25/24.
//

import Foundation
import SpriteKit

protocol StationaryButtonProtocol: SKSpriteNode {
    
    var asset: UIImage {
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
    
    init(asset: UIImage, texture: SKTexture, anchorPoint: CGPoint, size: CGSize, position: CGPoint, zPosition: Int )
    
    // self.asset = asset
    
    // anchorPoint = anchorPoint
    
    func withTintColor() -> UIImage
    
}

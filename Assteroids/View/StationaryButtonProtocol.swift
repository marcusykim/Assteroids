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
    
    /*
     
     class StationaryButton: StationaryButtonProtocol {
     
     
     
     
     }
     
     */
     
     */
    
    func withTintColor() -> UIImage
    
}

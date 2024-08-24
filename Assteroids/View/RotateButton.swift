import Foundation
import SpriteKit



class RotateButton: SKSpriteNode, StationaryButtonProtocol {
    
    var rotationDirection: String?
    var spaceship: SKSpriteNode

    // Implement both initializers with default values for `rotationDirection`
    required init(systemName: String, anchorPoint: CGPoint, size: CGSize = CGSize(width: 50, height: 50), position: CGPoint, zPosition: CGFloat = 0, rotationDirection: String, spaceship: SKSpriteNode) {
        self.rotationDirection = rotationDirection
       // self.asset = UIImage(systemName: systemName)?.withTintColor(.white) ?? UIImage()
        self.spaceship = spaceship
        //self.size = size
        var asset: UIImage {
            
            var newImage = UIImage()
            
            if let safeAsset = UIImage(systemName: systemName)?.withTintColor(.white) {
                let data = safeAsset.pngData()
                newImage = UIImage(data: data!)!
                
            }
            
            return newImage
        }
        
        let texture = SKTexture(image: asset)
        super.init(texture: texture, color: .white, size: size)
        self.anchorPoint = anchorPoint
        self.position = position
        self.zPosition = zPosition
        
    }

    required init(named: String, anchorPoint: CGPoint, size: CGSize = CGSize(width: 50, height: 50), position: CGPoint, zPosition: CGFloat = 0, rotationDirection: String, spaceship: SKSpriteNode) {
        self.rotationDirection = rotationDirection
        
        self.spaceship = spaceship
        //self.size = size
        var asset: UIImage {
            
            var newImage = UIImage()
            
            if let safeAsset = UIImage(named: named)?.withTintColor(.white) {
                let data = safeAsset.pngData()
                newImage = UIImage(data: data!)!
                
            }
            
            return newImage
        }
        
        let texture = SKTexture(image: asset)
        super.init(texture: texture, color: .white, size: size)
        self.anchorPoint = anchorPoint
        self.position = position
        self.zPosition = zPosition
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //TODO: - Declare `var rotating: Bool` in SpaceShip class so that the rotate button can query the spaceship to see if it's rotating
    // if we are adding and removing rotation animation from the spaceship, we need to declare or somehow pass a reference to a "global" aka public spaceship object that we can add an animation to (or remove from)
    
    
     func rotateSpaceship() {
     
        if rotationDirection == "left" {
            let rotateAction = SKAction.rotate(byAngle: CGFloat.pi, duration: 1.0)
            let repeatAction = SKAction.repeatForever(rotateAction)
            spaceship.run(repeatAction, withKey: "rotateAction")
        } else if rotationDirection == "right" {
            let rotateAction = SKAction.rotate(byAngle: -CGFloat.pi, duration: 1.0)
            let repeatAction = SKAction.repeatForever(rotateAction)
            spaceship.run(repeatAction, withKey: "rotateAction")
        }
     
     }
}

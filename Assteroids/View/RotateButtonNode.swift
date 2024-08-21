import Foundation
import SpriteKit



class RotateButton: SKSpriteNode, StationaryButtonProtocol {
    func withTintColor(_ color: UIColor) -> UIImage {
        <#code#>
    }
    
    var asset: UIImage {
        didSet {
            self.texture = SKTexture(image: asset)
        }
    }
    var rotationDirection: String?
    var spaceship: SKSpriteNode!


    // Implement both initializers with default values for `rotationDirection`
    required init(systemName: String, anchorPoint: CGPoint, size: CGSize = CGSize(width: 50, height: 50), position: CGPoint = CGPoint.zero, zPosition: CGFloat = 0, rotationDirection: String? = nil, spaceship: SKSpriteNode) { //"left" or "right"
        self.rotationDirection = rotationDirection
        self.asset = UIImage(systemName: systemName) ?? UIImage()
        let texture = SKTexture(image: self.asset)
        super.init(texture: texture, color: .clear, size: size)
        self.anchorPoint = anchorPoint
        self.position = position
        self.zPosition = zPosition
        self.spaceship = spaceship
    }

    required init(named: String, anchorPoint: CGPoint, size: CGSize = CGSize(width: 50, height: 50), position: CGPoint = CGPoint.zero, zPosition: CGFloat = 0, rotationDirection: String? = nil, spaceship: SKSpriteNode) {
        self.rotationDirection = rotationDirection
        self.asset = UIImage(named: named) ?? UIImage()
        let texture = SKTexture(image: self.asset)
        super.init(texture: texture, color: .clear, size: size)
        self.anchorPoint = anchorPoint
        self.position = position
        self.zPosition = zPosition
        self.spaceship = spaceship
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

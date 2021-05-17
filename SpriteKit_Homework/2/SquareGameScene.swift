import UIKit
import SpriteKit
import GameplayKit

struct PhysicsCategory {
  static let none      : UInt32 = 0
  static let all       : UInt32 = UInt32.max
  static let square   : UInt32 = 0b1
  static let hill: UInt32 = 0b10
  static let circle: UInt32 = 3
}

class SquareGameScene: SKScene {
    var scoreCounter = 0
    var counter = 5.0
    var timer = Timer()
    let player = SKSpriteNode(imageNamed: "meatBoy")
    let ground = SKSpriteNode(imageNamed: "ground")
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        startTimer()

        run(SKAction.repeatForever(
              SKAction.sequence([
                SKAction.run(createHill),
                SKAction.wait(forDuration: counter)
                ])
            ))
                
        backgroundColor = SKColor.white
        player.size = CGSize(width: 30, height: 30)
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.square
        player.physicsBody?.contactTestBitMask = PhysicsCategory.hill
        player.physicsBody?.collisionBitMask = PhysicsCategory.none
        player.physicsBody?.usesPreciseCollisionDetection = true
        ground.size = CGSize(width: size.width, height: size.height - player.size.height)
        ground.position = CGPoint(x: size.width / 2, y: 0)
        addChild(player)
        addChild(ground)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        jump()
        rotate()
    }
}

extension SquareGameScene {
 
    func random() -> CGFloat {
      return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

    func random(min: CGFloat, max: CGFloat) -> CGFloat {
      return random() * (max - min) + min
    }

    func createHill() {
        let hill = SKSpriteNode(imageNamed: "hill")
        hill.size = CGSize(width: random(min: 20, max: 60), height: random(min: 10, max: 60))
        hill.anchorPoint = CGPoint(x: 0, y: 0)
        hill.position = CGPoint(x: size.width + hill.size.width, y: size.height / 2 - player.size.height + 15)
        hill.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 0), to: CGPoint(x: hill.frame.width/2, y: hill.frame.height))
        hill.physicsBody?.isDynamic = true
        hill.physicsBody?.categoryBitMask = PhysicsCategory.hill
        hill.physicsBody?.contactTestBitMask = PhysicsCategory.square
        hill.physicsBody?.collisionBitMask = PhysicsCategory.none
        addChild(hill)
        let moveLeft = SKAction.move(to: CGPoint(x: -hill.size.width, y: hill.position.y), duration: counter)
        let moveDone = SKAction.removeFromParent()
        hill.run(SKAction.sequence([moveLeft, moveDone]))
    }
    
    func jump() {
        let up = SKAction.move(to: CGPoint(x: size.width * 0.1, y: size.height * 0.5 + 100), duration: 0.7)
        let down = SKAction.move(to: CGPoint(x: size.width * 0.1, y: size.height * 0.5), duration: 0.7)
        player.run(SKAction.sequence([up, down]))
    }
    
    func rotate() {
        let rotate = SKAction.rotate(byAngle: 360, duration: 1.4)
        player.run(rotate)
        
    }
    
    func startTimer() {
        timer.invalidate()
        //раз в секунду должно происходить что-то, прописанное в timerAction
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    @objc func timerAction() {
        counter = counter - 0.1
    }
}

//MARK: Ext. SKPhysicsContactDelegate
extension SquareGameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {    
        let scene = GameOverScene2(size: size)
        scene.scoreLabel.text = "\(scoreCounter)"
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(scene, transition: reveal)
    }
}

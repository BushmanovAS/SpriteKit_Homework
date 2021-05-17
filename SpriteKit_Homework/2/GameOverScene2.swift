import Foundation
import SpriteKit

class GameOverScene2: SKScene {
    let label = SKLabelNode(text: "GAME OVER! \n Your score:")
    let scoreLabel = SKLabelNode(text: "0")
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        label.numberOfLines = 0
        label.horizontalAlignmentMode = .center
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 50)        
        addChild(label)
        addChild(scoreLabel)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let scene = SquareGameScene(size: size)
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(scene, transition: reveal)
    }
    
}

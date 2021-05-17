import UIKit
import SpriteKit
import GameplayKit

class SquareViewConroller: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = SquareGameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.presentScene(scene)
    }
}

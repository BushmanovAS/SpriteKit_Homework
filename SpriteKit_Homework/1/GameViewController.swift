//
//  GameViewController.swift
//  SpriteKit_Homework
//
//  Created by Антон Бушманов on 07.03.2021.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.presentScene(scene)

    }

}

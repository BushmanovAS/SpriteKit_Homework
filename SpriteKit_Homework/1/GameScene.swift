//
//  GameScene.swift
//  SpriteKit_Homework
//
//  Created by Антон Бушманов on 07.03.2021.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    //переменная для работы таймера
    var stepCounter = 0
    var mainCounter = 0
    var timer = Timer()
   
    let player = SKSpriteNode(imageNamed: "green")
    let enemy = SKSpriteNode(imageNamed: "red")
    let start = SKLabelNode(text: "START")
    let scoreLabel = SKLabelNode(text: "0")

    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.white
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        scoreLabel.fontColor = UIColor.blue
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - scoreLabel.frame.height * 3)
        
        start.position = CGPoint(x: size.width / 2, y: size.height / 2)
        start.fontColor = UIColor.red
        
        
        nodeCreate(node: player, position: CGPoint(x: size.width - 15, y: size.height - 15))
//        player.scale(to: CGSize(width: 30, height: 30))
//        player.position = CGPoint(x: size.width - 15, y: size.height - 15)
        nodeCreate(node: enemy, position: CGPoint(x: 15, y: 15))
//        enemy.scale(to: CGSize(width: 30, height: 30))
//        enemy.position = CGPoint(x: 15, y: 15)
    
        addChild(player)
        addChild(enemy)
        addChild(start)
        addChild(scoreLabel)
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if start.isHidden == false {
            start.isHidden = true
            startTimer()
            moveEnemy()
            enemy.run(SKAction.repeatForever(SKAction.scale(by: 1.1, duration: 1)))
            
        }
        
        move(node: player, to: touches.first!.location(in: self), speed: 300)
        
    }
    
//    override func didEvaluateActions() {
//        super.didEvaluateActions()
//        if enemy.frame.intersects(player.frame) {
//            stopTimer()
//            let scene = GameOverScene(size: size)
//            scene.scoreLabel.text = "\(mainCounter)"
//            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
//            view?.presentScene(scene, transition: reveal)
//        }
//    }
    

    
}

//MARK: func extension
extension GameScene {
    
    //функция задания начальных параметров кругов игрока и противника
    func nodeCreate(node: SKSpriteNode, position: CGPoint) -> SKSpriteNode {
        
        node.scale(to: CGSize(width: 30, height: 30))
        node.position = position
        node.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.categoryBitMask = PhysicsCategory.circle
        node.physicsBody?.contactTestBitMask = PhysicsCategory.circle
        node.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        return node
    }
    
    func moveEnemy() {
        move(node: enemy, to: player.position, speed: 80, completition: moveEnemy)
    }
    
    
    //функция движения в точку с заданной скоростью
    func move(node: SKNode, to: CGPoint, speed: CGFloat, completition: (() -> Void)? = nil) {
        let x = node.position.x
        let y = node.position.y
        let distance = sqrt((x - to.x) * (x - to.x) + (y - to.y) * (y - to.y))
        let duration = TimeInterval(distance / speed)
        
        //MARK: Вопрос 1
        //Чтобы enemy менял траекторию каждую секунду, я заменил duration на 1, но теперь круги двигаются не равномерно, в одну сторону быстрее, в другую медленнее.
        let move = SKAction.move(to: to, duration: 1)
        node.run(move, completion: completition ?? { })
    }
    
    func startTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    @objc func timerAction() {
        
        stepCounter = stepCounter + 1
        mainCounter += stepCounter
        scoreLabel.text = "\(mainCounter)"
    }
    
}

//MARK: physycs extension
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        stopTimer()
        let scene = GameOverScene(size: size)
        scene.scoreLabel.text = "\(mainCounter)"
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(scene, transition: reveal)
    }
    
}

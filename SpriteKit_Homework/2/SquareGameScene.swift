//
//  SquareGameScene.swift
//  SpriteKit_Homework
//
//  Created by Антон Бушманов on 09.03.2021.
//

import UIKit
import SpriteKit
import GameplayKit

//структура категорий объектов при столкновении
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
        //запуск бесконечного создания гор
        run(SKAction.repeatForever(
              SKAction.sequence([
                SKAction.run(createHill),
                //MARK: Вопрос 1
                //Как обновлять counter в этом месте ? Чтобы горы не только быстрее бегали, но и стали чаще создаваться
                SKAction.wait(forDuration: counter)
                ])
            ))
        
        
        backgroundColor = SKColor.white
        
        //задание размера квадрата
        player.size = CGSize(width: 30, height: 30)
        //задание позиции квадрата на экране
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        //добавление квадрату физического тела
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.square
        player.physicsBody?.contactTestBitMask = PhysicsCategory.hill
        player.physicsBody?.collisionBitMask = PhysicsCategory.none
        //свойство для более точного рассчета столкновений с горой
        player.physicsBody?.usesPreciseCollisionDetection = true
        
        
        ground.size = CGSize(width: size.width, height: size.height - player.size.height)
        ground.position = CGPoint(x: size.width / 2, y: 0)
        //ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        
        addChild(player)
        addChild(ground)
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        
        jump()
        rotate()
        
    }
}



//MARK: func extension
// вспомогательные функции
extension SquareGameScene {
 
    //MARK: Вопрос 2
    //как вообще работают данные функции рандома? и почему компилятор не ругается на 2 функции с одинаковым названием ?
    func random() -> CGFloat {
      return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

    func random(min: CGFloat, max: CGFloat) -> CGFloat {
      return random() * (max - min) + min
    }
    
    
    //функция создания гор
    func createHill() {
        
        //создание самой горы
        let hill = SKSpriteNode(imageNamed: "hill")
        //размеры гор будут рандомные
        hill.size = CGSize(width: random(min: 20, max: 60), height: random(min: 10, max: 60))
        //смещаем точку вниз, чтобы прижать гору к земле
        hill.anchorPoint = CGPoint(x: 0, y: 0)
        //расположение горы за экраном, чтобы создать эффект бега квадрата
        hill.position = CGPoint(x: size.width + hill.size.width, y: size.height / 2 - player.size.height + 15)
        
        //задание физики для горы
        //MARK: Вопрос 3
        //Почему то квадрат врезается сильно заранее в гору, я думаю что из за этого задания "тела", но не понимаю почему так. Можно ли как то отобразить на экране рамки физического тела объекта ?
        //задание физического тела по картинке горы
        //hill.physicsBody = SKPhysicsBody(texture: hill.texture!, size: hill.texture!.size())
        
        //поэтому я задал ему грань с передней стороны горы, она вроде работает
        hill.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 0), to: CGPoint(x: hill.frame.width/2, y: hill.frame.height))
        
        //строчка о том что горы двигаются без управления физ. движком
        hill.physicsBody?.isDynamic = true
        //
        hill.physicsBody?.categoryBitMask = PhysicsCategory.hill
        //показывает при столкновении с чем должно происходить уведомление
        hill.physicsBody?.contactTestBitMask = PhysicsCategory.square
        //показывает от чего должны отскакивать горы
        hill.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        
        
        
        
        //добавление горы в сцену
        addChild(hill)
        //движение горы влево
        let moveLeft = SKAction.move(to: CGPoint(x: -hill.size.width, y: hill.position.y), duration: counter)
        //удалние горы по завершению движения
        let moveDone = SKAction.removeFromParent()
        //запуск действий по очереди
        hill.run(SKAction.sequence([moveLeft, moveDone]))
        
    }
    
    //функция прыжка квадрата
    func jump() {
        
        let up = SKAction.move(to: CGPoint(x: size.width * 0.1, y: size.height * 0.5 + 100), duration: 0.7)
        let down = SKAction.move(to: CGPoint(x: size.width * 0.1, y: size.height * 0.5), duration: 0.7)
        player.run(SKAction.sequence([up, down]))
    }
    
    //функция вращения квадрата
    func rotate() {
        //MARK: Вопрос 4
        // разве квадрат не должен поворачиваться на 360 градусов в течениии 1.4 секунды ? почему он как вентилятор ?)
        let rotate = SKAction.rotate(byAngle: 360, duration: 1.4)
        player.run(rotate)
        
    }
    
//    func playerDidCollideWithHill(player: SKSpriteNode, hill: SKSpriteNode) {
//      print("Hit")
//      projectile.removeFromParent()
//      monster.removeFromParent()
//    }
    
    //функции работы с таймером
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

//MARK: physics extension

extension SquareGameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
    
        let scene = GameOverScene2(size: size)
        scene.scoreLabel.text = "\(scoreCounter)"
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(scene, transition: reveal)

    
    }
}

//
//  GameSceneCamera.swift
//  TotemMaster
//
//  Created by Danny Peng on 7/28/16.
//  Copyright © 2016 Danny Peng. All rights reserved.
//

import SpriteKit
import UIKit

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let Player: UInt32 = 0b1
    static let Trap: UInt32 = 0b10
    static let Totem: UInt32 = 0b100
    static let Part: UInt32 = 0b1000
}

class GameSceneCamera : SKScene, Scene, SKPhysicsContactDelegate, TotemDelegate {
    
    var floor1: SKSpriteNode!
    var floor2: SKSpriteNode!
    var lifeBarFront: SKSpriteNode!
    
    var myCamera: SKCameraNode!
    var scoreCount: SKLabelNode!
    
    var trapNode: SKNode!
    var trapDictionary = [Totem: Trap]()
    var disarm: CGFloat = 0.0
    var trap:Trap?
    
    var reload = false
    var controller : Controller!
    var gamepro: GameProtocol!
    var terminateScene = false
    
    var makingFloor: [SKNode] = []
    var floorWidth: CGFloat = 568
    
    var nextTrap: Double = 0.0
    var nextBanana: TimeInterval = 0
    let cameraspeed: CGFloat = 2.5
    let cameraFactor: CGFloat = 75.0
    var gameDistance:CGFloat = 0
    var accelerateGame:CGFloat = 100
    var gameOffset: CGFloat = 1000
    
    static let totalTimeRound = 60
    var timeCount: SKLabelNode!
    var gameOverTime: TimeInterval = 0
    var currentTime = 0
    
    var totemMaster: [Totem] = []
    var masterDan = Player()
    //var sky: SkyTimer!
    var firedBanana = false
    
    //var pauseButton = ToggleButton(selectedName: "PauseButton", unselectedName: "ResumeButton")
    
    
    
    var characterY: CGFloat = 1 {
        didSet {
            if characterY > 2 {
                characterY = 2
            }
            else if characterY < 0 {
                characterY = 0
            }
        }
    }
    var characterX: CGFloat = 2
    
    func setController(_ controller : GameProtocol) {
        self.gamepro = controller
    }
    
    
    override func didMove(to view: SKView) {
        
        gamepro.setGameDistance(dis: 0)
        
        floor1 = self.childNode(withName: "floor1") as! SKSpriteNode
        floor2 = self.childNode(withName: "floor2") as! SKSpriteNode
        
        scoreCount = self.childNode(withName: "//scoreCount") as! SKLabelNode
        
        lifeBarFront = self.childNode(withName: "//lifeBarFront") as! SKSpriteNode
        
        timeCount = self.childNode(withName: "//timeCount") as! SKLabelNode
        
        
        let now = NSDate().timeIntervalSince1970
        gameOverTime = now + Double(GameSceneCamera.totalTimeRound)
        //updateTime()
        timeCount.text = String(Int(gameDistance/60))
        
        updateScore(bonus: 0)
        
        
        trapNode = SKNode()
        addChild(trapNode)
        trapNode.position.y = scene!.frame.height/2
        trapNode.zPosition = 25
        trapNode.position.x = 0
        
        makingFloor = [floor1,floor2]
        
        myCamera = self.childNode(withName: "camera") as! SKCameraNode
        camera = myCamera
        
//        myCamera.addChild(pauseButton)
//        pauseButton.zPosition = 8
//        pauseButton.position.x = 90
//        pauseButton.position.y = 130
//        pauseButton.setScale(0.8)
 //       pauseButton.selectedHandler = {
            //TODO: Pause Game Here
//            print("should be pausing game...")
//            let wait = SKAction.wait(forDuration: 0.05)
//            let pause = SKAction.run({
//                self.scene!.isPaused = true
//
//            })
//            let sequence = SKAction.sequence([wait, pause])
//            self.run(sequence)
 //       }
//        pauseButton.unselectedHandler = {
            //TODO: Resume Game Here
//            print("should be resuming game...")
//            self.scene!.isPaused = false
//        }
        
        
        
        var skies = [String]()
        for i in 1...10 {
            skies.append("Sky\(i)")
        }
//        sky = SkyTimer(textures: skies)
//        sky.position.x = 0
//        sky.position.y = 0
//        myCamera.addChild(sky)
//        
//        
//        sky.startFade()
        
        
        
        physicsWorld.contactDelegate = self
        var totemy: CGFloat = (-scene!.size.height/3) - 10  //-116
        let totemfront = createsTotem(ypos: totemy)
        totemy+=scene!.size.height/3 //106
        let totemcenter = createsTotem(ypos: totemy)
        totemy+=scene!.size.height/3 //106
        let totemback = createsTotem(ypos: totemy)
        
        
        totemMaster = [totemfront, totemcenter, totemback]
        
        self.addChild(masterDan)
        masterDan.position.x = frame.midX
        masterDan.position.y = frame.midY
        masterDan.zPosition = 50
        masterDan.anchorPoint.x = 0.1
        masterDan.anchorPoint.y = 0.1
        masterDan.setScale(0.9)
        
        //Handle Tap Gestures with the use of UIKit
        
        let fireBanana = UITapGestureRecognizer(target: self, action: #selector(GameSceneCamera.onTap(_:)))
//        //shit here ^ presses began
        
        //Handles Swipe Gestures with the use of UIKit
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GameSceneCamera.onSwipe(_:)))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(GameSceneCamera.onSwipe(_:)))
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(GameSceneCamera.onSwipe(_:)))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(GameSceneCamera.onSwipe(_:)))
        
        swipeLeft.direction = .left
        swipeRight.direction = .right
        swipeUp.direction = .up
        swipeDown.direction = .down
        
        view.addGestureRecognizer(swipeRight)
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeUp)
        view.addGestureRecognizer(swipeDown)
        
        view.addGestureRecognizer(fireBanana)
    }
    
//     func updateTime() -> Bool{
//     let now = NSDate().timeIntervalSince1970
//     let temp = Int(gameOverTime - now)
//     if temp != self.currentTime {
//     timeCount.text = String(temp)
//     self.currentTime = temp
//     }
//     return self.currentTime == 0
//     }
    
    
    func createsTotem(ypos: CGFloat) -> Totem {
        let totem = Totem()
        
        myCamera.addChild(totem)
        
        totem.position.x = -scene!.size.width/3
        totem.position.y = ypos
        totem.zPosition = 50
        totem.anchorPoint.x = 0.5
        totem.anchorPoint.y = 0.5
        totem.setScale(0.8)
        totem.delegate = self
        return totem
    }
    
    func onTap(_ gesture: UITapGestureRecognizer) {
        fireBanana()
    }
    
    
    func getTotemAtPlayer() -> Totem {
        return self.totemMaster[Int(characterY)]
    }
    
    func fireBanana() {
        
        var offset: CGFloat = frame.width
        var removeTrapAction: SKAction?
        if  gamepro.getScore() > 0 {
            let totem = getTotemAtPlayer()
            if let trap = trapDictionary[totem] {
                if trap.position.x < masterDan.position.x {
                    removeTrapAction = SKAction.run({
                        self.removeTrap(t: trap)
                    })
                    offset = masterDan.position.x - trap.position.x
                }
            }
            let bananagun = BananaShot()
            self.addChild(bananagun)
            bananagun.position = masterDan.position
            bananagun.zPosition = masterDan.zPosition - 0.1
            let moveBanana = SKAction.moveBy(x: -offset, y: 0, duration: Double(offset/frame.width) * 0.5)
            firedBanana = true
            updateScore(bonus: 1)
            
            
            let placateBoss = SKAction.run({
                totem.placate()
            })
            //decide whether or not to placate boss or remove the trap
            
            let removeBanana = SKAction.removeFromParent()
            
            let sequence = SKAction.sequence([moveBanana,removeTrapAction ?? placateBoss, removeBanana])
            
            bananagun.run(sequence)
        }
    }
    
    
    func onSwipe(_ gesture: UISwipeGestureRecognizer) {
        characterX = 0
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.left:
            print("Move Left")
            characterX = -1
        case UISwipeGestureRecognizerDirection.right:
            print("Move Right")
            characterX = 1
        case UISwipeGestureRecognizerDirection.up:
            print("Move Up")
            characterY += 1
        case UISwipeGestureRecognizerDirection.down:
            print("Move Down")
            characterY -= 1
        default:
            print("Invalid Move")
        }
        
        moveCharacter()
    }
    
    func moveCharacter() {
        let y = 58 + characterY * 102
        var x = 142 * characterX + masterDan.position.x
        setScale(0.4)
        
        print(x,characterX, myCamera.position.x)
        if x < myCamera.position.x - frame.width * 0.35 {
            x = myCamera.position.x - frame.width * 0.35
        }
        
        
        let moveAction  = SKAction.move(to: CGPoint(x: x, y: y), duration: 0.2)
        
        masterDan.run(moveAction)
        
        let newDistance = scene!.frame.width/2 - masterDan.position.x
        if newDistance > gameDistance {
            gameDistance = newDistance
            gamepro.setGameDistance(dis: gameDistance)
        }
        
    }
    
    
    func damage() -> Int {
        return 0
    }
    
    func terminate() {
        terminateScene = true
        for i in totemMaster {
            i.terminate()
            
        }
    }
    
    func isPlayerGone() -> Bool {
        return isGone(node: masterDan)
        
    }
    
    func isGone(node: SKNode) -> Bool {
        let nodePosition = node.position
        let cameraPosition = myCamera.position
        let width = frame.width
        let edge = cameraPosition.x + width * 0.6
        
        return nodePosition.x > edge
        
    }
    
    func updateTraps() {
        var holdDictionary = [Trap]()
        for i in trapDictionary {
            if isGone(node: i.1) {
                holdDictionary.append(i.1)
            }
        }
        for j in holdDictionary {
            removeTrap(t: j)
        }
        
        let totempicker = totemMaster[Int(arc4random()) % totemMaster.count]
        if totempicker.shouldAttack() {
            makeTrapForTotem(totem: totempicker, powerup: false)
        }
    }
    
    
    func removeTrap(t: Trap) {
        var key: Totem?
        for i in trapDictionary {
            if i.1 == t {
                key = i.0
                break
            }
        }
        if let k = key {
            trapDictionary.removeValue(forKey: k)
        }
        t.removeFromParent()
    }
    
    func updateScore(bonus: Int){
        if firedBanana == false {
            let newScore = gamepro.incrementScore(bonus: bonus)
            scoreCount.text = String(newScore)
        }
        else {
            let noScore = gamepro.setScoreGame(dec: bonus)
            scoreCount.text = String(noScore)
            firedBanana = false
        }
    }
    
    func updateBananas() {
        let now = NSDate().timeIntervalSince1970
        if now > nextBanana {
            let totem = totemMaster[Int(arc4random()) % totemMaster.count]
            if totem.anger <= 2 {
                self.makeTrapForTotem(totem: totem, powerup: true)
                nextBanana = now + Double((arc4random() % 2)) + 1
            }
        }
        
    }
    
    
    var lastUpdateTime: TimeInterval = 0
    
    func howFastCanYouGo() -> CGFloat {
        var dx: CGFloat = CGFloat(pow(gameDistance, 0.5)) / self.cameraFactor + cameraspeed
        let temp = gameDistance/60
        
        if temp <= 60 {
            return dx
        } else if temp <= 140 {
            dx = CGFloat(pow(gameDistance*2,0.5)) / self.cameraFactor + cameraspeed
            return dx
            
        } else {
            dx = CGFloat(pow(gameDistance*3,0.5)) / self.cameraFactor + cameraspeed
            return dx
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        var deltaTime: CFTimeInterval = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        if deltaTime > 1 {
            deltaTime = 1 / 60
            lastUpdateTime = currentTime
        }
        
        if /* updateTime() || */ isPlayerGone() || masterDan.isDead() {
            self.terminate()
            gamepro.gameOver()
        }
        if !terminateScene {
            myCamera.position.x -= howFastCanYouGo() * 60 * CGFloat(deltaTime)
            scrollSceneNodes()
            updateTraps()
            updateBananas()
            let monkeyFeet = String(Int(gameDistance/60))
            timeCount.text = "\(monkeyFeet)"
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          /* Called when a touch begins */
    }
}




extension GameSceneCamera {
    // Check position of nodes as camera moves
    func scrollSceneNodes() {
        for node in makingFloor {
            let x = node.position.x - myCamera.position.x
            if x > scene!.size.width {
                node.position.x -= floorWidth * 2
            }
        }
    }
}

extension GameSceneCamera {
    func didBeginContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == PhysicsCategory.Player | PhysicsCategory.Trap {
            var player: Player!
            var trap: SKSpriteNode!
            
            if contact.bodyA.node!.name == "trap" {
                trap = contact.bodyA.node as! SKSpriteNode
                player = contact.bodyB.node as! Player
            }
            else if contact.bodyB.node!.name == "trap" {
                trap = contact.bodyB.node as! SKSpriteNode
                player = contact.bodyA.node as! Player
            }
            
            if let check = trap as? Trap {
                let damageScale = player.takeDamage(damage: check.damage())
                lifeBarFront.xScale = damageScale
                removeTrap(t: check)
                updateScore(bonus: check.scoreCounter())
                
            }
        }
        else if collision == PhysicsCategory.Player | PhysicsCategory.Totem {
        }
    }
}

extension GameSceneCamera {
    func makeTrap() -> Trap {
        var trap: Trap
        let r = arc4random() % 5
        switch r {
        case 0:
            trap = BearTrap()
        case 1:
            trap = FireTrap()
        case 2:
            trap = DoorTrap()
        case 3:
            trap = ArrowTrap()
        default:
            trap = ArrowTrap()
        }
        return trap
    }
    
    func makeTrapForTotem(totem: Totem, powerup: Bool) {
        if !powerup {
            if let _ = trapDictionary[totem] {
                return
            }
            let now = NSDate().timeIntervalSince1970
            if nextTrap > now {
                return
            }
            nextTrap = now + 2.0
            trap = makeTrap()
            trapDictionary[totem] = trap!
        } else {
            trap = YellowBanana()
        }
        if let t = trap {
            t.position.x = totem.position.x + myCamera.position.x
            t.position.y = totem.position.y
            t.anchorPoint.x = 0.5
            t.anchorPoint.y = 0.5
            trapNode.addChild(t)
        }
    }
}










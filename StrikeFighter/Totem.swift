//
//  Totem.swift
//  TotemMaster
//
//  Created by Danny Peng on 7/22/16.
//  Copyright © 2016 Danny Peng. All rights reserved.
//

import SpriteKit

protocol TotemDelegate: class {
    func makeTrapForTotem(totem: Totem, powerup: Bool)
}

enum TotemColor: String {
    case Red = "Gorilla1",
    Green = "Gorilla2",
    Black = "Gorilla3"
}

class Totem : SKSpriteNode {
    var anger: Int = -1 {
        didSet{
            if !terminated {
                self.texture = textures[anger]
                if anger == 2 {
                    if let delegate = delegate {
                        delegate.makeTrapForTotem(totem: self, powerup:false)
                    }
                }
            }
        }
    }
    weak var delegate: TotemDelegate?
    var textures: [SKTexture]
    var timer: Timer?
    var terminated = false
    
    
    init() {
        
        let texture1 = SKTexture(imageNamed: "SU")
        let texture2 = SKTexture(imageNamed: "SU")
        let texture3 = SKTexture(imageNamed: "SU")
        textures = [texture1, texture2, texture3]
        
        super.init(texture: texture1, color: .clear, size: texture1.size())
        cycleTotem()
        anger = 0
        zPosition = 5
        
        physicsBody = SKPhysicsBody(circleOfRadius: 25)
        physicsBody!.categoryBitMask = PhysicsCategory.Totem
        physicsBody!.contactTestBitMask = PhysicsCategory.Player
        physicsBody!.collisionBitMask = PhysicsCategory.none
        physicsBody!.isDynamic = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func cycleTotem() {
        let interval = Double(15 + arc4random() % 10)/10.0
        
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerCallBack), userInfo: nil, repeats: false)
    }
    
    func terminate() {
        if let timer = timer {
            timer.invalidate()
        }
    }
    
    func placate() {
        if anger > 0 {
            anger = 0
        }
    }
    
    func timerCallBack() {
        cycleTotem()
        if !shouldAttack() {
            anger += 1
        }
    }
    
    func shouldAttack() -> Bool{
        return anger == 2
    }
}
    

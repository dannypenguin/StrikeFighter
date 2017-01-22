//
//  Player.swift
//  StrikeFighter
//
//  Created by Danny Peng on 1/22/17.
//  Copyright © 2017 Danny Peng. All rights reserved.
//

import SpriteKit

class Player : SKSpriteNode {
    
    
    static let maxHealth = 25
    var health = maxHealth
    
    init() {
        let texture = SKTexture(imageNamed: "Monkey1")
        super.init(texture: texture, color: .clear, size: texture.size())
        
        var textures = [SKTexture]()
        textures.append(SKTexture(imageNamed: "Monkey\(1)"))
        
        physicsBody = SKPhysicsBody(circleOfRadius: 25)
        physicsBody!.categoryBitMask = PhysicsCategory.Player
        physicsBody!.contactTestBitMask = PhysicsCategory.Trap | PhysicsCategory.Totem
        physicsBody!.collisionBitMask = PhysicsCategory.none
        physicsBody!.affectedByGravity = false
        physicsBody!.allowsRotation = false
       
        zPosition = 6
        
        let animate = SKAction.animate(with: textures, timePerFrame: 0.2)
        let animateForever = SKAction.repeatForever(animate)
        run(animateForever)
        name = "player"
        
    }
    
    func takeDamage(damage: Int) -> CGFloat {
        health -= damage
        return CGFloat(health)/CGFloat(Player.maxHealth)
        
    }
    
    func isDead() -> Bool {
        return health <= 0
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

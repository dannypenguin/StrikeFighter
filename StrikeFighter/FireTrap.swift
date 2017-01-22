//
//  Trap.swift
//  TotemMaster
//
//  Created by Danny Peng on 7/14/16.
//  Copyright © 2016 Danny Peng. All rights reserved.
//

import SpriteKit



class FireTrap : Trap {
    
    //var fire: SKEmitterNode!
    
    init() {
        
        
        let texture = SKTexture(imageNamed: "su_missile")
        super.init(texture: texture, color: .clear, size: texture.size())
        var textures = [SKTexture]()
        textures.append(SKTexture(imageNamed: "su_missile"))
        
        
        physicsBody = SKPhysicsBody(circleOfRadius: 20)
        physicsBody!.categoryBitMask = PhysicsCategory.Trap
        physicsBody!.contactTestBitMask = PhysicsCategory.Player
        physicsBody!.collisionBitMask = PhysicsCategory.none
        physicsBody!.isDynamic = false
        
        zPosition = 1
        let animate = SKAction.animate(with: textures, timePerFrame: 0.2)
        let animateForever = SKAction.repeatForever(animate)
        run(animateForever)
        
        //fire = SKEmitterNode(fileNamed: "Fire")!
//        addChild(fire)
//        fire.zPosition = 44
        name = "trap"
    }
    
    override func damage() -> Int {
        return 5
    }
    
    override func scoreCounter() -> Int {
        return 0
    }
    
    func armTrap() {
        print("The Trap is armed!")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
 

//
//  BearTrap.swift
//  TotemMaster
//
//  Created by Danny Peng on 7/20/16.
//  Copyright © 2016 Danny Peng. All rights reserved.
//

import SpriteKit

class BearTrap : Trap {
    
    //var spark: SKEmitterNode!
    
    init() {
        
        
        let texture = SKTexture(imageNamed: "bullet")
        super.init(texture: texture, color: .clear, size: texture.size())
        
        var textures = [SKTexture]()
        
        textures.append(SKTexture(imageNamed: "bullet"))
        
        
        physicsBody = SKPhysicsBody(circleOfRadius: 20)
        physicsBody!.categoryBitMask = PhysicsCategory.Trap
        physicsBody!.contactTestBitMask = PhysicsCategory.Player
        physicsBody!.collisionBitMask = PhysicsCategory.none
        physicsBody!.isDynamic = false
        
        zPosition = 1
        let animate = SKAction.animate(with: textures, timePerFrame: 0.2)
        let animateForever = SKAction.repeatForever(animate)
        run(animateForever)
        
        //spark = SKEmitterNode(fileNamed: "Spark")!
//        addChild(spark)
//        spark.zPosition = 44
//        spark.position.x = 15
//        spark.position.y = -5
        name = "trap"
    }
    
    override func damage() -> Int {
        return 10
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

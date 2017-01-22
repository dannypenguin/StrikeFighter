//
//  BananaShot.swift
//  TotemMaster
//
//  Created by Danny Peng on 8/3/16.
//  Copyright © 2016 Danny Peng. All rights reserved.
//

import SpriteKit

class BananaShot: SKSpriteNode {
    
   // var fire: SKEmitterNode!
    
    init() {
        
        let texture = SKTexture(imageNamed: "bananagun1-1")
        super.init(texture: texture, color: .clear, size: texture.size())
        var textures = [SKTexture]()
        textures.append(SKTexture(imageNamed: "bananagun1-1"))
        
        let animate = SKAction.animate(with: textures, timePerFrame: 0.2)
        let animateForever = SKAction.repeatForever(animate)
        run(animateForever)
        
        //fire = SKEmitterNode(fileNamed: "Fire")!
        //addChild(fire)
        //fire.zPosition = 44
        name = "trap"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//
//  TutorialScene.swift
//  MonkeyGatherer
//
//  Created by Danny Peng on 8/9/16.
//  Copyright © 2016 Danny Peng. All rights reserved.
//

import SpriteKit

class TutorialScene: SKScene, Scene {
    var controller: GameProtocol!
    var nextSlide: Int = 0
    var textures = [SKTexture]()
    var holder: SKSpriteNode!
    
    var backButton = ButtonNode(normalImageNamed: "Back", activeImageNamed: "Back", disabledImageNamed: "Back")
    
    
    func setController(_ controller : GameProtocol) {
        self.controller = controller
    }
    
    func onSwipe(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.left:
            holder.texture = textureToPresent(inc: 1)
            print("Move Left")
        case UISwipeGestureRecognizerDirection.right:
            holder.texture = textureToPresent(inc: -1)
            print("Move Right")
        default:
            print("Invalid Move")
        }
    }
    
    func textureToPresent(inc: Int) -> SKTexture? {
        nextSlide += inc
        if nextSlide < textures.count && nextSlide > -1 {
            return textures[nextSlide]
        }
        else if nextSlide >= textures.count {
            nextSlide = textures.count - 1
            return textures[nextSlide]
        } else {
            nextSlide = 0
            return textures[nextSlide]
        }
    }
    
    
    override func didMove(to view: SKView) {
        for i in 1...4 {
            textures.append(SKTexture(imageNamed: "Jungle\(i)"))
        }
        
        holder = SKSpriteNode(texture: textures[0])
        addChild(holder)
        holder.position.x = scene!.size.width/2
        holder.position.y = scene!.size.height/2
        holder.zPosition = 0
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector(("swipedRight:")))
        swipeRight.direction = .right
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector(("swipedLeft:")))
        swipeLeft.direction = .left
        
        
        

        
        swipeLeft.direction = .left
        swipeRight.direction = .right
        
        view.addGestureRecognizer(swipeRight)
        view.addGestureRecognizer(swipeLeft)
        
        addChild(backButton)
        backButton.zPosition = 1
        backButton.position.x = scene!.size.width - (scene!.size.width/8) * 7
        backButton.position.y = scene!.size.height - (scene!.size.height/8) * 7
        backButton.setScale(0.9)
        backButton.selectedHandler = {
            self.controller.openingScene()
        }
        
        
        
        
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

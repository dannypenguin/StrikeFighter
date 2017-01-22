//
//  GameLimbo.swift
//  MonkeyGatherer
//
//  Created by Danny Peng on 8/9/16.
//  Copyright © 2016 Danny Peng. All rights reserved.
//

import SpriteKit


class GameLimbo: SKScene, Scene {
    var controller : GameProtocol!
    var backButton = ButtonNode(normalImageNamed: "Back", activeImageNamed: "Back", disabledImageNamed: "Back")
    var highScore: SKLabelNode!
    var highTitle: SKLabelNode!
    var highDistance: SKLabelNode!
    
    func setController(_ controller : GameProtocol) {
        self.controller = controller
    }
    
    override func didMove(to view: SKView) {
        addChild(backButton)
        backButton.zPosition = 1
        backButton.position.x = 490
        backButton.position.y = 50
        backButton.selectedHandler = {
            //TODO: Move to the gameScene
            self.controller.openingScene()
        }
        highScore = scene!.childNode(withName: "HighScore") as! SKLabelNode
        highTitle = scene!.childNode(withName: "HighTitle") as!
        SKLabelNode
        highDistance = scene!.childNode(withName: "highDistance") as! SKLabelNode
        
        let careerScore = controller.getCareerScore()
        highScore.text = "Career Banana Count: \(careerScore)"
        
        let careerTitle = controller.getCareerTitleAsString()
        highTitle.text = "Career Title: \(careerTitle)"
        
        let careerLongDistance = controller.getCareerLongDis()
        highDistance.text = "Career Record Distance: \(careerLongDistance)"
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

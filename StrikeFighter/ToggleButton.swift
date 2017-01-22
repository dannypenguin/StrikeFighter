//
//  ToggleButton.swift
//  MonkeyGatherer
//
//  Created by Danny Peng on 8/8/16.
//  Copyright © 2016 Danny Peng. All rights reserved.
//

import SpriteKit

class ToggleButton: SKSpriteNode {
    var selectedTexture: SKTexture
    var unselectedTexture: SKTexture
    var selectedBool: Bool = false {
        didSet {
            if selectedBool {
                texture = selectedTexture
                unselectedHandler()
            } else {
                texture = unselectedTexture
                selectedHandler()
            }
        }
    }
    
    var selectedHandler: () -> Void = { print("Selected handle not set") }
    var unselectedHandler: () -> Void = { print("Unselected handler not set")}
    
    init(selectedName: String, unselectedName: String, selected: Bool = true) {
        selectedTexture = SKTexture(imageNamed: selectedName)
        unselectedTexture = SKTexture(imageNamed: unselectedName)
        super.init(texture: selectedTexture, color: .clear, size: selectedTexture.size())
        selectedBool = selected
        isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedBool = !selectedBool
    }
    
}

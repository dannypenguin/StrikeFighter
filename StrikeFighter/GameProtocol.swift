//
//  GameProtocol.swift
//  StrikeFighter
//
//  Created by Danny Peng on 1/21/17.
//  Copyright © 2017 Danny Peng. All rights reserved.
//

import SpriteKit

protocol GameProtocol: class {
    func startGame()
    func openingScene()
    func tutorialScene()
    func gameLimbo()
    func gameOver()
    func getCareerScore() -> Int
    func setCareerScore(inc: Int)
    func getCareerTitle() -> Int
    func getCareerTitleAsString() -> String
    func setCareerTitle(inc: Int)
    func getCareerLongDis()-> Int
    func setCareerLongDis(inc: Int)
    func getScore() -> Int
    func incrementScore(bonus: Int) -> Int
    func setScoreGame(dec: Int) -> Int
    func setGameDistance(dis: CGFloat)
    
}

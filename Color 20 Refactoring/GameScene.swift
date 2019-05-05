//
//  GameScene.swift
//  Color 20 Refactoring
//
//  Created by Wesley Dashner on 5/4/19.
//  Copyright © 2019 Wesley Dashner. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        let board = Board(x: 10, y: 10, widthOfBoard: Int(self.frame.width), gameScene: self)
    }
}

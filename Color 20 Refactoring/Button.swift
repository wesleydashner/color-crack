//
//  Button.swift
//  Color 20 Refactoring
//
//  Created by Wesley Dashner on 5/7/19.
//  Copyright © 2019 Wesley Dashner. All rights reserved.
//

import Foundation
import SpriteKit

class Button {
    let sprite = SKSpriteNode()
    
    init(color: UIColor) {
        sprite.color = color
    }
    
    func loadButton(scene: SKScene) {
        let buttonWidth = scene.frame.width / (6 + 7/6)
        sprite.size = CGSize(width: buttonWidth, height: buttonWidth * 2)
        sprite.position = CGPoint(x: -(buttonWidth * 2.5 + (buttonWidth / 6) * 2.5), y: (-scene.frame.height + scene.frame.width) / 4 - scene.frame.width / 2)
        scene.addChild(sprite)
    }
    
    func buttonTapped(board: Board) {
        board.doColor(color: sprite.color)
    }
}

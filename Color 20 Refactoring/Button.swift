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
    
    func loadButton(scene: SKScene, positionIndex: Int) {
        let buttonWidth = scene.frame.width / (6 + 7/6)
        var buttonHeight: CGFloat
        if UIDevice.current.userInterfaceIdiom == .pad {
            buttonHeight = buttonWidth
        }
        else {
            buttonHeight = buttonWidth * 2
        }
        sprite.size = CGSize(width: buttonWidth, height: buttonHeight)
        for i in 0...5 {
            if positionIndex == i {
                sprite.position.x = CGFloat((7/6) * (-2.5 + Double(i)))
                sprite.position.x *= CGFloat(buttonWidth)
                sprite.position.y = CGFloat((-scene.frame.height - scene.frame.width) / 4)
            }
        }
        scene.addChild(sprite)
    }
    
    func buttonTapped(board: Board) {
        board.doColor(color: sprite.color)
    }
}

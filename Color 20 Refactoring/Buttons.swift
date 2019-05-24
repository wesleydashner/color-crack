//
//  Buttons.swift
//  Color 20 Refactoring
//
//  Created by Wesley Dashner on 5/7/19.
//  Copyright © 2019 Wesley Dashner. All rights reserved.
//

import Foundation
import SpriteKit

class Buttons {
    var buttons: [Button] = []
    
    init(colors: [UIColor]) {
        for color in colors {
            buttons.append(Button(color: color))
        }
    }
    
    func loadButtons(scene: SKScene) {
        var index = 0
        for button in buttons {
            button.loadButton(scene: scene, positionIndex: index)
            index += 1
        }
    }
    
    func getButton(ofColor color: UIColor) -> Button {
        for button in buttons {
            if button.sprite.color == color {
                return button
            }
        }
        print("ERROR: returning black button because button of given color was not found")
        return Button(color: .black)
    }
    
    func getTransparentSprite() -> SKSpriteNode {
        let sprite = SKSpriteNode()
        sprite.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        sprite.position.x = 0
        sprite.position.y = buttons[0].sprite.position.y - buttons[0].sprite.frame.height / 2
        sprite.size = CGSize(width: (-buttons[0].sprite.position.x + buttons[0].sprite.frame.width / 2) * 2, height: buttons[0].sprite.frame.height)
        return sprite
    }
}

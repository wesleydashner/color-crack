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
}

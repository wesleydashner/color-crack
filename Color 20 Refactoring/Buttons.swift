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
    var sprites: Array<Button> = []
    
    init(colors: Array<UIColor>) {
        for color in colors {
            sprites.append(Button(color: color))
        }
    }
    
    func loadButtons(scene: SKScene) {
        for sprite in sprites {
            sprite.loadButton(scene: scene)
        }
    }
}

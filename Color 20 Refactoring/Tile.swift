//
//  Tile.swift
//  Color 20 Refactoring
//
//  Created by Wesley Dashner on 5/7/19.
//  Copyright © 2019 Wesley Dashner. All rights reserved.
//

import Foundation
import SpriteKit

class Tile : Equatable {
    var sprite: SKSpriteNode
    var captured: Bool
    
    init(sprite: SKSpriteNode, captured: Bool) {
        self.sprite = sprite
        self.captured = captured
    }
    
    static func == (lhs: Tile, rhs: Tile) -> Bool {
        return lhs.sprite == rhs.sprite
    }
}

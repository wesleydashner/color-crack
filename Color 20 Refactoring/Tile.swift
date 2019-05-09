//
//  Tile.swift
//  Color 20 Refactoring
//
//  Created by Wesley Dashner on 5/7/19.
//  Copyright © 2019 Wesley Dashner. All rights reserved.
//

import Foundation
import SpriteKit

class Tile : NSObject, NSCoding {
    var sprite: SKSpriteNode
    var captured: Bool
    
    init(sprite: SKSpriteNode, captured: Bool) {
        self.sprite = sprite
        self.captured = captured
    }
    
    static func == (lhs: Tile, rhs: Tile) -> Bool {
        return lhs.sprite == rhs.sprite
    }
    
    
    // NSCoding
    enum Keys: String {
        case sprite = "Sprite"
        case captured = "Captured"
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(sprite, forKey: Keys.sprite.rawValue)
        aCoder.encode(captured, forKey: Keys.captured.rawValue)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let sprite = aDecoder.decodeObject(forKey: Keys.sprite.rawValue) as! SKSpriteNode
        let captured = aDecoder.decodeBool(forKey: Keys.captured.rawValue)
        self.init(sprite: sprite, captured: captured)
    }
}

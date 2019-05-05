//
//  Board.swift
//  Color 20 Refactoring
//
//  Created by Wesley Dashner on 5/4/19.
//  Copyright © 2019 Wesley Dashner. All rights reserved.
//

import Foundation
import SpriteKit

class Board {
    var tiles: Array<Array<SKSpriteNode>>
    
    init(x: Int, y: Int, widthOfBoard: Int, gameScene: SKScene, centerX: Int = 0, centerY: Int = 0) {
        let widthOfTile = Double(widthOfBoard / x)
        tiles = []
        for _ in 1...y {
            tiles.append([])
        }
        for rowIndex in 0...(y - 1) {
            for columnIndex in 0...(x - 1) {
                let sprite = SKSpriteNode()
                sprite.size = CGSize(width: widthOfTile, height: widthOfTile)
                if x % 2 == 0 {
                    sprite.position.x = CGFloat(-widthOfTile * Double(x / 2 - (columnIndex + 1)) - widthOfTile / 2 + Double(centerX))
                }
                else {
                    sprite.position.x = CGFloat(-widthOfTile * Double(x / 2 - (columnIndex + 1)) - widthOfTile + Double(centerX))
                }
                if y % 2 == 0 {
                    sprite.position.y = CGFloat(widthOfTile * Double(y / 2 - (rowIndex + 1)) + widthOfTile / 2 + Double(centerY))
                }
                else {
                    sprite.position.y = CGFloat(widthOfTile * Double(y / 2 - (rowIndex + 1)) + widthOfTile + Double(centerY))
                }
                let colors: Array<UIColor> = [.red, .orange, .yellow, .green, .blue, .purple]
                sprite.color = colors.randomElement()!
                tiles[rowIndex].append(sprite)
                gameScene.addChild(sprite)
            }
        }
    }
}

//
//  Board.swift
//  Color 20 Refactoring
//
//  Created by Wesley Dashner on 5/4/19.
//  Copyright © 2019 Wesley Dashner. All rights reserved.
//

import Foundation
import SpriteKit

struct Tile {
    var sprite: SKSpriteNode
    var captured: Bool
}

class Board {
    var tiles: Array<Array<Tile>>
    
    init(x: Int, y: Int) {
        tiles = []
        for _ in 1...y {
            tiles.append([])
        }
        for rowIndex in 0...(tiles.count - 1) {
            for _ in 1...x {
                tiles[rowIndex].append(Tile(sprite: SKSpriteNode(), captured: false))
            }
        }
        self.randomizeBoard()
    }
    
    func randomizeBoard() {
        let colors: Array<UIColor> = [.red, .orange, .yellow, .green, .blue, .purple]
        
        for row in tiles {
            for columnIndex in 0...(row.count - 1) {
                row[columnIndex].sprite.color = colors.randomElement()!
            }
        }
    }
    
    func loadBoard(gameScene: SKScene, widthOfBoard: Int, centerX: Int = 0, centerY: Int = 0) {
        let x = tiles[0].count
        let y = tiles.count
        let widthOfTile = Double(widthOfBoard / x)
        
        for rowIndex in 0...(tiles.count - 1) {
            for columnIndex in 0...(tiles[rowIndex].count - 1) {
                tiles[rowIndex][columnIndex].sprite.size = CGSize(width: widthOfTile, height: widthOfTile)
                if x % 2 == 0 {
                    tiles[rowIndex][columnIndex].sprite.position.x = CGFloat(-widthOfTile * Double(x / 2 - (columnIndex + 1)) - widthOfTile / 2 + Double(centerX))
                }
                else {
                    tiles[rowIndex][columnIndex].sprite.position.x = CGFloat(-widthOfTile * Double(x / 2 - (columnIndex + 1)) - widthOfTile + Double(centerX))
                }
                if y % 2 == 0 {
                    tiles[rowIndex][columnIndex].sprite.position.y = CGFloat(widthOfTile * Double(y / 2 - (rowIndex + 1)) + widthOfTile / 2 + Double(centerY))
                }
                else {
                    tiles[rowIndex][columnIndex].sprite.position.y = CGFloat(widthOfTile * Double(y / 2 - (rowIndex + 1)) + widthOfTile + Double(centerY))
                }
                gameScene.addChild(tiles[rowIndex][columnIndex].sprite)
            }
        }
    }
    
    func doColor(color: UIColor) {
        
    }
}

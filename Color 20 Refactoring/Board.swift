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
        tiles = []
        for _ in 1...y {
            tiles.append([])
        }
        for rowIndex in 0...(tiles.count - 1) {
            for _ in 1...x {
                tiles[rowIndex].append(SKSpriteNode())
            }
        }
        randomizeBoard()
        loadBoard(widthOfBoard: widthOfBoard, gameScene: gameScene, centerX: centerX, centerY: centerY)
    }
    
    func randomizeBoard() {
        let colors: Array<UIColor> = [.red, .orange, .yellow, .green, .blue, .purple]
        
        for row in tiles {
            for columnIndex in 0...(row.count - 1) {
                row[columnIndex].color = colors.randomElement()!
            }
        }
    }
    
    func loadBoard(widthOfBoard: Int, gameScene: SKScene, centerX: Int, centerY: Int) {
        let x = tiles[0].count
        let y = tiles.count
        let widthOfTile = Double(widthOfBoard / x)
        
        for rowIndex in 0...(tiles.count - 1) {
            for columnIndex in 0...(tiles[rowIndex].count - 1) {
                tiles[rowIndex][columnIndex].size = CGSize(width: widthOfTile, height: widthOfTile)
                if x % 2 == 0 {
                    tiles[rowIndex][columnIndex].position.x = CGFloat(-widthOfTile * Double(x / 2 - (columnIndex + 1)) - widthOfTile / 2 + Double(centerX))
                }
                else {
                    tiles[rowIndex][columnIndex].position.x = CGFloat(-widthOfTile * Double(x / 2 - (columnIndex + 1)) - widthOfTile + Double(centerX))
                }
                if y % 2 == 0 {
                    tiles[rowIndex][columnIndex].position.y = CGFloat(widthOfTile * Double(y / 2 - (rowIndex + 1)) + widthOfTile / 2 + Double(centerY))
                }
                else {
                    tiles[rowIndex][columnIndex].position.y = CGFloat(widthOfTile * Double(y / 2 - (rowIndex + 1)) + widthOfTile + Double(centerY))
                }
                gameScene.addChild(tiles[rowIndex][columnIndex])
            }
        }
    }
}

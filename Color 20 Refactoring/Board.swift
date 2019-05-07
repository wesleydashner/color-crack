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
    var tiles: Array<Array<Tile>> = []
    var tilesCalledThisTurn: Array<Tile> = []
    
    init(x: Int, y: Int) {
        for _ in 1...y {
            tiles.append([])
        }
        for rowIndex in 0...(tiles.count - 1) {
            for _ in 1...x {
                tiles[rowIndex].append(Tile(sprite: SKSpriteNode(), captured: false))
            }
        }
        self.randomizeBoard()
        tiles[0][0].captured = true
    }
    
    func randomizeBoard() {
        let colors: Array<UIColor> = [.red, .orange, .yellow, .green, .blue, .purple]
        
        for row in tiles {
            for columnIndex in 0...(row.count - 1) {
                row[columnIndex].sprite.color = colors.randomElement()!
            }
        }
        
        let goodColors: Array<UIColor> = colors.filter { $0 != tiles[0][0].sprite.color }
        tiles[0][1].sprite.color = goodColors.randomElement()!
        tiles[1][0].sprite.color = goodColors.randomElement()!
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
        tilesCalledThisTurn = []
        for y in 0...(tiles.count - 1) {
            for x in 0...(tiles[y].count - 1) {
                if tiles[y][x].captured == true && !tilesCalledThisTurn.contains(tiles[y][x]) {
                    captureTiles(color: color, x: x, y: y)
                }
            }
        }
        
        for y in 0...(tiles.count - 1) {
            for x in 0...(tiles[y].count - 1) {
                if tiles[y][x].captured == true {
                    tiles[y][x].sprite.color = color
                }
            }
        }
    }
    
    func captureTiles(color: UIColor, x: Int, y: Int) {
        tilesCalledThisTurn.append(tiles[y][x])
        if y != 0 && tiles[y - 1][x].sprite.color == color && tiles[y - 1][x].captured == false {
            tiles[y - 1][x].captured = true
            captureTiles(color: color, x: x, y: y - 1)
        }
        if y != tiles.count - 1 && tiles[y + 1][x].sprite.color == color && tiles[y + 1][x].captured == false {
            tiles[y + 1][x].captured = true
            captureTiles(color: color, x: x, y: y + 1)
        }
        if x != 0 && tiles[y][x - 1].sprite.color == color && tiles[y][x - 1].captured == false {
            tiles[y][x - 1].captured = true
            captureTiles(color: color, x: x - 1, y: y)
        }
        if x != tiles[0].count - 1 && tiles[y][x + 1].sprite.color == color && tiles[y][x + 1].captured == false {
            tiles[y][x + 1].captured = true
            captureTiles(color: color, x: x + 1, y: y)
        }
    }
    
    func isFilled() -> Bool {
        let colorToTest = tiles[0][0].sprite.color
        for y in 0...(tiles.count - 1) {
            for x in 0...(tiles[y].count - 1) {
                if tiles[y][x].sprite.color != colorToTest {
                    return false
                }
            }
        }
        return true
    }
    
    func disconnect() {
        for y in 0...(tiles.count - 1) {
            for x in 0...(tiles[y].count - 1) {
                tiles[y][x].sprite.removeFromParent()
            }
        }
    }
    
    func animateCapturedTiles() {
        var capturedTiles: Array<Tile> = []
        for y in 0...(tiles.count - 1) {
            for x in 0...(tiles[y].count - 1) {
                tiles[y][x].sprite.zPosition = 0
                if tiles[y][x].captured == true {
                    capturedTiles.append(tiles[y][x])
                    tiles[y][x].sprite.zPosition = 1
                }
            }
        }
        for tile in capturedTiles {
            tile.sprite.run(.sequence([.scale(to: 1.2, duration: 0.1), .scale(to: 1, duration: 0.1)]))
        }
    }
}

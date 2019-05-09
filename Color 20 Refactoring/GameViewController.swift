//
//  GameViewController.swift
//  Color 20 Refactoring
//
//  Created by Wesley Dashner on 5/4/19.
//  Copyright © 2019 Wesley Dashner. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    let scene = SKScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var boardDimension = 2
    var bestDimension = 2
    var scoreLimit = 3
    var board = Board(x: 2, y: 2)
    let buttons = Buttons(colors: [.red, .orange, .yellow, .green, .blue, .purple])
    let scoreLabel = SKLabelNode()
    let currentLevelLabel = SKLabelNode()
    let bestLevelLabel = SKLabelNode()
    var score = 0
    let impactGenerator = UIImpactFeedbackGenerator(style: .light)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if loadBoard() != nil {
            board = loadBoard()!
            boardDimension = board.tiles.count
            scoreLimit = getScoreLimit(dimension: boardDimension)
        }
        
        score = UserDefaults.standard.integer(forKey: "currentScore")
        
        let view = self.view as! SKView?
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .aspectFit
        view?.presentScene(scene)
        view?.ignoresSiblingOrder = true
        board.loadBoard(gameScene: scene, widthOfBoard: Int(scene.frame.width))
        buttons.loadButtons(scene: scene)
        
        scoreLabel.text = "\(score) / \(scoreLimit)"
        scoreLabel.fontSize = 50
        scoreLabel.position = CGPoint(x: 0, y: (scene.frame.height + scene.frame.width) / 4)
        scoreLabel.fontName = "Nexa Bold"
        scene.addChild(scoreLabel)
        
        currentLevelLabel.text = "LEVEL: \(boardDimension)"
        currentLevelLabel.fontSize = 25
        currentLevelLabel.position = CGPoint(x: -scene.frame.width / 4, y: scene.frame.width / 2 + currentLevelLabel.fontSize / 2 + 10)
        currentLevelLabel.fontName = "Nexa Bold"
        scene.addChild(currentLevelLabel)
        
        if UserDefaults.standard.integer(forKey: "best") > 0 {
            bestDimension = UserDefaults.standard.integer(forKey: "best")
        }
        else {
            UserDefaults.standard.set(2, forKey: "best")
            bestDimension = 2
        }
        
        bestLevelLabel.text = "BEST: \(bestDimension)"
        bestLevelLabel.fontSize = 25
        bestLevelLabel.position = CGPoint(x: scene.frame.width / 4, y: scene.frame.width / 2 + bestLevelLabel.fontSize / 2 + 10)
        bestLevelLabel.fontName = "Nexa Bold"
        scene.addChild(bestLevelLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: scene)
            
            for color: UIColor in [.red, .orange, .yellow, .green, .blue, .purple] {
                if buttons.getButton(ofColor: color).sprite.contains(location) {
                    impactGenerator.impactOccurred()
                    if board.isFilled() {
                        boardDimension += 1
                        scoreLimit = getScoreLimit(dimension: boardDimension)
                        resetBoard(dimension: boardDimension, topRightColor: color)
                        board.animateCapturedTiles()
                        setScoreAndLabel(score: 0)
                        updateLevelAndBest(newDimension: boardDimension)
                    }
                    else if score == scoreLimit {
                        boardDimension = 2
                        scoreLimit = getScoreLimit(dimension: boardDimension)
                        resetBoard(dimension: boardDimension, topRightColor: color)
                        board.animateCapturedTiles()
                        setScoreAndLabel(score: 0)
                        updateLevelAndBest(newDimension: boardDimension)
                    }
                    else {
                        buttons.getButton(ofColor: color).buttonTapped(board: board)
                        board.animateCapturedTiles()
                        setScoreAndLabel(score: score + 1)
                    }
                    UserDefaults.standard.set(score, forKey: "currentScore")
                    saveBoard(board: board)
                }
            }
        }
    }
    
    func resetBoard(dimension: Int, topRightColor: UIColor) {
        board.disconnect()
        board = Board(x: dimension, y: dimension, topRightColor: topRightColor)
        board.loadBoard(gameScene: scene, widthOfBoard: Int(scene.frame.width))
    }
    
    func setScoreAndLabel(score: Int) {
        self.score = score
        scoreLabel.text = "\(score) / \(scoreLimit)"
    }
    
    func updateLevelAndBest(newDimension: Int) {
        bestDimension = UserDefaults.standard.integer(forKey: "best")
        if newDimension > bestDimension {
            bestDimension = newDimension
            UserDefaults.standard.set(bestDimension, forKey: "best")
            bestLevelLabel.text = "BEST: \(newDimension)"
        }
        currentLevelLabel.text = "LEVEL: \(newDimension)"
    }
    
    func getScoreLimit(dimension: Int) -> Int {
        return dimension * 2 - Int((dimension - 1) / 6)
    }
    
    private func saveBoard(board: Board) {
        NSKeyedArchiver.archiveRootObject(board, toFile: Board.ArchiveURL.path)
    }
    
    private func loadBoard() -> Board? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Board.ArchiveURL.path) as? Board
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

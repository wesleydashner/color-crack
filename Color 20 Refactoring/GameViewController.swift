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
    var scoreLimit = 4
    var board = Board(x: 2, y: 2)
    let buttons = Buttons(colors: [.red, .orange, .yellow, .green, .blue, .purple])
    let scoreLabel = SKLabelNode()
    var score = 0
    let impactGenerator = UIImpactFeedbackGenerator(style: .light)

    override func viewDidLoad() {
        super.viewDidLoad()
        let view = self.view as! SKView?
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .aspectFit
        view?.presentScene(scene)
        view?.ignoresSiblingOrder = true
        board.loadBoard(gameScene: scene, widthOfBoard: Int(scene.frame.width))
        buttons.loadButtons(scene: scene)
        
        scoreLabel.text = "\(score) / \(scoreLimit)"
        scoreLabel.position = CGPoint(x: 0, y: 300)
        scene.addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: scene)
            
            for color: UIColor in [.red, .orange, .yellow, .green, .blue, .purple] {
                if buttons.getButton(ofColor: color).sprite.contains(location) {
                    impactGenerator.impactOccurred()
                    if board.isFilled() {
                        boardDimension += 1
                        scoreLimit = boardDimension * 2
                        resetBoard(dimension: boardDimension)
                        setScoreAndLabel(score: 0)
                    }
                    else if score == scoreLimit {
                        boardDimension = 2
                        scoreLimit = boardDimension * 2
                        resetBoard(dimension: boardDimension)
                        setScoreAndLabel(score: 0)
                    }
                    else {
                        buttons.getButton(ofColor: color).buttonTapped(board: board)
                        setScoreAndLabel(score: score + 1)
                    }
                }
            }
        }
    }
    
    func resetBoard(dimension: Int) {
        board.disconnect()
        board = Board(x: dimension, y: dimension)
        board.loadBoard(gameScene: scene, widthOfBoard: Int(scene.frame.width))
    }
    
    func setScoreAndLabel(score: Int) {
        self.score = score
        scoreLabel.text = "\(score) / \(scoreLimit)"
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

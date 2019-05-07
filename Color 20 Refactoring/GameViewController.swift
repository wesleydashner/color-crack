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
    let board = Board(x: 12, y: 12)
    let buttons = Buttons(colors: [.red, .orange, .yellow, .green, .blue, .purple])
    let scoreLabel = SKLabelNode()
    var score = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let view = self.view as! SKView?
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .aspectFit
        view?.presentScene(scene)
        view?.ignoresSiblingOrder = true
        board.loadBoard(gameScene: scene, widthOfBoard: Int(scene.frame.width))
        buttons.loadButtons(scene: scene)
        
        scoreLabel.text = "\(score)"
        scoreLabel.position = CGPoint(x: 0, y: 300)
        scene.addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: scene)
            
            for color: UIColor in [.red, .orange, .yellow, .green, .blue, .purple] {
                if buttons.getButton(ofColor: color).sprite.contains(location) {
                    buttons.getButton(ofColor: color).buttonTapped(board: board)
                    score += 1
                    scoreLabel.text = "\(score)"
                }
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

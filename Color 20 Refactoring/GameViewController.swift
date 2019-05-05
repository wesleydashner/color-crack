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

let board = Board(x: 10, y: 10)

class GameViewController: UIViewController {
    
    let scene = SKScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

    override func viewDidLoad() {
        super.viewDidLoad()
        let view = self.view as! SKView?
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .aspectFit
        view?.presentScene(scene)
        view?.ignoresSiblingOrder = true
        board.loadBoard(gameScene: scene, widthOfBoard: Int(scene.frame.width))
        
        let redButton = SKSpriteNode()
        redButton.size = CGSize(width: 100, height: 100)
        redButton.position = CGPoint(x: 0, y: -scene.frame.height / 2 + redButton.frame.height / 2)
        redButton.color = .red
        scene.addChild(redButton)
    }
    

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

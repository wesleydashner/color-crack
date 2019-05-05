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

    override func viewDidLoad() {
        super.viewDidLoad()
        let view = self.view as! SKView?
        let scene = SKScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .aspectFit
        view?.presentScene(scene)
        view?.ignoresSiblingOrder = true
        let board = Board(x: 10, y: 10, widthOfBoard: Int(scene.frame.width), gameScene: scene)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

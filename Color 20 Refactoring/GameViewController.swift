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

let board = Board(x: 2, y: 2)

class GameViewController: UIViewController {
    
    let scene = SKScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let redButton = SKSpriteNode()
    let orangeButton = SKSpriteNode()
    let yellowButton = SKSpriteNode()
    let greenButton = SKSpriteNode()
    let blueButton = SKSpriteNode()
    let purpleButton = SKSpriteNode()
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
        
        redButton.size = CGSize(width: 50, height: 50)
        redButton.position = CGPoint(x: -100, y: -scene.frame.height / 2 + redButton.frame.height / 2)
        redButton.position.y += 150
        redButton.color = .red
        scene.addChild(redButton)
        
        orangeButton.size = CGSize(width: 50, height: 50)
        orangeButton.position = CGPoint(x: 0, y: -scene.frame.height / 2 + redButton.frame.height / 2)
        orangeButton.position.y += 150
        orangeButton.color = .orange
        scene.addChild(orangeButton)
        
        yellowButton.size = CGSize(width: 50, height: 50)
        yellowButton.position = CGPoint(x: 100, y: -scene.frame.height / 2 + redButton.frame.height / 2)
        yellowButton.position.y += 150
        yellowButton.color = .yellow
        scene.addChild(yellowButton)
        
        greenButton.size = CGSize(width: 50, height: 50)
        greenButton.position = CGPoint(x: -100, y: -scene.frame.height / 2 + redButton.frame.height / 2)
        greenButton.position.y += 50
        greenButton.color = .green
        scene.addChild(greenButton)
        
        blueButton.size = CGSize(width: 50, height: 50)
        blueButton.position = CGPoint(x: 0, y: -scene.frame.height / 2 + redButton.frame.height / 2)
        blueButton.position.y += 50
        blueButton.color = .blue
        scene.addChild(blueButton)
        
        purpleButton.size = CGSize(width: 50, height: 50)
        purpleButton.position = CGPoint(x: 100, y: -scene.frame.height / 2 + redButton.frame.height / 2)
        purpleButton.position.y += 50
        purpleButton.color = .purple
        scene.addChild(purpleButton)
        
        scoreLabel.text = "\(score)"
        scoreLabel.position = CGPoint(x: 0, y: 300)
        scene.addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: scene)
            
            if redButton.contains(location) {
                board.doColor(color: .red)
                score += 1
                scoreLabel.text = "\(score)"
            }
            if orangeButton.contains(location) {
                board.doColor(color: .orange)
                score += 1
                scoreLabel.text = "\(score)"
            }
            if yellowButton.contains(location) {
                board.doColor(color: .yellow)
                score += 1
                scoreLabel.text = "\(score)"
            }
            if greenButton.contains(location) {
                board.doColor(color: .green)
                score += 1
                scoreLabel.text = "\(score)"
            }
            if blueButton.contains(location) {
                board.doColor(color: .blue)
                score += 1
                scoreLabel.text = "\(score)"
            }
            if purpleButton.contains(location) {
                board.doColor(color: .purple)
                score += 1
                scoreLabel.text = "\(score)"
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

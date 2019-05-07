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

let board = Board(x: 12, y: 12)

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
        
        let buttonWidth = scene.frame.width / (6 + 7/6)
        redButton.size = CGSize(width: buttonWidth, height: buttonWidth * 2)
        redButton.position = CGPoint(x: -(buttonWidth * 2.5 + (buttonWidth / 6) * 2.5), y: (-scene.frame.height + scene.frame.width) / 4 - scene.frame.width / 2)
        redButton.color = .red
        scene.addChild(redButton)
        
        orangeButton.size = CGSize(width: buttonWidth, height: buttonWidth * 2)
        orangeButton.position = CGPoint(x: -(buttonWidth * 1.5 + (buttonWidth / 6) * 1.5), y: (-scene.frame.height + scene.frame.width) / 4 - scene.frame.width / 2)
        orangeButton.color = .orange
        scene.addChild(orangeButton)
        
        yellowButton.size = CGSize(width: buttonWidth, height: buttonWidth * 2)
        yellowButton.position = CGPoint(x: -(buttonWidth * 0.5 + (buttonWidth / 6) * 0.5), y: (-scene.frame.height + scene.frame.width) / 4 - scene.frame.width / 2)
        yellowButton.color = .yellow
        scene.addChild(yellowButton)
        
        greenButton.size = CGSize(width: buttonWidth, height: buttonWidth * 2)
        greenButton.position = CGPoint(x: buttonWidth * 0.5 + (buttonWidth / 6) * 0.5, y: (-scene.frame.height + scene.frame.width) / 4 - scene.frame.width / 2)
        greenButton.color = .green
        scene.addChild(greenButton)
        
        blueButton.size = CGSize(width: buttonWidth, height: buttonWidth * 2)
        blueButton.position = CGPoint(x: buttonWidth * 1.5 + (buttonWidth / 6) * 1.5, y: (-scene.frame.height + scene.frame.width) / 4 - scene.frame.width / 2)
        blueButton.color = .blue
        scene.addChild(blueButton)
        
        purpleButton.size = CGSize(width: buttonWidth, height: buttonWidth * 2)
        purpleButton.position = CGPoint(x: buttonWidth * 2.5 + (buttonWidth / 6) * 2.5, y: (-scene.frame.height + scene.frame.width) / 4 - scene.frame.width / 2)
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

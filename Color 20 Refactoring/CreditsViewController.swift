//
//  CreditsViewController.swift
//  Color 20 Refactoring
//
//  Created by Wesley Dashner on 6/10/19.
//  Copyright © 2019 Wesley Dashner. All rights reserved.
//

import UIKit
import SpriteKit

class CreditsViewController: UIViewController {
    
    let scene = SKScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let creditsLabel = SKLabelNode()
    let kenzieLabel = SKLabelNode()
    let backButton = SKSpriteNode(imageNamed: "back")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = self.view as! SKView?
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .aspectFit
        view?.presentScene(scene)
        view?.ignoresSiblingOrder = true
        
        creditsLabel.text = "Developed By:\nWesley Dashner\n\nGraphic Design By:\nKenzie Dunford"
        creditsLabel.fontSize = 28
        creditsLabel.numberOfLines = 0
        creditsLabel.fontColor = .white
        creditsLabel.fontName = "Nexa Bold"
        creditsLabel.position = CGPoint(x: 0, y: 0)
        scene.addChild(creditsLabel)
        
        backButton.size = CGSize(width: moneyLabelHeight, height: moneyLabelHeight)
        if UIDevice.current.userInterfaceIdiom == .pad {
            backButton.position = CGPoint(x: -scene.frame.width / 2 + backButton.frame.width / 2 + 10, y: (scene.frame.height + scene.frame.width) / 4 + scene.frame.height / 32 + 12)
        }
        else {
            backButton.position = CGPoint(x: -scene.frame.width / 2 + backButton.frame.width / 2 + 10, y: (scene.frame.height + scene.frame.width) / 4 + scene.frame.height / 16 + 9)
        }
        scene.addChild(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: scene)
            
            if backButton.contains(location) {
                impactGenerator.impactOccurred()
                self.performSegue(withIdentifier: "toShop", sender: self)
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

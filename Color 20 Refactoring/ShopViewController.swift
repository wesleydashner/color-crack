//
//  ShopViewController.swift
//  Color 20 Refactoring
//
//  Created by Wesley Dashner on 5/10/19.
//  Copyright © 2019 Wesley Dashner. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class ShopViewController: UIViewController {
    
    let scene = SKScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let moneyLabel = SKLabelNode()
    let upgradeButton = SKSpriteNode(imageNamed: "upgrade")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = self.view as! SKView?
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .aspectFit
        view?.presentScene(scene)
        view?.ignoresSiblingOrder = true
        
        let money = UserDefaults.standard.integer(forKey: "money")
        moneyLabel.text = "$\(money)"
        moneyLabel.fontSize = 20
        moneyLabel.fontColor = .yellow
        moneyLabel.fontName = "Nexa Bold"
        if UIDevice.current.userInterfaceIdiom == .pad {
            moneyLabel.fontSize *= 2
            moneyLabel.position = CGPoint(x: scene.frame.width / 2 - moneyLabel.frame.width / 2 - 10, y: (scene.frame.height + scene.frame.width) / 4 + scene.frame.height / 32)
        }
        else {
            moneyLabel.position = CGPoint(x: scene.frame.width / 2 - moneyLabel.frame.width / 2 - 10, y: (scene.frame.height + scene.frame.width) / 4 + scene.frame.height / 16)
        }
        scene.addChild(moneyLabel)
        
        upgradeButton.position = CGPoint(x: 0, y: 0)
        upgradeButton.size = CGSize(width: scene.frame.width / 2, height: scene.frame.width / 2)
        scene.addChild(upgradeButton)
    }
    
    func getCost() -> Int {
        return 1000
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

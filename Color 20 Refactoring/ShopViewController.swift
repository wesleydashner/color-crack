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
    let backButton = SKSpriteNode(imageNamed: "back")
    let startLevelLabel = SKLabelNode()
    let upgradeCostLabel = SKLabelNode()
    let notificationGenerator = UINotificationFeedbackGenerator()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = self.view as! SKView?
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .aspectFit
        view?.presentScene(scene)
        view?.ignoresSiblingOrder = true
        
        moneyLabel.text = "$\(UserDefaults.standard.integer(forKey: "money"))"
        moneyLabel.fontSize = 20
        moneyLabel.fontColor = .yellow
        moneyLabel.fontName = "Nexa Bold"
        if UIDevice.current.userInterfaceIdiom == .pad {
            moneyLabel.fontSize = 40
            moneyLabel.position = CGPoint(x: scene.frame.width / 2 - moneyLabel.frame.width / 2 - 10, y: (scene.frame.height + scene.frame.width) / 4 + scene.frame.height / 32)
        }
        else {
            moneyLabel.position = CGPoint(x: scene.frame.width / 2 - moneyLabel.frame.width / 2 - 10, y: (scene.frame.height + scene.frame.width) / 4 + scene.frame.height / 16)
        }
        scene.addChild(moneyLabel)
        
        upgradeButton.position = CGPoint(x: 0, y: 0)
        upgradeButton.size = CGSize(width: scene.frame.width / 2, height: scene.frame.width / 2)
        scene.addChild(upgradeButton)
        
        backButton.size = CGSize(width: moneyLabel.frame.height, height: moneyLabel.frame.height)
        if UIDevice.current.userInterfaceIdiom == .pad {
            backButton.position = CGPoint(x: -scene.frame.width / 2 + backButton.frame.width / 2 + 10, y: (scene.frame.height + scene.frame.width) / 4 + scene.frame.height / 32 + 12)
        }
        else {
            backButton.position = CGPoint(x: -scene.frame.width / 2 + backButton.frame.width / 2 + 10, y: (scene.frame.height + scene.frame.width) / 4 + scene.frame.height / 16 + 6)
        }
        scene.addChild(backButton)
        
        startLevelLabel.text = "START LEVEL: \(UserDefaults.standard.integer(forKey: "startLevel"))"
        startLevelLabel.fontSize = 35
        startLevelLabel.fontColor = .white
        startLevelLabel.fontName = "Nexa Bold"
        startLevelLabel.position = CGPoint(x: 0, y: upgradeButton.frame.height / 2 + startLevelLabel.frame.height / 2)
        scene.addChild(startLevelLabel)
        
        upgradeCostLabel.text = "COST: $\(getCost())"
        upgradeCostLabel.fontSize = 20
        upgradeCostLabel.fontColor = .white
        upgradeCostLabel.fontName = "Nexa Bold"
        upgradeCostLabel.position = CGPoint(x: 0, y: -upgradeButton.frame.height / 2)
        scene.addChild(upgradeCostLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: scene)
            
            if backButton.contains(location) {
                impactGenerator.impactOccurred()
                self.performSegue(withIdentifier: "toMain", sender: self)
            }
            
            if upgradeButton.contains(location) {
                if UserDefaults.standard.integer(forKey: "money") >= getCost() {
                    notificationGenerator.notificationOccurred(.success)
                    UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "money") - getCost(), forKey: "money")
                    UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "startLevel") + 1, forKey: "startLevel")
                    startLevelLabel.text = "START LEVEL: \(UserDefaults.standard.integer(forKey: "startLevel"))"
                    upgradeCostLabel.text = "COST: $\(getCost())"
                    moneyLabel.text = "$\(UserDefaults.standard.integer(forKey: "money"))"
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        moneyLabel.position = CGPoint(x: scene.frame.width / 2 - moneyLabel.frame.width / 2 - 10, y: (scene.frame.height + scene.frame.width) / 4 + scene.frame.height / 32)
                    }
                    else {
                        moneyLabel.position = CGPoint(x: scene.frame.width / 2 - moneyLabel.frame.width / 2 - 10, y: (scene.frame.height + scene.frame.width) / 4 + scene.frame.height / 16)
                    }
                }
                else {
                    notificationGenerator.notificationOccurred(.error)
                }
            }
        }
    }
    
    func getCost() -> Int {
        return 1000
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

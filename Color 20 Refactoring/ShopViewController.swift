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
import GoogleMobileAds

// Actual Ad ID: ca-app-pub-4988685536796370/1078330803
// Test Ad ID: ca-app-pub-3940256099942544/1712485313
//let rewardedVideoID = "ca-app-pub-4988685536796370/1078330803"
let rewardedVideoID = "ca-app-pub-3940256099942544/1712485313"

// Actual Ad ID: ca-app-pub-4988685536796370/8629625562
// Test Ad ID: ca-app-pub-3940256099942544/4411468910
//let interstitialAdID = "ca-app-pub-4988685536796370/8629625562"
let interstitialAdID = "ca-app-pub-3940256099942544/4411468910"

class ShopViewController: UIViewController, GADRewardBasedVideoAdDelegate {
    
    let scene = SKScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let moneyLabel = SKLabelNode()
    let upgradeButton = SKSpriteNode(imageNamed: "upgrade")
    let backButton = SKSpriteNode(imageNamed: "back")
    let startLevelLabel = SKLabelNode()
    let upgradeCostLabel = SKLabelNode()
    let rewardedAdButton = SKLabelNode()
    let notificationGenerator = UINotificationFeedbackGenerator()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        
        let view = self.view as! SKView?
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .aspectFit
        view?.presentScene(scene)
        view?.ignoresSiblingOrder = true
        
        moneyLabel.text = "$\(UserDefaults.standard.integer(forKey: "money"))"
        moneyLabel.fontSize = 25
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
            backButton.position = CGPoint(x: -scene.frame.width / 2 + backButton.frame.width / 2 + 10, y: (scene.frame.height + scene.frame.width) / 4 + scene.frame.height / 16 + 9)
        }
        scene.addChild(backButton)
        
        startLevelLabel.text = "START LEVEL: \(UserDefaults.standard.integer(forKey: "startLevel"))x\(UserDefaults.standard.integer(forKey: "startLevel"))"
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
        
        rewardedAdButton.text = "WATCH AN AD FOR $20"
        rewardedAdButton.color = .white
        rewardedAdButton.fontSize = 25
        rewardedAdButton.fontColor = .yellow
        rewardedAdButton.fontName = "Nexa Bold"
        rewardedAdButton.position = CGPoint(x: 0, y: -scene.frame.height / 2 + rewardedAdButton.frame.height * 4)
        scene.addChild(rewardedAdButton)
        
        func updateRewardedAdButton() {
            if GADRewardBasedVideoAd.sharedInstance().isReady == true {
                rewardedAdButton.fontColor = .yellow
            }
            else {
                rewardedAdButton.fontColor = UIColor(red: 0.3, green: 0.3, blue: 0.0, alpha: 1.0)
            }
        }
        let updateButtonColorForever = SKAction.repeatForever(.sequence([SKAction.run(updateRewardedAdButton), SKAction.wait(forDuration: 0.2)]))
        scene.run(updateButtonColorForever)
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
                    upgradeButton.run(.sequence([.scale(to: 1.2, duration: 0.1), .scale(to: 1, duration: 0.1)]))
                    UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "money") - getCost(), forKey: "money")
                    UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "startLevel") + 1, forKey: "startLevel")
                    startLevelLabel.text = "START LEVEL: \(UserDefaults.standard.integer(forKey: "startLevel"))x\(UserDefaults.standard.integer(forKey: "startLevel"))"
                    upgradeCostLabel.text = "COST: $\(getCost())"
                    updateMoneyLabel()
                }
                else {
                    notificationGenerator.notificationOccurred(.error)
                    upgradeButton.run(.sequence([.move(by: CGVector(dx: -10, dy: 0), duration: 0.05), .move(by: CGVector(dx: 20, dy: 0), duration: 0.1), .move(by: CGVector(dx: -20, dy: 0), duration: 0.1), .move(by: CGVector(dx: 10, dy: 0), duration: 0.05)]))
                }
            }
            
            if rewardedAdButton.contains(location) {
                if GADRewardBasedVideoAd.sharedInstance().isReady == true {
                    impactGenerator.impactOccurred()
                    GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
                }
                else {
                    print("Ad wasn't ready")
                }
            }
        }
    }
    
    func updateMoneyLabel() {
        moneyLabel.text = "$\(UserDefaults.standard.integer(forKey: "money"))"
        if UIDevice.current.userInterfaceIdiom == .pad {
            moneyLabel.position = CGPoint(x: scene.frame.width / 2 - moneyLabel.frame.width / 2 - 10, y: (scene.frame.height + scene.frame.width) / 4 + scene.frame.height / 32)
        }
        else {
            moneyLabel.position = CGPoint(x: scene.frame.width / 2 - moneyLabel.frame.width / 2 - 10, y: (scene.frame.height + scene.frame.width) / 4 + scene.frame.height / 16)
        }
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "money") + 20, forKey: "money")
        updateMoneyLabel()
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: rewardedVideoID)
    }
    
    func getCost() -> Int {
        switch UserDefaults.standard.integer(forKey: "startLevel") {
        case 2:
            return 250
        case 3:
            return 500
        case 4:
            return 750
        default:
            return 1000
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

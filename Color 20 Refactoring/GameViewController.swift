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
import GoogleMobileAds

let colors: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple]
let impactGenerator = UIImpactFeedbackGenerator(style: .light)

class GameViewController: UIViewController, GADInterstitialDelegate {
    
    let scene = SKScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var boardDimension = 2
    var bestDimension = 2
    var scoreLimit = 3
    var score = 0
    var board = Board(x: 2, y: 2)
    let buttons = Buttons(colors: colors)
    let scoreLabel = SKLabelNode()
    let currentLevelLabel = SKLabelNode()
    let bestLevelLabel = SKLabelNode()
    let moneyLabel = SKLabelNode()
    let storeButton = SKSpriteNode(imageNamed: "store")
    var interstitial: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitial = createAndLoadInterstitial()
        
        if loadBoard() != nil {
            board = loadBoard()!
            boardDimension = board.tiles.count
            scoreLimit = getScoreLimit(dimension: boardDimension)
        }
        
        score = UserDefaults.standard.integer(forKey: "currentScore")
        
        if UserDefaults.standard.integer(forKey: "startLevel") == 0 {
            UserDefaults.standard.set(2, forKey: "startLevel")
        }
        
//        UserDefaults.standard.set(2, forKey: "startLevel")
//        UserDefaults.standard.set(2, forKey: "best")
//        UserDefaults.standard.set(0, forKey: "money")
        
        if UserDefaults.standard.integer(forKey: "startLevel") > boardDimension {
            board = Board(x: UserDefaults.standard.integer(forKey: "startLevel"), y: UserDefaults.standard.integer(forKey: "startLevel"))
            boardDimension = UserDefaults.standard.integer(forKey: "startLevel")
            scoreLimit = getScoreLimit(dimension: UserDefaults.standard.integer(forKey: "startLevel"))
            score = 0
        }
    
        let view = self.view as! SKView?
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .aspectFit
        view?.presentScene(scene)
        view?.ignoresSiblingOrder = true
        board.loadBoard(gameScene: scene, widthOfBoard: Int(scene.frame.width))
        buttons.loadButtons(scene: scene)
        
        scoreLabel.text = "\(score) / \(scoreLimit)"
        scoreLabel.fontSize = 50
        scoreLabel.position = CGPoint(x: 0, y: (scene.frame.height + scene.frame.width) / 4)
        scoreLabel.fontName = "Nexa Bold"
        scene.addChild(scoreLabel)
        
        currentLevelLabel.text = "LEVEL: \(boardDimension)x\(boardDimension)"
        currentLevelLabel.fontSize = 25
        currentLevelLabel.position = CGPoint(x: -scene.frame.width / 4, y: scene.frame.width / 2 + currentLevelLabel.fontSize / 2 + 10)
        currentLevelLabel.fontName = "Nexa Bold"
        scene.addChild(currentLevelLabel)
        
        let money = UserDefaults.standard.integer(forKey: "money")
        moneyLabel.text = "$\(money)"
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
        
        storeButton.size = CGSize(width: moneyLabel.frame.height, height: moneyLabel.frame.height)
        if UIDevice.current.userInterfaceIdiom == .pad {
            storeButton.position = CGPoint(x: -scene.frame.width / 2 + storeButton.frame.width / 2 + 10, y: (scene.frame.height + scene.frame.width) / 4 + scene.frame.height / 32 + 12)
        }
        else {
            storeButton.position = CGPoint(x: -scene.frame.width / 2 + storeButton.frame.width / 2 + 10, y: (scene.frame.height + scene.frame.width) / 4 + scene.frame.height / 16 + 9)
        }
        scene.addChild(storeButton)
        
        if UserDefaults.standard.integer(forKey: "best") > 0 {
            bestDimension = UserDefaults.standard.integer(forKey: "best")
        }
        else {
            UserDefaults.standard.set(2, forKey: "best")
            bestDimension = 2
        }
        
        bestLevelLabel.text = "BEST: \(bestDimension)x\(bestDimension)"
        bestLevelLabel.fontSize = 25
        bestLevelLabel.position = CGPoint(x: scene.frame.width / 4, y: scene.frame.width / 2 + bestLevelLabel.fontSize / 2 + 10)
        bestLevelLabel.fontName = "Nexa Bold"
        scene.addChild(bestLevelLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: scene)
            
            if storeButton.contains(location) {
                impactGenerator.impactOccurred()
                self.performSegue(withIdentifier: "toShop", sender: self)
            }
            
            for color: UIColor in colors {
                if buttons.getButton(ofColor: color).sprite.contains(location) {
                    // if user wins this level
                    if board.isFilled() {
                        impactGenerator.impactOccurred()
                        updateMoneyValueAndLabel(value: UserDefaults.standard.integer(forKey: "money") + boardDimension)
                        if boardDimension >= 9 && boardDimension % 3 == 0 {
                            showAd()
                        }
                        boardDimension += 1
                        scoreLimit = getScoreLimit(dimension: boardDimension)
                        resetBoard(dimension: boardDimension, topRightColor: color)
                        board.animateCapturedTiles()
                        setScoreAndLabel(score: 0)
                        updateLevelAndBest(newDimension: boardDimension)
                    }
                    // if user loses this level
                    else if score == scoreLimit {
                        impactGenerator.impactOccurred()
                        boardDimension = UserDefaults.standard.integer(forKey: "startLevel")
                        scoreLimit = getScoreLimit(dimension: boardDimension)
                        resetBoard(dimension: boardDimension, topRightColor: color)
                        board.animateCapturedTiles()
                        setScoreAndLabel(score: 0)
                        updateLevelAndBest(newDimension: boardDimension)
                    }
                    // else it's just a regular move (make sure it's not the current color)
                    else if color != board.tiles[0][0].sprite.color {
                        impactGenerator.impactOccurred()
                        buttons.getButton(ofColor: color).buttonTapped(board: board)
                        board.animateCapturedTiles()
                        setScoreAndLabel(score: score + 1)
                    }
                    UserDefaults.standard.set(score, forKey: "currentScore")
                    saveBoard(board: board)
                }
            }
        }
    }
    
    func resetBoard(dimension: Int, topRightColor: UIColor) {
        board.disconnect()
        board = Board(x: dimension, y: dimension, topRightColor: topRightColor)
        board.loadBoard(gameScene: scene, widthOfBoard: Int(scene.frame.width))
    }
    
    func setScoreAndLabel(score: Int) {
        self.score = score
        scoreLabel.text = "\(score) / \(scoreLimit)"
    }
    
    func updateLevelAndBest(newDimension: Int) {
        bestDimension = UserDefaults.standard.integer(forKey: "best")
        if newDimension > bestDimension {
            bestDimension = newDimension
            UserDefaults.standard.set(bestDimension, forKey: "best")
            bestLevelLabel.text = "BEST: \(newDimension)x\(newDimension)"
        }
        currentLevelLabel.text = "LEVEL: \(newDimension)x\(newDimension)"
    }
    
    func getScoreLimit(dimension: Int) -> Int {
        if dimension <= 10 {
            return dimension * 2
        }
        else if dimension <= 19 {
            return dimension * 2 - 1
        }
        else if dimension <= 27 {
            return dimension * 2 - 2
        }
        else if dimension <= 34 {
            return dimension * 2 - 3
        }
        else if dimension <= 40 {
            return dimension * 2 - 4
        }
        else if dimension <= 45 {
            return dimension * 2 - 5
        }
        else if dimension <= 49 {
            return dimension * 2 - 6
        }
        else if dimension <= 52 {
            return dimension * 2 - 7
        }
        else if dimension <= 54 {
            return dimension * 2 - 8
        }
        else {
            return 100 + (dimension - 54)
        }
    }
    
    private func saveBoard(board: Board) {
        NSKeyedArchiver.archiveRootObject(board, toFile: Board.ArchiveURL.path)
    }
    
    private func loadBoard() -> Board? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Board.ArchiveURL.path) as? Board
    }
    
    func updateMoneyValueAndLabel(value: Int) {
        UserDefaults.standard.set(value, forKey: "money")
        moneyLabel.text = "$\(value)"
        if UIDevice.current.userInterfaceIdiom == .pad {
            moneyLabel.position = CGPoint(x: scene.frame.width / 2 - moneyLabel.frame.width / 2 - 10, y: (scene.frame.height + scene.frame.width) / 4 + scene.frame.height / 32)
        }
        else {
            moneyLabel.position = CGPoint(x: scene.frame.width / 2 - moneyLabel.frame.width / 2 - 10, y: (scene.frame.height + scene.frame.width) / 4 + scene.frame.height / 16)
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: interstitialAdID)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
    func showAd() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
        else {
            print("Ad wasn't ready")
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

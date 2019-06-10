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
    var crop = SKCropNode()
    let tutorialText = SKLabelNode()
    var tutorialIndex = 0

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
        
//        UserDefaults.standard.set(false, forKey: "hasCompletedTutorial")
        if !UserDefaults.standard.bool(forKey: "hasCompletedTutorial") {
            doTutorialItem(withIndex: 0)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if !UserDefaults.standard.bool(forKey: "hasCompletedTutorial") {
                impactGenerator.impactOccurred()
                removeHighlightAndLabel()
                tutorialIndex += 1
                if tutorialIndex != 8 {
                    doTutorialItem(withIndex: tutorialIndex)
                }
                else {
                    UserDefaults.standard.set(true, forKey: "hasCompletedTutorial")
                }
            }
            
            else {
                let location = t.location(in: scene)
                
                if storeButton.contains(location) {
                    impactGenerator.impactOccurred()
                    self.performSegue(withIdentifier: "toShop", sender: self)
                }
                
                for color: UIColor in colors {
                    if buttons.getButton(ofColor: color).sprite.contains(location) {
                        // if user wins this level
                        if board.isFilled() {
                            if !UserDefaults.standard.bool(forKey: "hasCompletedTutorial") {
                                doTutorialItem(withIndex: 8)
                            }
                            else {
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
        switch dimension {
        case 2...10:
            return dimension * 2
        case 11...12:
            return dimension * 2 - 1
        case 13...14:
            return dimension * 2 - 2
        case 15...16:
            return dimension * 2 - 3
        case 16...17:
            return dimension * 2 - 4
        case 18...19:
            return dimension * 2 - 5
        default:
            return 14 + dimension
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
    
    func highlightSprite(sprite: SKNode) {
        crop = SKCropNode()
        
        let fullScreen = SKSpriteNode(color: .black, size: scene.frame.size)
        fullScreen.alpha = 0.9
        
        let highlightedArea = SKShapeNode(rectOf: CGSize(width: sprite.frame.width * 1.1, height: sprite.frame.height * 1.2), cornerRadius: 10)
        highlightedArea.fillColor = .white
        highlightedArea.alpha = 0.01
        highlightedArea.lineWidth = 0
        highlightedArea.position = CGPoint(x: sprite.position.x, y: sprite.position.y + sprite.frame.height / 2 - 1)
        
        if sprite == storeButton {
            highlightedArea.position.y -= storeButton.frame.height / 2
        }
        else if sprite == scoreLabel || sprite == moneyLabel {
            highlightedArea.position.y -= sprite.frame.height / 8
        }
        
        highlightedArea.blendMode = .replace
        fullScreen.addChild(highlightedArea)
        
        let mask = generateMaskNode(from: fullScreen)
        
        crop.addChild(fullScreen)
        crop.maskNode = mask
        
        crop.zPosition = 2
        scene.addChild(crop)
    }
    
    // https://stackoverflow.com/questions/47759584/swift-spritekit-inverse-masking-doesnt-work-on-device-but-works-in-simulator
    func generateMaskNode(from mask:SKNode) -> SKNode {
        var returningNode : SKNode!
        autoreleasepool {
                let view = SKView()
                let texture = view.texture(from: mask)
                let node = SKSpriteNode(texture:texture)
                let texture2 = view.texture(from: node)
                returningNode = SKSpriteNode(texture:texture2)
                
        }
        return returningNode
    }
    
    func addTutorialText(text: String) {
        tutorialText.fontName = "Nexa Bold"
        tutorialText.fontSize = 28
        tutorialText.numberOfLines = 0
        tutorialText.preferredMaxLayoutWidth = scene.frame.width * 0.9
        tutorialText.text = text
        tutorialText.zPosition = 3
        tutorialText.horizontalAlignmentMode = .center
        tutorialText.position = CGPoint(x: 0, y: 0 - tutorialText.frame.height / 2)
        scene.addChild(tutorialText)
    }
    
    func removeHighlightAndLabel() {
        crop.removeFromParent()
        tutorialText.removeFromParent()
    }
    
    func getSpriteAndText(index: Int) -> (SKNode, String) {
        switch index {
        case 0:
            return (SKSpriteNode(), "Welcome to Color Crash. Tap to learn to play in 7 steps.")
        case 1:
            return (buttons.getTransparentSprite(), "(1/7)\nUse these buttons to fill the board.")
        case 2:
            return (scoreLabel, "(2/7)\nThis shows you how many moves you have left to complete the board.")
        case 3:
            return (currentLevelLabel, "(3/7)\nThis is what level you're currently on.")
        case 4:
            return (bestLevelLabel, "(4/7)\nThis is your high score.")
        case 5:
            return (moneyLabel, "(5/7)\nThis is how much money you've earned.")
        case 6:
            return (storeButton, "(6/7)\nYou can use that money in the shop to increase the level you start on.")
        case 7:
            return (buttons.getTransparentSprite(), "(7/7)\nWhen you complete a level, tap any button to continue to the next level.")
        default:
            return (SKSpriteNode(), "ERROR: default reached in getSpriteAndText switch statement.")
        }
    }
    
    func doTutorialItem(withIndex index: Int) {
        let (sprite, text) = getSpriteAndText(index: index)
        highlightSprite(sprite: sprite)
        addTutorialText(text: text)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

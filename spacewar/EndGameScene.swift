import Foundation
import SpriteKit
import GameplayKit
import CoreMotion
import GameKit

class EndGameScene : SKScene
{
    var GameOverLabel:SKLabelNode!
    var gameOverScoreLabel:SKLabelNode!
    var score:Int = 0
    var field:SKSpriteNode!
    var TapToRestartLabel:SKLabelNode!
    var RepeatTimer:Timer!

   
    
    override func didMove(to view: SKView) {
        
       
        
        field = SKSpriteNode(imageNamed:"backgroundblue")
        field.position = CGPoint(x: 0, y:0)
        field.zPosition = -1
        field.setScale(5)
        self.addChild(field)
        
        gameOverScoreLabel = SKLabelNode (text: "Score: \(score)")
        gameOverScoreLabel.fontName = "AmericanTypewriter-Bold"
        gameOverScoreLabel.fontSize = 56
        gameOverScoreLabel.color = UIColor.black
        gameOverScoreLabel.position = CGPoint(x:(UIScreen.main.bounds.width/2), y:(UIScreen.main.bounds.height/2))
        gameOverScoreLabel.zPosition = 1
        self.addChild(gameOverScoreLabel)
        
        
        GameOverLabel = SKLabelNode (text: "Game Over")
        GameOverLabel.fontName = "AmericanTypewriter-Bold"
        GameOverLabel.fontSize = 56
        GameOverLabel.color = UIColor.black
        GameOverLabel.position = CGPoint(x:(UIScreen.main.bounds.width/2), y:(UIScreen.main.bounds.height/2) + 50)
        GameOverLabel.zPosition = 1
        self.addChild(GameOverLabel)
        
        TapToRestartLabel = SKLabelNode (text: "Tap to main menu")
        TapToRestartLabel.fontName = "AmericanTypewriter-Bold"
        TapToRestartLabel.fontSize = 36
        TapToRestartLabel.color = UIColor.black
        TapToRestartLabel.position = CGPoint(x:(UIScreen.main.bounds.width/2), y:(UIScreen.main.bounds.height/2) - 50)
        TapToRestartLabel.zPosition = 1
        self.addChild(TapToRestartLabel)
        
    }
    
    func restart()
    {
         let scene = SKScene(fileNamed: "MainMenu")
        view?.presentScene(scene)
    }
        
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        restart()
    }
    
}

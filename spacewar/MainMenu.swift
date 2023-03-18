import SpriteKit
import GameplayKit
import CoreMotion
import GameKit


class MainMenu: SKScene {

    
    var newGameBtnNode:SKSpriteNode!
    var LevelBtnNode:SKSpriteNode!
    var LevelLabelNode:SKLabelNode!
    var field:SKSpriteNode!
    var gameTimer:Timer!
    var clouds = ["cloud2stroke", "cloud3stroke","cloud9contour","cloud10stroke","cloudstroke","threeclouds"]
    override func didMove(to view: SKView) {

        
        newGameBtnNode = (self.childNode(withName: "NewGameBtn") as! SKSpriteNode)
        LevelBtnNode = (self.childNode(withName: "LevelBtn") as! SKSpriteNode)
        LevelLabelNode = (self.childNode(withName: "LabelBtn") as! SKLabelNode)

        field = SKSpriteNode(imageNamed:"backgroundblue")
        field.position = CGPoint(x: 0, y: 0)
        field.zPosition = -1
        field.setScale(5)
        self.addChild(field)
        
        
        let CloudtimeIntervalMenu = 0.33
        
        gameTimer = Timer.scheduledTimer(timeInterval: CloudtimeIntervalMenu, target: self, selector:   #selector(addClouds), userInfo: nil, repeats: true)
        
        
        let UserLevel = UserDefaults.standard
       if UserLevel.bool(forKey: "hardcore")
        {
            LevelLabelNode.text = "Hardcore"
        } else
        {
            LevelLabelNode.text = "Easy"
        }

    
    }
    

    
    
    func changeLvl()
    {
        let userLvl = UserDefaults.standard
        
        if LevelLabelNode.text == "Easy"
        {
            LevelLabelNode.text = "Hardcore"
            userLvl.set(true, forKey: "hardcore")
            
        } else
        {
            LevelLabelNode.text = "Easy"
            userLvl.set(false, forKey: "hardcore")
        }
        userLvl.synchronize()
    }
    

         override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let touch = touches.first
        
        if let location = touch?.location(in: self)
        {
            let nodesArray = self.nodes(at: location)
            
            
            if nodesArray.first?.name == "NewGameBtn"
            {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: UIScreen.main.bounds.size)
                self.view?.presentScene(gameScene, transition: transition)
            } else if nodesArray.first?.name == "LevelBtn"
            {
                changeLvl()
            }
         
        }
    }

    
    @objc func addClouds()
    {
        clouds = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: clouds) as! [String]
        let MenuCloud = SKSpriteNode(imageNamed: clouds[0])
        
        let randomPos = GKRandomDistribution(lowestValue: 20, highestValue: Int(UIScreen.main.bounds.size.width - 20))
        let pos = CGFloat(randomPos.nextInt())
        MenuCloud.position = CGPoint(x: pos, y: UIScreen.main.bounds.size.height + MenuCloud.size.height)
        MenuCloud.zPosition = -1
        self.addChild(MenuCloud)
        
        
        let animDuration:TimeInterval = 5
        var actions  = [SKAction]()
        
        actions.append(SKAction.move(to: CGPoint(x: pos, y:0 - MenuCloud.size.height), duration: animDuration))
        actions.append(SKAction.removeFromParent())
        MenuCloud.run(SKAction.sequence(actions))
        
    }
}


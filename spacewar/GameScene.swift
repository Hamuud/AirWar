import SpriteKit
import GameplayKit
import CoreMotion
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var field:SKSpriteNode!
    var player:SKSpriteNode!
    var scoreLabel:SKLabelNode!
    var heartsLabel:SKLabelNode!
    var heart:SKSpriteNode!
    public var score:Int = 0
    var heartsCount:Int = 3
    var aliens = ["Gray", "Bluejet" ,"jet"]
    var clouds = ["cloud2stroke", "cloud3stroke","cloud9contour","cloud10stroke","cloudstroke","threeclouds"]

    {
        didSet
        {
            heartsLabel.text = "\(heartsCount)"
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var gameTimer:Timer!
    let alienCategory:UInt32 = 0x1 << 1
    let bulletCategory:UInt32 = 0x1 << 0
    let playerCategory:UInt32 = 0x1 << 2
    
    let MotionManager =  CMMotionManager()
    var xAccelerate:CGFloat = 0
    var addobjects = 1
    var addAliens = 1
    override func didMove(to view: SKView) {
 
        
        
        
        field = SKSpriteNode(imageNamed:"backgroundblue")
        field.position = CGPoint(x: 0, y:0)
        field.zPosition = -1
        field.setScale(5)
        self.addChild(field)
        
        //____________ PLAYER ____________
        
        player = SKSpriteNode(imageNamed: "Ghost")
        player.position = CGPoint(x: UIScreen.main.bounds.width/2, y:120)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.contactTestBitMask = alienCategory
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(player)
        
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        //____________ SCORE ____________
        
        scoreLabel = SKLabelNode (text: "Score: \(score)")
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 36
        scoreLabel.color = UIColor.white
        scoreLabel.position = CGPoint(x: UIScreen.main.bounds.width - 100, y: UIScreen.main.bounds.height - 75)
        score = 0
        self.addChild(scoreLabel)
        
        //____________ HEART ____________
        
        heart = SKSpriteNode(imageNamed: "hearts")
        heart.position = CGPoint(x: UIScreen.main.bounds.width/5, y: 70)
        self.addChild(heart)
        
        heartsLabel = SKLabelNode(text: "3")
        heartsLabel.fontName = "AmericanTypewriter-Bold"
        heartsLabel.fontSize = 56
        heartsLabel.color = UIColor.white
        heartsLabel.position = CGPoint(x: (UIScreen.main.bounds.width/5) - 50, y: 50)
        heartsCount = 3
        self.addChild(heartsLabel)
        heartsLabel.zPosition = 1
        

        //____________ DIFFICULTY ____________
        
        var timeInterval = 0.5
        var CloudtimeInterval = 1.5
        if UserDefaults.standard.bool(forKey: "hardcore")
        {
            timeInterval = 0.35
            heartsCount = 0
            CloudtimeInterval = 0.75
            
        }
        
        gameTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector:   #selector(addAlien), userInfo: nil, repeats: true)
        
        gameTimer = Timer.scheduledTimer(timeInterval: CloudtimeInterval, target: self, selector:   #selector(addCloud), userInfo: nil, repeats: true)
        

        
        //____________ MOTION ____________

        MotionManager.accelerometerUpdateInterval = 0.2
        MotionManager.startAccelerometerUpdates(to: OperationQueue.current! ) { (data:CMAccelerometerData?, error: Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAccelerate = CGFloat(acceleration.x) * 0.75 + self.xAccelerate * 0.25
            }
            
        }

        
        
        
    }
    
    //____________ WIDTH MOTION ____________

    override func didSimulatePhysics()
    {
        player.position.x += xAccelerate * 50
        
        if player.position.x < 0
        {
            player.position = CGPoint(x: UIScreen.main.bounds.width - player.size.width , y: player.position.y)
        }
        else if player.position.x > UIScreen.main.bounds.width
        {
            player.position = CGPoint(x: 20, y:player.position.y)
        }
    }
    
    //____________ OBJECTS CONTACT ____________

    func didBegin(_ contact: SKPhysicsContact) {
        var alienBody:SKPhysicsBody
        var bulletBody:SKPhysicsBody
        var playerBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        {
            bulletBody = contact.bodyA
            alienBody = contact.bodyB
        }
        else {
            bulletBody = contact.bodyB
            alienBody = contact.bodyA
        }
        
        if (alienBody.categoryBitMask & alienCategory) != 0 && (bulletBody.categoryBitMask & bulletCategory ) != 0
        {
            collisionElements(bulletNode: bulletBody.node as! SKSpriteNode, alienNode: alienBody.node as! SKSpriteNode)
        }
        
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask
        {
            playerBody = contact.bodyA
            alienBody = contact.bodyB
        }
        else {
            playerBody = contact.bodyB
            alienBody = contact.bodyA
        }
        
        if (alienBody.categoryBitMask & alienCategory) != 0 && (playerBody.categoryBitMask & playerCategory ) != 0
        {
            collisionPlayerElements(playerNode: playerBody.node as! SKSpriteNode, alienNode: alienBody.node as! SKSpriteNode)
        }

    }
    
    //____________ CollisionPlayerElements ____________

    func collisionPlayerElements (playerNode:SKSpriteNode,alienNode:SKSpriteNode)
    {
        let explosion = SKEmitterNode(fileNamed: "Vzriv")
        explosion?.position = alienNode.position
        self.addChild( explosion! )
        
        self.run(SKAction.playSoundFileNamed("vzriv.mp3", waitForCompletion: false))
        if heartsCount == 0 {
        playerNode.removeFromParent()
            StopGame()
        }
        alienNode.removeFromParent()
        self.run(SKAction.wait(forDuration: 2))
        {
            explosion?.removeFromParent()
            
        }
        heartsCount -= 1
    }
 
    //____________ CollisionElements ____________

    func collisionElements(bulletNode:SKSpriteNode, alienNode:SKSpriteNode)
    {
        let explosion = SKEmitterNode(fileNamed: "Vzriv")
        explosion?.position = alienNode.position
        self.addChild( explosion! )
        
        self.run(SKAction.playSoundFileNamed("vzriv.mp3", waitForCompletion: false))
        bulletNode.removeFromParent()
        alienNode.removeFromParent()
        
        
        self.run(SKAction.wait(forDuration: 2))
        {
            explosion?.removeFromParent()
        }
        score += 5
    }
    
    //____________ ADD ALIEN ____________
    
    @objc func addAlien()
    {
        if addAliens == 0
        {
        }
        else
        {
        aliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: aliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: aliens[0])
        let randomPos = GKRandomDistribution(lowestValue: 20, highestValue: Int(UIScreen.main.bounds.size.width - 20))
        let pos = CGFloat(randomPos.nextInt())
        alien.position = CGPoint(x: pos, y: UIScreen.main.bounds.size.height + alien.size.height)
        
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = bulletCategory
        alien.physicsBody?.collisionBitMask = 0
        self.addChild(alien)
        
        let animDuration:TimeInterval = 6
        var actions  = [SKAction]()
        
        actions.append(SKAction.move(to: CGPoint(x: pos, y:0 - alien.size.height), duration: animDuration))
        actions.append(SKAction.removeFromParent())
        alien.run(SKAction.sequence(actions))
        
        }
    }
    //____________ TouchesEnded ____________
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if heartsCount >= 0
        {
        fireBullet()
        }

    }
    
    //____________ FIRE BULLET ____________

    
    func fireBullet() {
        self.run(SKAction.playSoundFileNamed("bullet.mp3", waitForCompletion: false))
        
        let bullet = SKSpriteNode(imageNamed: "torpedo")
        bullet.position = player.position
        bullet.position.y += 45
        
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        bullet.physicsBody?.isDynamic = true
        
        bullet.physicsBody?.categoryBitMask = bulletCategory
        bullet.physicsBody?.contactTestBitMask = alienCategory
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(bullet)
        
        
        let animDuration:TimeInterval = 0.55
        
        var actions  = [SKAction]()
        actions.append(SKAction.move(to: CGPoint(x: player.position.x, y: UIScreen.main.bounds.size.height + bullet.size.height), duration: animDuration))
        actions.append(SKAction.removeFromParent())
        
        bullet.run(SKAction.sequence(actions))
    }
    
    
    //____________ GAME OVER ____________
    
    func StopGame()
    {
        let transitionl = SKTransition.fade(withDuration: 0.5)
        let endScene = EndGameScene()
        endScene.score = score
        endScene.size = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        addobjects = 0
        addAliens = 0
        self.view?.presentScene(endScene, transition:transitionl)
        

    }
    

    //____________ ADD CLOUD ____________

    @objc func addCloud()
    {
        if addobjects == 0
        {
        }
        else {
        
        clouds = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: clouds) as! [String]
        let cloud = SKSpriteNode(imageNamed: clouds[0])
        
        let randomPos = GKRandomDistribution(lowestValue: 20, highestValue: Int(UIScreen.main.bounds.size.width - 20))
        let pos = CGFloat(randomPos.nextInt())
        cloud.position = CGPoint(x: pos, y: UIScreen.main.bounds.size.height + cloud.size.height)
        cloud.zPosition = 3
        self.addChild(cloud)
        
        
        let animDuration:TimeInterval = 6
        var actions  = [SKAction]()
        
        actions.append(SKAction.move(to: CGPoint(x: pos, y:0 - cloud.size.height), duration: animDuration))
        actions.append(SKAction.removeFromParent())
        cloud.run(SKAction.sequence(actions))
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}

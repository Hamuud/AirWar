//
//  GameOver.swift
//  spacewar
//
//  Created by Артем Лясковець on 24.11.2021.
//

import Foundation
import SpriteKit
class GameOver {
    enum SceneType{
        case MainMenu, GameScene
    }
    func transition(_ fromScene: SKScene, toScene: SceneType) {
        guard let scene = GetScene(toScene) else { return }
        scene.scaleMode = .resizeFill
        fromScene.view?.presentScene(scene)
    }
    
    
    func GetScene(_ sceneType: SceneType) -> SKScene? {
        switch sceneType {
        case SceneType.MainMenu:
            return MainMenu(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        case SceneType.GameScene:
            return GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        }
    }
}

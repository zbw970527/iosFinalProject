//
//  GameViewController.swift
//  BubbleWarV1
//
//  Created by Junzhang Wang on 4/15/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVKit

protocol SoccerExitDelegate{
    func exitToMenu() -> Void
    func stopMusic() -> Void
}

class SoccerViewController: UIViewController, SoccerExitDelegate {

    
    var audioPlayer:AVAudioPlayer!
    var playMusicDelegate : PlayMusicDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playMusicDelegate?.stopBGM()
        loadSoccerGame()
    }
    
    func loadSoccerGame(){
        if let scene = GKScene(fileNamed: "SoccerGameScene") {
            // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
            // including entities and graphs.
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! SoccerGameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                sceneNode.soccerExitDelegate = self
                
                // Present the scene
                if let view = self.view as! SKView? {
                    let transition = SKTransition.reveal(with: .up, duration: 0.75)
                    view.presentScene(sceneNode, transition: transition)
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
        //play the background
        let audioFileLocationURL1 = Bundle.main.url(forResource: "background", withExtension: "mp3")
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileLocationURL1!)
            audioPlayer.numberOfLoops = -1
            audioPlayer.play()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func stopMusic() {
        audioPlayer.stop()
    }
    
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func exitToMenu(){
        playMusicDelegate?.playBGM()
        self.dismiss(animated: true, completion: nil)
    }
}

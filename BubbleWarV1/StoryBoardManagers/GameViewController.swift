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

protocol ExitDelegate{
    func exitToMenu() -> Void
    func stopMusic() -> Void
}

class GameViewController: UIViewController, ExitDelegate {

    
    var audioPlayer:AVAudioPlayer!
    var playMusicDelegate : PlayMusicDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var forest: UIButton!
    @IBOutlet weak var mine: UIButton!
    @IBOutlet weak var sea: UIButton!
    @IBOutlet weak var camp: UIButton!
    @IBOutlet weak var cemetery: UIButton!
    @IBOutlet weak var ice: UIButton!
    
    
    
    @IBOutlet weak var map_selection_bg: UIImageView!
    
    @IBOutlet weak var picForest: UIImageView!
    @IBOutlet weak var picMine: UIImageView!
    @IBOutlet weak var picSea: UIImageView!
    @IBOutlet weak var picCamp: UIImageView!
    @IBOutlet weak var picCemetery: UIImageView!
    @IBOutlet weak var picIce: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadGame(map: String){
        forest.isHidden = true
        mine.isHidden = true
        sea.isHidden = true
        camp.isHidden = true
        cemetery.isHidden = true
        ice.isHidden = true
        
        picForest.isHidden = true
        picMine.isHidden = true
        picSea.isHidden = true
        picCamp.isHidden = true
        picCemetery.isHidden = true
        picIce.isHidden = true
        
        map_selection_bg.isHidden = true
        titleLabel.isHidden = true
        
        if let scene = GKScene(fileNamed: map) {
            // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
            // including entities and graphs.
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                sceneNode.exitDelegate = self
                
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
    
    @IBAction func forestPressed(_ sender: Any) {
        print("load forest")
        let map = "RegularGameScene1"
        playMusicDelegate?.stopBGM()
        loadGame(map: map)
    }
    @IBAction func minePressed(_ sender: Any) {
        print("load mine")
        let map = "RegularGameScene2"
        playMusicDelegate?.stopBGM()
        loadGame(map: map)
    }
    @IBAction func seaPressed(_ sender: Any) {
        print("load sea")
        let map = "RegularGameScene3"
        playMusicDelegate?.stopBGM()
        loadGame(map: map)
    }
    @IBAction func campPressed(_ sender: Any) {
        print("load camp")
        let map = "RegularGameScene4"
        playMusicDelegate?.stopBGM()
        loadGame(map: map)
    }
    @IBAction func cemeteryPressed(_ sender: Any) {
        print("load cemetery")
        let map = "RegularGameScene5"
        playMusicDelegate?.stopBGM()
        loadGame(map: map)
    }
    
    @IBAction func icePressed(_ sender: Any) {
        print("load ice")
        let map = "RegularGameScene6"
        playMusicDelegate?.stopBGM()
        loadGame(map: map)
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

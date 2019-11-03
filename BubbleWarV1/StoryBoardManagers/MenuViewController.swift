//
//  MenuViewController.swift
//  BubbleWarV1
//
//  Created by Bowen Zhang on 4/23/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import AVKit

protocol PlayMusicDelegate{
    func playBGM() -> Void
    func stopBGM() -> Void
}

class MenuViewController: UIViewController, PlayMusicDelegate {
    
    var audioPlayer:AVAudioPlayer!;
    
    @IBOutlet weak var regularButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playBGM()
    }
    
    
    @IBAction func regularPressed(_ sender: Any) {
        //audioPlayer.stop()
    }
    
    
    func playBGM(){
        //play the background
        let audioFileLocationURL1 = Bundle.main.url(forResource: "bg1", withExtension: "mp3")
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileLocationURL1!)
            audioPlayer.numberOfLoops = -1
            audioPlayer.play()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func stopBGM(){
        audioPlayer.stop()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "regularGame"{
            let gameViewController: GameViewController = segue.destination as! GameViewController
            gameViewController.playMusicDelegate = self
        }
        if segue.identifier == "soccerGame"{
            let soccerViewController: SoccerViewController = segue.destination as! SoccerViewController
            soccerViewController.playMusicDelegate = self
        }
    }
    
    
    
}

//
//  ControllerComponent.swift
//  BubbleWarV1
//
//  Created by Junzhang Wang on 4/16/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import SpriteKit
import GameplayKit

/*
 * Linked to the player entity in the Gamescene
 */
class ControllerComponent : GKComponent, ControlInputHandler{
    
    // delegates that enable controller component to execute the messages received from the controller node
    var moveDelegate : MoveDelegate? // assigned to GameScene
    var deployDelegate : DeployBubbleDelegate? // assigned to GameScene
    
    // controller node
    var controlNode : Controller?
    
    // player in the game scene
    var player : Player?
    
    // the below function is going to be called from the scene
    func setUpControls(camera: SKCameraNode, scene: SKScene){
        controlNode = Controller(frame: scene.frame)
        controlNode?.inputHandler = self
        
        // make sure it's centered in the camera
        controlNode?.position = CGPoint.zero
        
        camera.addChild(controlNode!)
        
        if (player == nil){
            if let nodeComponent = self.entity?.component(ofType: GKSKNodeComponent.self){
                player = nodeComponent.node as? Player
            }
        }
    }
    
    /*
     * Execute corresponding functions in the delegate based on the messages it received
     */
    func follow(command: String?) {
        if (player != nil){
            switch(command!){
            case "left" :
                print("command: \(String(describing: command))")
                //moveDelegate?.move(direction: .Left)
                moveDelegate?.movingLeft = true
            case "right" :
                print("command: \(String(describing: command))")
                //moveDelegate?.move(direction: .Right)
                moveDelegate?.movingRight = true
            case "up" :
                print("command: \(String(describing: command))")
                //moveDelegate?.move(direction: .Up)
                moveDelegate?.movingUp = true
            case "down":
                print("command: \(String(describing: command))")
                //moveDelegate?.move(direction: .Down)
                moveDelegate?.movingDown = true
            case "stop left", "cancel left":
                print("command: \(String(describing: command))")
                moveDelegate?.movingLeft = false
            case "stop right", "cancel right":
                print("command: \(String(describing: command))")
                moveDelegate?.movingRight = false
            case "stop up", "cancel up":
                print("command: \(String(describing: command))")
                moveDelegate?.movingUp = false
            case "stop down", "cancel down":
                print("command: \(String(describing: command))")
                moveDelegate?.movingDown = false
            case "deploy":
                print("command: \(String(describing: command))")
                deployDelegate?.deploy()
            case "exit":
                print("command: \(String(describing: command))")
                deployDelegate?.exitToMenu()
            default:
                print("command: \(String(describing: command))")
            }
        }
    }
    
}

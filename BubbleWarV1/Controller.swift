//
//  Controller.swift
//  BubbleWarV1
//
//  Created by Junzhang Wang on 4/16/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import SpriteKit

class Controller : SKSpriteNode{
    
    // transparency of the button
    var alphaUnpressed : CGFloat = 0.5
    var alphaPressed : CGFloat = 0.9
    
    // the list that keeps track of the currently pressed buttons
    var pressedButtons = [SKSpriteNode]()
    
    // all the five controll buttons in this game
    let upButton = SKSpriteNode(imageNamed: "up")
    let leftButton = SKSpriteNode(imageNamed: "left")
    let rightButton = SKSpriteNode(imageNamed: "right")
    let downButton = SKSpriteNode(imageNamed: "down")
    let deployButton = SKSpriteNode(imageNamed: "deploy")
    
    // exit (menu) button
    let exitButton = SKSpriteNode(imageNamed: "exit")
    
    // the handler that sends corresponding message to the console for the sake of keep tracking of the code
    var inputHandler: ControlInputHandler? // allow us to handle all the information that we send
    
    // init the controller node
    init(frame: CGRect){
        super.init(texture: nil, color: UIColor.clear, size: frame.size)
        setUpControls(size: frame.size)
        isUserInteractionEnabled = true // enable user interaction
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // set up the buttons on the screen
    func setUpControls(size: CGSize){
        addButton(button: upButton, position: CGPoint(x: -(size.width) / 2.5 + 20, y:-size.height / 4 + 60), name: "up", scale: 1.8)
        addButton(button: leftButton, position: CGPoint(x: -(size.width) / 2.5 - 50, y:-size.height / 4 - 10), name: "left", scale: 1.8)
        addButton(button: downButton, position: CGPoint(x: -(size.width) / 2.5 + 20, y:-size.height / 4 - 75), name: "down", scale: 1.8)
        addButton(button: rightButton, position: CGPoint(x: -(size.width) / 2.5 + 90, y:-size.height / 4 - 10), name: "right", scale: 1.8)
        addButton(button: deployButton, position: CGPoint(x: (size.width) / 3 + 70, y: -size.height / 3 + 30), name: "deploy", scale: 1.3)
        addButton(button: exitButton, position: CGPoint(x: (size.width) / 2 - 30, y: size.height / 2 - 30), name: "exit", scale: 0.03)
    }
    
    // function for adding a button
    func addButton(button: SKSpriteNode, position: CGPoint, name: String, scale: CGFloat){
        button.position = position
        button.setScale(scale)
        button.name = name
        button.zPosition = 35
        button.alpha = alphaUnpressed
        self.addChild(button)
    }
    
    //////////////////////////////////////////// Below are the codes that handle touches ////////////////////////////////
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // print("touchesBegan")
        for touch in touches {
            // get the location of this touch from the camera
            let location = touch.location(in: parent!)
            
            // check if any of the buttons is being pressed
            for button in [upButton, leftButton, downButton, rightButton, deployButton, exitButton]{
                // if the button is being pressed and the button is not on the list (i.e. if this is a new press)
                if button.contains(location) && pressedButtons.index(of: button) == nil {
                    // we add the button to the pressed button list
                    pressedButtons.append(button)
                    // send message
                    if (inputHandler != nil) {
                        inputHandler?.follow(command: button.name)
                    }
                }
                // change the transparancy of the button
                if(pressedButtons.index(of: button) != nil){
                    button.alpha = alphaPressed
                } else{
                    button.alpha = alphaUnpressed
                }
            }
        }
        // print("End touchesBegan")
    }
    

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("touchesMoved")
        for touch in touches{
            // get the location of touches from the camera
            let location = touch.location(in: parent!)
            let previousLocation = touch.previousLocation(in: parent!)
            
            // check if any of the button is being touched
            for button in [upButton, leftButton, downButton, rightButton, deployButton, exitButton]{
                // if the button is being pressed both now and previously (i.e. the button is being pressed continuously)
                if button.contains(previousLocation) && (button.contains(location)){
                    inputHandler?.follow(command: button.name)
                }
                // if the user moves off the button where he/she was on before
                else if button.contains(previousLocation) && (!button.contains(location)){
                    let index = pressedButtons.index(of: button)
                    // if the button is in the list
                    if index != nil{
                        // we remove the button from the list
                        pressedButtons.remove(at: index!)
                        // send the message
                        if (inputHandler != nil){
                            inputHandler?.follow(command: "cancel \(String(describing: button.name!))")
                        }
                    }
                }
                    
                // if the user pressed somewhere else before and presses the button now and the button is not in the list
                else if !button.contains(previousLocation) && button.contains(location) && pressedButtons.index(of: button) == nil{
                    // we add the button to the list
                    pressedButtons.append(button)
                    // send message
                    if (inputHandler != nil){
                        inputHandler?.follow(command: button.name!)
                    }
                }
                
                // change the transparancy of the button
                if(pressedButtons.index(of: button) != nil){
                    button.alpha = alphaPressed
                } else{
                    button.alpha = alphaUnpressed
                }
            }
        }
    }
    
    /*
     * handles touch terminations
     */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // print("touchesEnded")
        touchUp(touches: touches, withEvent: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // print("touchesCancelled")
        touchUp(touches: touches, withEvent: event)
    }
    
    /*
     * when the user moves his/her finger off from a particular point on the screen
     */
    func touchUp(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        // print("touchUp")
        for touch in touches!{
            // get the location of touches from the camera
            let location = touch.location(in: parent!)
            let previousLocation = touch.previousLocation(in: parent!)
            
            for button in [upButton, leftButton, downButton, rightButton, deployButton, exitButton]{
                // check if the button is previously being pressed but not any more
                if button.contains(location) || button.contains(previousLocation){
                    let index = pressedButtons.index(of: button)
                    // if the button is in the list
                    if index != nil{
                        // then remove the button from the list
                        pressedButtons.remove(at: index!)
                        // send message
                        if inputHandler != nil{
                            inputHandler?.follow(command: "stop \(String(describing: button.name!))")
                        }
                    }
                }
            
                // change the transparancy of the button
                if(pressedButtons.index(of: button) != nil){
                    button.alpha = alphaPressed
                } else{
                    button.alpha = alphaUnpressed
                }
            }
        }
    }
    
    /////////////////////////////////////// End of the codes that handle touches ////////////////////////////////////
}



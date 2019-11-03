//
//  GameScene.swift
//  BubbleWarV1
//
//  Created by Junzhang Wang on 4/15/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVKit

/////////////////////////////////////// Enum Definitions /////////////////////////////////////////////
enum Direction{
    case Left
    case Right
    case Down
    case Up
}
////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////// Protocols ///////////////////////////////////////////////
protocol MoveDelegate{
    var movingUp : Bool {get set}
    var movingDown : Bool {get set}
    var movingLeft : Bool {get set}
    var movingRight : Bool {get set}
    func move(direction:Direction) -> Void
}

protocol DeployBubbleDelegate{
    func deploy() -> Void
    func exitToMenu() -> Void
}
////////////////////////////////////////////////////////////////////////////////////////////////////


class GameScene: SKScene, MoveDelegate, DeployBubbleDelegate {
    
    var audioPlayer:AVAudioPlayer!
    var exitDelegate : ExitDelegate?

    ///////////////////////////////// Deploying Bubbles & Related Effects ///////////////////////////////
    let fadeOut = SKAction.fadeOut(withDuration: 0.1)
    let fadeIn = SKAction.fadeIn(withDuration: 0.1)
    
    /*
     * function that handles the deploy of bubbles by the game characters
     */
    func deploy() {
        // get the tile set information
        let tileSet = SKTileSet(named: "Classic Map Tile Set")
        
        // obtain the player's position (both pixel position and the tile map position)
        let position = player.position
        let column = obstaclesTileMap.tileColumnIndex(fromPosition: position)
        let row = obstaclesTileMap.tileRowIndex(fromPosition: position)
        let tile = obstaclesTileMap.tileDefinition(atColumn: column, row: row)
        
        // if the tile that the player is standing on is nil (i.e. there's nothing on the ground)
        if tile == nil {
            // if player's current bubble number is greater than 1, then it is okay to deploy bubble
            if (player.bubble_number > 0){
                // deploy the bubble
                
                /////////////////////////// if player can deploy fire bubble ///////////////////////////
                if (self.player.fire > 0){
                    obstaclesTileMap.setTileGroup(tileSet?.tileGroups[53], forColumn: column, row: row)
                    
                    // play the sound
                    let audioFileLocationURL1 = Bundle.main.url(forResource: "placebubble", withExtension: "mp3")
                    do{
                        audioPlayer = try AVAudioPlayer(contentsOf: audioFileLocationURL1!)
                        audioPlayer.play()
                    }catch{
                        print(error.localizedDescription)
                    }
                    
                    // decrease the player's bubble capacity by 1
                    player.bubble_number = player.bubble_number - 1
                    
                    // decrease the player's fire capacity by 1
                    player.fire = player.fire - 1
                    
                    // after 2 seconds, the bubble blasts
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                        self.blast(bubblePosition: position,fire: true)
                    })
                }
                /////////////////////////// if player cannot deploy fire bubble ///////////////////////////
                else{
                    obstaclesTileMap.setTileGroup(tileSet?.tileGroups[3], forColumn: column, row: row)

                    // play the sound
                    let audioFileLocationURL1 = Bundle.main.url(forResource: "placebubble", withExtension: "mp3")
                    do{
                        audioPlayer = try AVAudioPlayer(contentsOf: audioFileLocationURL1!)
                        audioPlayer.play()
                    }catch{
                        print(error.localizedDescription)
                    }
                    
                    // decrease the player's bubble capacity by 1
                    player.bubble_number = player.bubble_number - 1
                    
                    // after 2 seconds, the bubble blasts
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                        self.blast(bubblePosition: position,fire: false)
                    })
                }
            }
        }
    }
    
    /*
     * function that handles the blasts of bubbles deployed by the game characters
     * 'bubblePosition' is the position of the bubble been deployed
     * 'fire' tells whether the bubble is a fire bubble or a regular bubble
     */
    func blast(bubblePosition:CGPoint, fire:Bool){
        // create the action when a player is hurted by the bubble
        let fadeOutAndIn = SKAction.sequence([fadeOut,fadeIn])
        let playerHurtedAction = SKAction.repeat(fadeOutAndIn, count: 3)
        
        // get the tile information that the player currently on
        let playerPosition = player.position
        let playerColumn = obstaclesTileMap.tileColumnIndex(fromPosition: playerPosition)
        let playerRow = obstaclesTileMap.tileRowIndex(fromPosition: playerPosition)
        
        // get the tile information that the robot currently on
        let robotPosition = robot.position
        let robotColumn = obstaclesTileMap.tileColumnIndex(fromPosition: robotPosition)
        let robotRow = obstaclesTileMap.tileRowIndex(fromPosition: robotPosition)
        
        // get the tile set information
        let tileSet = SKTileSet(named: "Classic Map Tile Set")
        
        // get the tile map position of the bubble been deployed
        let column = obstaclesTileMap.tileColumnIndex(fromPosition: bubblePosition)
        let row = obstaclesTileMap.tileRowIndex(fromPosition: bubblePosition)
        
        //////////////////////////////////////// if the bubble is fire ////////////////////////////////////////
        if (fire){
            // blast in the center (i.e. the position where the bubble was deployed)
            let tileContentBeforeBlast = obstaclesTileMap.tileDefinition(atColumn: column, row: row)?.name
            // tileGroups[54] -> fire_blast
            obstaclesTileMap.setTileGroup(tileSet?.tileGroups[54], forColumn: column, row: row)
            // determine if player is affected by the blast of bubble
            if (playerColumn == column && playerRow == row){
                if (player.shield){
                    player.shield = false
                }else{
                    player.health = player.health - 2
                }
                player.run(playerHurtedAction)
            }
            // determine if robot is affected by the blast of bubble
            if (robotColumn == column && robotRow == row){
                if (robot.shield){
                    robot.shield = false
                }else{
                    robot.health = robot.health - 2
                }
                robot.run(playerHurtedAction)
            }
            // transform the tile after 0.2 seconds after blast
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.afterBlastTileTransform(blastedTileColumn: column, blastedTileRow: row, tileContentBeforeBlast: tileContentBeforeBlast)
            })
            //play sound
            let audioFileLocationURL1 = Bundle.main.url(forResource: "explode", withExtension: "mp3")
            
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: audioFileLocationURL1!)
                audioPlayer.play()
            }catch{
                print(error.localizedDescription)
            }
            
            // blast in the up direction
            for rangeIndex in 1...player.power {
                // blast cannot go through obstacles or objects
                if (obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "obstacle" || obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "bubble" ||
                    obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "fire_bubble"){
                    break
                }
                else {
                    let tileContentBeforeBlast = obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name
                    // tileGroups[54] -> fire_blast
                    obstaclesTileMap.setTileGroup(tileSet?.tileGroups[54], forColumn: column+rangeIndex, row: row)
                    
                    // determine if player is affected by the blast of bubble
                    if (playerColumn == column+rangeIndex && playerRow == row){
                        if (player.shield){
                            player.shield = false
                        }else{
                            player.health = player.health - 2
                        }
                        player.run(playerHurtedAction)
                    }
                    if (robotColumn == column+rangeIndex && robotRow == row){
                        if (robot.shield){
                            robot.shield = false
                        }else{
                            robot.health = robot.health - 2
                        }
                        robot.run(playerHurtedAction)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        self.afterBlastTileTransform(blastedTileColumn: column+rangeIndex, blastedTileRow: row, tileContentBeforeBlast: tileContentBeforeBlast)
                    })
                    if (tileContentBeforeBlast == "block"){
                        break
                    }
                }
            }
            
            // blast in the down direction
            for rangeIndex in 1...player.power {
                // blast cannot go through obstacles or objects
                if (obstaclesTileMap.tileDefinition(atColumn: column-rangeIndex, row: row)?.name == "obstacle" || obstaclesTileMap.tileDefinition(atColumn: column-rangeIndex, row: row)?.name == "bubble" ||
                    obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "fire_bubble"){
                    break
                }
                else{
                    let tileContentBeforeBlast = obstaclesTileMap.tileDefinition(atColumn: column-rangeIndex, row: row)?.name
                    // tileGroups[54] -> fire_blast
                    obstaclesTileMap.setTileGroup(tileSet?.tileGroups[54], forColumn: column-rangeIndex, row: row)
                    
                    // determine if player is affected by the blast of bubble
                    if (playerColumn == column-rangeIndex && playerRow == row){
                        if (player.shield){
                            player.shield = false
                        }else{
                            player.health = player.health - 2
                        }
                        player.run(playerHurtedAction)
                    }
                    if (robotColumn == column-rangeIndex && robotRow == row){
                        if (robot.shield){
                            robot.shield = false
                        }else{
                            robot.health = robot.health - 2
                        }
                        robot.run(playerHurtedAction)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        self.afterBlastTileTransform(blastedTileColumn: column-rangeIndex, blastedTileRow: row, tileContentBeforeBlast: tileContentBeforeBlast)
                    })
                    if (tileContentBeforeBlast == "block"){
                        break
                    }
                }
            }
            
            // blast in the right direction
            for rangeIndex in 1...player.power {
                // blast cannot go through obstacles or objects
                if (obstaclesTileMap.tileDefinition(atColumn: column, row: row+rangeIndex)?.name == "obstacle" || obstaclesTileMap.tileDefinition(atColumn: column, row: row+rangeIndex)?.name == "bubble" ||
                    obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "fire_bubble"){
                    break
                }
                else{
                    let tileContentBeforeBlast = obstaclesTileMap.tileDefinition(atColumn: column, row: row+rangeIndex)?.name
                    // tileGroups[54] -> fire_blast
                    obstaclesTileMap.setTileGroup(tileSet?.tileGroups[54], forColumn: column, row: row+rangeIndex)
                    
                    // determine if player is affected by the blast of bubble
                    if (playerColumn == column && playerRow == row+rangeIndex){
                        if (player.shield){
                            player.shield = false
                        }else{
                            player.health = player.health - 2
                        }
                        player.run(playerHurtedAction)
                    }
                    if (robotColumn == column && robotRow == row+rangeIndex){
                        if (robot.shield){
                            robot.shield = false
                        }else{
                            robot.health = robot.health - 2
                        }
                        robot.run(playerHurtedAction)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        self.afterBlastTileTransform(blastedTileColumn: column, blastedTileRow: row+rangeIndex, tileContentBeforeBlast: tileContentBeforeBlast)
                    })
                    if (tileContentBeforeBlast == "block"){
                        break
                    }
                }
            }
            
            // blast in the left direction
            for rangeIndex in 1...player.power {
                // blast cannot go through obstacles or objects
                if (obstaclesTileMap.tileDefinition(atColumn: column, row: row-rangeIndex)?.name == "obstacle" || obstaclesTileMap.tileDefinition(atColumn: column, row: row-rangeIndex)?.name == "bubble" ||
                    obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "fire_bubble"){
                    break
                }
                else{
                    let tileContentBeforeBlast = obstaclesTileMap.tileDefinition(atColumn: column, row: row-rangeIndex)?.name
                    // tileGroups[54] -> fire_blast
                    obstaclesTileMap.setTileGroup(tileSet?.tileGroups[54], forColumn: column, row: row-rangeIndex)
                    
                    // determine if player is affected by the blast of bubble
                    if (playerColumn == column && playerRow == row-rangeIndex){
                        if (player.shield){
                            player.shield = false
                        }else{
                            player.health = player.health - 2
                        }
                        player.run(playerHurtedAction)
                    }
                    if (robotColumn == column && robotRow == row-rangeIndex){
                        if (robot.shield){
                            robot.shield = false
                        }else{
                            robot.health = robot.health - 2
                        }
                        robot.run(playerHurtedAction)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        self.afterBlastTileTransform(blastedTileColumn: column, blastedTileRow: row-rangeIndex, tileContentBeforeBlast: tileContentBeforeBlast)
                    })
                    if (tileContentBeforeBlast == "block"){
                        break
                    }
                }
            }
        }
        //////////////////////////////////////// if the bubble is NOT fire ////////////////////////////////////////
        else{
            // blast in the center (i.e. the position where the bubble was deployed)
            let tileContentBeforeBlast = obstaclesTileMap.tileDefinition(atColumn: column, row: row)?.name
            // tileGroups[4] -> blast
            obstaclesTileMap.setTileGroup(tileSet?.tileGroups[4], forColumn: column, row: row)
            // determine if player is affected by the blast of bubble
            if (playerColumn == column && playerRow == row){
                if (player.shield){
                    player.shield = false
                }else{
                    player.health = player.health - 1
                }
                player.run(playerHurtedAction)
            }
            if (robotColumn == column && robotRow == row){
                if (robot.shield){
                    robot.shield = false
                }else{
                    robot.health = robot.health - 1
                }
                robot.run(playerHurtedAction)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.afterBlastTileTransform(blastedTileColumn: column, blastedTileRow: row, tileContentBeforeBlast: tileContentBeforeBlast)
            })
            
            //play sound
            let audioFileLocationURL1 = Bundle.main.url(forResource: "explode", withExtension: "mp3")
            
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: audioFileLocationURL1!)
                audioPlayer.play()
            }catch{
                print(error.localizedDescription)
            }
            
            // blast in the up direction
            for rangeIndex in 1...player.power {
                // blast cannot go through obstacles or objects
                if (obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "obstacle" || obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "bubble" ||
                    obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "fire_bubble"){
                    break
                }
                else {
                    let tileContentBeforeBlast = obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name
                    // tileGroups[4] -> blast
                    obstaclesTileMap.setTileGroup(tileSet?.tileGroups[4], forColumn: column+rangeIndex, row: row)
                    
                    // determine if player is affected by the blast of bubble
                    if (playerColumn == column+rangeIndex && playerRow == row){
                        if (player.shield){
                            player.shield = false
                        }else{
                            player.health = player.health - 1
                        }
                        player.run(playerHurtedAction)
                    }
                    if (robotColumn == column+rangeIndex && robotRow == row){
                        if (robot.shield){
                            robot.shield = false
                        }else{
                            robot.health = robot.health - 1
                        }
                        robot.run(playerHurtedAction)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        self.afterBlastTileTransform(blastedTileColumn: column+rangeIndex, blastedTileRow: row, tileContentBeforeBlast: tileContentBeforeBlast)
                    })
                    if (tileContentBeforeBlast == "block"){
                        break
                    }
                }
            }
            
            // blast in the down direction
            for rangeIndex in 1...player.power {
                // blast cannot go through obstacles or objects
                if (obstaclesTileMap.tileDefinition(atColumn: column-rangeIndex, row: row)?.name == "obstacle" || obstaclesTileMap.tileDefinition(atColumn: column-rangeIndex, row: row)?.name == "bubble" ||
                    obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "fire_bubble"){
                    break
                }
                else{
                    let tileContentBeforeBlast = obstaclesTileMap.tileDefinition(atColumn: column-rangeIndex, row: row)?.name
                    // tileGroups[4] -> blast
                    obstaclesTileMap.setTileGroup(tileSet?.tileGroups[4], forColumn: column-rangeIndex, row: row)
                    
                    // determine if player is affected by the blast of bubble
                    if (playerColumn == column-rangeIndex && playerRow == row){
                        if (player.shield){
                            player.shield = false
                        }else{
                            player.health = player.health - 1
                        }
                        player.run(playerHurtedAction)
                    }
                    if (robotColumn == column-rangeIndex && robotRow == row){
                        if (robot.shield){
                            robot.shield = false
                        }else{
                            robot.health = robot.health - 1
                        }
                        robot.run(playerHurtedAction)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        self.afterBlastTileTransform(blastedTileColumn: column-rangeIndex, blastedTileRow: row, tileContentBeforeBlast: tileContentBeforeBlast)
                    })
                    if (tileContentBeforeBlast == "block"){
                        break
                    }
                }
            }
            
            // blast in the right direction
            for rangeIndex in 1...player.power {
                // blast cannot go through obstacles or objects
                if (obstaclesTileMap.tileDefinition(atColumn: column, row: row+rangeIndex)?.name == "obstacle" || obstaclesTileMap.tileDefinition(atColumn: column, row: row+rangeIndex)?.name == "bubble" ||
                    obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "fire_bubble"){
                    break
                }
                else{
                    let tileContentBeforeBlast = obstaclesTileMap.tileDefinition(atColumn: column, row: row+rangeIndex)?.name
                    // tileGroups[4] -> blast
                    obstaclesTileMap.setTileGroup(tileSet?.tileGroups[4], forColumn: column, row: row+rangeIndex)
                    
                    // determine if player is affected by the blast of bubble
                    if (playerColumn == column && playerRow == row+rangeIndex){
                        if (player.shield){
                            player.shield = false
                        }else{
                            player.health = player.health - 1
                        }
                        player.run(playerHurtedAction)
                    }
                    if (robotColumn == column && robotRow == row+rangeIndex){
                        if (robot.shield){
                            robot.shield = false
                        }else{
                            robot.health = robot.health - 1
                        }
                        robot.run(playerHurtedAction)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        self.afterBlastTileTransform(blastedTileColumn: column, blastedTileRow: row+rangeIndex, tileContentBeforeBlast: tileContentBeforeBlast)
                    })
                    if (tileContentBeforeBlast == "block"){
                        break
                    }
                }
            }
            
            // blast in the left direction
            for rangeIndex in 1...player.power {
                // blast cannot go through obstacles or objects
                if (obstaclesTileMap.tileDefinition(atColumn: column, row: row-rangeIndex)?.name == "obstacle" || obstaclesTileMap.tileDefinition(atColumn: column, row: row-rangeIndex)?.name == "bubble" ||
                    obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "fire_bubble"){
                    break
                }
                else{
                    let tileContentBeforeBlast = obstaclesTileMap.tileDefinition(atColumn: column, row: row-rangeIndex)?.name
                    // tileGroups[4] -> blast
                    obstaclesTileMap.setTileGroup(tileSet?.tileGroups[4], forColumn: column, row: row-rangeIndex)
                    
                    // determine if player is affected by the blast of bubble
                    if (playerColumn == column && playerRow == row-rangeIndex){
                        if (player.shield){
                            player.shield = false
                        }else{
                            player.health = player.health - 1
                        }
                        player.run(playerHurtedAction)
                    }
                    if (robotColumn == column && robotRow == row-rangeIndex){
                        if (robot.shield){
                            robot.shield = false
                        }else{
                            robot.health = robot.health - 1
                        }
                        robot.run(playerHurtedAction)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        self.afterBlastTileTransform(blastedTileColumn: column, blastedTileRow: row-rangeIndex, tileContentBeforeBlast: tileContentBeforeBlast)
                    })
                    if (tileContentBeforeBlast == "block"){
                        break
                    }
                }
            }
        }
        ////////////////////////////////////////////////////////////////////////////////////////////////
        
        // add back the player's bubble capacity by 1
        player.bubble_number = player.bubble_number + 1
    }
    
    /*
     * transform a bombed tile
     */
    func afterBlastTileTransform(blastedTileColumn:Int, blastedTileRow:Int, tileContentBeforeBlast:String?){
        let tileSet = SKTileSet(named: "Classic Map Tile Set")
        // if the bombed tile contains a block, then the block is removed and some random item may be randomly generated
        if(tileContentBeforeBlast == "block"){
            /*
             * tileSet?.tileGroups[5] -> bubble_add
             * tileSet?.tileGroups[6] -> fast
             * tileSet?.tileGroups[7] -> fire
             * tileSet?.tileGroups[8] -> power
             * tileSet?.tileGroups[9] -> shield
             */
            let number = Int.random(in: 1 ..< 20)
            if (number == 5) || (number == 6) || (number == 7) || (number == 8) || (number == 9){
                obstaclesTileMap.setTileGroup(tileSet?.tileGroups[number], forColumn: blastedTileColumn, row: blastedTileRow)
            }else{
                obstaclesTileMap.setTileGroup(nil, forColumn: blastedTileColumn, row: blastedTileRow)
            }
        }
        else{
            obstaclesTileMap.setTileGroup(nil, forColumn: blastedTileColumn, row: blastedTileRow)
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    ////////////////////////////////////// Acquire Tools //////////////////////////////////////////
    func acquireTools (toolTileColumn:Int, toolTileRow:Int, tileName: String){
        switch(tileName){
        case "bubble_add":
            self.player.bubble_number = self.player.bubble_number + 1
            obstaclesTileMap.setTileGroup(nil, forColumn: toolTileColumn, row: toolTileRow)
        case "fast":
            let s = self.player.speed_level + 0.5
            self.player.speed_level = CGFloat.minimum(self.player.max_speed_level, s)
            obstaclesTileMap.setTileGroup(nil, forColumn: toolTileColumn, row: toolTileRow)
        case "fire":
            self.player.fire = self.player.fire + 1
            obstaclesTileMap.setTileGroup(nil, forColumn: toolTileColumn, row: toolTileRow)
        case "power":
            self.player.power = self.player.power + 1
            obstaclesTileMap.setTileGroup(nil, forColumn: toolTileColumn, row: toolTileRow)
        case "shield":
            self.player.shield = true
            obstaclesTileMap.setTileGroup(nil, forColumn: toolTileColumn, row: toolTileRow)
        default:
            break
        }
        
        // play sounds for acquire item
        let audioFileLocationURL1 = Bundle.main.url(forResource: "AcquireItem", withExtension: "mp3")
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileLocationURL1!)
            audioPlayer.play()
        }catch{
            print(error.localizedDescription)
        }
    print("bubble_number:",player.bubble_number,"spped_level:",player.speed_level,"power:",player.power,"fire:",player.fire,"shield:",player.shield)
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    ///////////////////////////////////// Player Movements /////////////////////////////////////////////
    var movingUp = false
    var movingDown = false
    var movingLeft = false
    var movingRight = false
    
    func move(direction: Direction) {
        switch(direction){
        case .Left:
            let player_texture = SKTexture(imageNamed: "player_left")
            player.texture = player_texture
            player.hSpeed = -player.moveSpeed
            player.vSpeed = 0
            //print("Left")
            // check if the new position the player will be moving to is accessible
            let newPosition1 = CGPoint(x: player.position.x - 45, y: player.position.y - 20)
            let newPosition2 = CGPoint(x: player.position.x - 45, y: player.position.y + 20)
            if checkBoundaries(position: newPosition1) && checkBoundaries(position: newPosition2){
                player.position.x = player.position.x + player.hSpeed * CGFloat(player.speed_level) * 0.5
            }
            
        case .Right:
            let player_texture = SKTexture(imageNamed: "player_right")
            player.texture = player_texture
            player.hSpeed = player.moveSpeed
            player.vSpeed = 0
            //print("Right")
            // check if the new position the player will be moving to is accessible
            let newPosition1 = CGPoint(x: player.position.x + 45, y: player.position.y - 20)
            let newPosition2 = CGPoint(x: player.position.x + 45, y: player.position.y + 20)
            if checkBoundaries(position: newPosition1) && checkBoundaries(position: newPosition2){
                player.position.x = player.position.x + player.hSpeed * CGFloat(player.speed_level) * 0.5
            }
        case .Up:
            let player_texture = SKTexture(imageNamed: "player_up")
            player.texture = player_texture
            player.hSpeed = 0
            player.vSpeed = player.moveSpeed
            // print("Up")
            // check if the new position the player will be moving to is accessible
            let newPosition1 = CGPoint(x: player.position.x + 20, y: player.position.y + 45)
            let newPosition2 = CGPoint(x: player.position.x - 20, y: player.position.y + 45)
            if checkBoundaries(position: newPosition1) && checkBoundaries(position: newPosition2){
                player.position.y = player.position.y + player.vSpeed * CGFloat(player.speed_level) * 0.5
            }
        case .Down:
            let player_texture = SKTexture(imageNamed: "player_down")
            player.texture = player_texture
            player.hSpeed = 0
            player.vSpeed = -player.moveSpeed
            // print("Down")
            // check if the new position the player will be moving to is accessible
            let newPosition1 = CGPoint(x: player.position.x - 20, y: player.position.y - 45)
            let newPosition2 = CGPoint(x: player.position.x + 20, y: player.position.y - 45)
            if checkBoundaries(position: newPosition1) && checkBoundaries(position: newPosition2){
                player.position.y = player.position.y + player.vSpeed * CGFloat(player.speed_level) * 0.5
            }
        default:
            break
        }
    }
    
    func checkBoundaries(position:CGPoint) -> Bool{
        let column = obstaclesTileMap.tileColumnIndex(fromPosition: position)
        let row = obstaclesTileMap.tileRowIndex(fromPosition: position)
        let tile = obstaclesTileMap.tileDefinition(atColumn: column, row: row)
        if tile?.name == "block" || tile?.name == "obstacle" || tile?.name == "bubble" || tile?.name == "fire_bubble" {
            // print("not accessible")
            return false
        }
        else {
            // print("accessible")
            return true
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    ////////// DEFAULT VARIABLES ////////////////////////
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    private var lastUpdateTime : TimeInterval = 0
    //private var label : SKLabelNode?
    //private var spinnyNode : SKShapeNode?
    /////////////////////////////////////////////////////
    
    ////////////// Added Scene Nodes ////////////////////
    private var player = Player()
    private var robot = Robot()
    var obstaclesTileMap:SKTileMapNode!
    var background = SKSpriteNode(imageNamed: "background.png")
    /////////////////////////////////////////////////////
    
    ////////////////////////////////// Scene Initialization (Loading) ////////////////////////////////////
    override func didMove(to view: SKView) {
        // add the background to the screen
        addChild(background)
        background.zPosition = -10
        background.position = CGPoint(x: 0,y:0)
        background.setScale(5)
        background.alpha = 0.8
        
        loadMapNode()
        if let playerNode = childNode(withName: "player"){
            player = playerNode as! Player // establish Sprite node reference
            
            if let controllerComponent = playerNode.entity?.component(ofType: ControllerComponent.self){
                // assign controllerCmponent's moveDelegate
                controllerComponent.moveDelegate = self
                // assign controllerCmponent's deployDelegate
                controllerComponent.deployDelegate = self
                controllerComponent.setUpControls(camera: camera!, scene: self)
            }
        }
        
        if let robotNode = childNode(withName: "robot"){
            robot = robotNode as! Robot // establish Sprite node reference
        }
        
        // set up status bar in game
        setUpStatusBar()
    }
    
    func loadMapNode() {
        guard let obstaclesTileMap = childNode(withName: "Obstacles Tile Map Node")
            as? SKTileMapNode else {
                fatalError("Background node not loaded")
        }
        self.obstaclesTileMap = obstaclesTileMap
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var gameResult = false;
    var count = 0;
    
    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        robot.player = player
        robot.obstaclesTileMap = obstaclesTileMap
        robot.autoPlay()

        // make the camera follow the player's position
        self.camera?.position = player.position
        // self.camera?.position = robot.position
        
        // update player movements
        if (movingUp){
            move(direction: Direction.Up)
        }
        if (movingDown){
            move(direction: Direction.Down)
        }
        if (movingLeft){
            move(direction: Direction.Left)
        }
        if (movingRight){
            move(direction: Direction.Right)
        }
        
        // obtain the current tile that the player is standing on at each frame
        let position = player.position
        let column = obstaclesTileMap.tileColumnIndex(fromPosition: position)
        let row = obstaclesTileMap.tileRowIndex(fromPosition: position)
        let tile = obstaclesTileMap.tileDefinition(atColumn: column, row: row)
        
        if (tile?.name == "bubble_add" || tile?.name == "fast" || tile?.name == "fire" || tile?.name == "power" || tile?.name == "shield"){
            self.acquireTools(toolTileColumn: column, toolTileRow: row, tileName: (tile?.name)!)
        }

        ////////////////// BELOW ARE THE DEFAULT CODE /////////////////////
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
    
        self.lastUpdateTime = currentTime
        //////////////////////////////////////////////////////////////
        
        // update all elements of status bar except timer
        updateStatusBar()
        
        // Update Timer Field
        timeLeft = timeLeft - dt
        timerField.text = "\(Int(timeLeft))s"
        if(gameResult == true && count == 0){
            scene?.view?.isPaused = true;
            count = 1
            sleep(5)
            exitDelegate?.exitToMenu()
        }
        if(gameResult == false && (timeLeft <= 0 || player.health <= 0 || robot.health <= 0)){
            print("here")
            gameResult = true
            endGame()
        }
    }
    
    ////////////////// DEFAULT FUNCTION /////////////////////
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    ///////////////////////////////////////////////////////////////
    
    
    //////////////////////////////// Status Bar Related //////////////////////////////////////
    var status_bar_frame = SKSpriteNode(imageNamed: "status_bar_frame")
    
    let healthElement = SKSpriteNode(imageNamed: "health")
    var healthField = SKLabelNode()
    let powerElement = SKSpriteNode(imageNamed: "power")
    var powerField = SKLabelNode()
    let fireElement = SKSpriteNode(imageNamed: "fire")
    var fireField = SKLabelNode()
    let fastElement = SKSpriteNode(imageNamed: "fast")
    var fastField = SKLabelNode()
    let bubbleAddElement = SKSpriteNode(imageNamed: "bubble_add")
    var bubbleAddField = SKLabelNode()
    let shieldElement = SKSpriteNode(imageNamed: "shield")
    var shieldField = SKLabelNode()
    
    let timerElement = SKSpriteNode(imageNamed: "clock")
    var timerField = SKLabelNode()
    var timeLeft = 300.0 // seconds
    
    func setUpStatusBar(){
        let statusBar = SKSpriteNode.init(texture: nil, color: UIColor.clear, size: self.frame.size)
        statusBar.isUserInteractionEnabled = true
        
        // add status bar frame
        status_bar_frame.position = CGPoint(x: -self.frame.size.width / 2 + 110, y: self.frame.size.height / 5)
        status_bar_frame.setScale(0.25)
        status_bar_frame.name = "status_bar_frame"
        status_bar_frame.zPosition = 28
        statusBar.addChild(status_bar_frame)
        
        // add health icon
        healthElement.position = CGPoint(x: -self.frame.size.width / 2 + 70, y: self.frame.size.height / 2 - 70)
        healthElement.setScale(0.25)
        healthElement.name = "healthElement"
        healthElement.zPosition = 29
        statusBar.addChild(healthElement)
        
        // add health field
        healthField.position = CGPoint(x: -self.frame.size.width / 2 + 100, y: self.frame.size.height / 2 - 70 - 5)
        healthField.setScale(0.8)
        healthField.name = "healthField"
        healthField.zPosition = 29
        healthField.text = String(player.health)
        healthField.fontColor = SKColor.black
        healthField.fontSize = 18
        healthField.fontName = "AmericanTypewriter-CondensedBold"
        statusBar.addChild(healthField)
        
        // add power icon
        powerElement.position = CGPoint(x: -self.frame.size.width / 2 + 70, y: self.frame.size.height / 2 - 95)
        powerElement.setScale(0.7)
        powerElement.name = "powerElement"
        powerElement.zPosition = 29
        statusBar.addChild(powerElement)
        
        // add power field
        powerField.position = CGPoint(x: -self.frame.size.width / 2 + 100, y: self.frame.size.height / 2 - 95 - 5)
        powerField.setScale(0.8)
        powerField.name = "powerField"
        powerField.zPosition = 29
        powerField.text = String(player.power)
        powerField.fontColor = SKColor.black
        powerField.fontSize = 18
        powerField.fontName = "AmericanTypewriter-CondensedBold"
        statusBar.addChild(powerField)
        
        // add fire icon
        fireElement.position = CGPoint(x: -self.frame.size.width / 2 + 70, y: self.frame.size.height / 2 - 120)
        fireElement.setScale(0.3)
        fireElement.name = "fireElement"
        fireElement.zPosition = 29
        statusBar.addChild(fireElement)
        
        // add fire field
        fireField.position = CGPoint(x: -self.frame.size.width / 2 + 100, y: self.frame.size.height / 2 - 120 - 5)
        fireField.setScale(0.8)
        fireField.name = "fireField"
        fireField.zPosition = 29
        fireField.text = String(player.fire)
        fireField.fontColor = SKColor.black
        fireField.fontSize = 18
        fireField.fontName = "AmericanTypewriter-CondensedBold"
        statusBar.addChild(fireField)
        
        // add fast icon
        fastElement.position = CGPoint(x: -self.frame.size.width / 2 + 70, y: self.frame.size.height / 2 - 145)
        fastElement.setScale(0.6)
        fastElement.name = "fastElement"
        fastElement.zPosition = 29
        statusBar.addChild(fastElement)
        
        // add fast (speed) field
        fastField.position = CGPoint(x: -self.frame.size.width / 2 + 100, y: self.frame.size.height / 2 - 145 - 5)
        fastField.setScale(0.8)
        fastField.name = "fastField"
        fastField.zPosition = 29
        fastField.text = "Lv.\(player.speed_level)"
        fastField.fontColor = SKColor.black
        fastField.fontSize = 18
        fastField.fontName = "AmericanTypewriter-CondensedBold"
        statusBar.addChild(fastField)
        
        // add bubbleAdd icon
        bubbleAddElement.position = CGPoint(x: -self.frame.size.width / 2 + 70, y: self.frame.size.height / 2 - 170)
        bubbleAddElement.setScale(0.6)
        bubbleAddElement.name = "bubbleAddElement"
        bubbleAddElement.zPosition = 29
        statusBar.addChild(bubbleAddElement)
        
        // add bubbleAdd field
        bubbleAddField.position = CGPoint(x: -self.frame.size.width / 2 + 100, y: self.frame.size.height / 2 - 170 - 5)
        bubbleAddField.setScale(0.8)
        bubbleAddField.name = "bubbleAddField"
        bubbleAddField.zPosition = 29
        bubbleAddField.text = String(player.bubble_number)
        bubbleAddField.fontColor = SKColor.black
        bubbleAddField.fontSize = 18
        bubbleAddField.fontName = "AmericanTypewriter-CondensedBold"
        statusBar.addChild(bubbleAddField)
        
        // add shield icon
        shieldElement.position = CGPoint(x: -self.frame.size.width / 2 + 70, y: self.frame.size.height / 2 - 195)
        shieldElement.setScale(0.6)
        shieldElement.name = "shieldElement"
        shieldElement.zPosition = 29
        statusBar.addChild(shieldElement)
        
        // add shield field
        shieldField.position = CGPoint(x: -self.frame.size.width / 2 + 100, y: self.frame.size.height / 2 - 195 - 5)
        shieldField.setScale(0.8)
        shieldField.name = "shieldField"
        shieldField.zPosition = 29
        shieldField.text = (player.shield ? "Yes" : "No")
        shieldField.fontColor = SKColor.black
        shieldField.fontSize = 18
        shieldField.fontName = "AmericanTypewriter-CondensedBold"
        statusBar.addChild(shieldField)
        
        // add timer icon
        timerElement.position = CGPoint(x: -self.frame.size.width / 2 + 145, y: self.frame.size.height / 2 - 120)
        timerElement.setScale(0.07)
        timerElement.name = "timerElement"
        timerElement.zPosition = 29
        statusBar.addChild(timerElement)
        
        // add timer field
        timerField.position = CGPoint(x: -self.frame.size.width / 2 + 145, y: self.frame.size.height / 2 - 120 - 30)
        timerField.setScale(0.8)
        timerField.name = "timerField"
        timerField.zPosition = 29
        timerField.text = "\(timeLeft)s"
        timerField.fontColor = SKColor.black
        timerField.fontSize = 18
        timerField.fontName = "AmericanTypewriter-CondensedBold"
        statusBar.addChild(timerField)
        
        // add status bar to the camera
        camera!.addChild(statusBar)
    }
    
    // updates all elements on status bar except timer
    func updateStatusBar(){
        
        // player's information
        healthField.text = String(player.health)
        powerField.text = String(player.power)
        fireField.text = String(player.fire)
        let speedLevel : Int = Int(player.speed_level/0.5 - 1)
        fastField.text = "Lv.\(speedLevel)"
        bubbleAddField.text = String(player.bubble_number)
        shieldField.text = (player.shield ? "Yes" : "No")
        
        /*
        // robot's information
        healthField.text = String(robot.health)
        powerField.text = String(robot.power)
        fireField.text = String(robot.fire)
        let speedLevel : Int = Int(robot.speed_level/0.5 - 1)
        fastField.text = "Lv.\(speedLevel)"
        bubbleAddField.text = String(robot.bubble_number)
        shieldField.text = (robot.shield ? "Yes" : "No")
        */
    }
    ////////////////////////////////////////////////////////////////////////////////////////
    
    /////////////////////////////// End Game Related /////////////////////////////////////
    
    let winElement = SKSpriteNode(imageNamed: "win")
    
    func endGame(){
        // case: player lose
        if(player.health <= 0){
            let loseElement = SKSpriteNode(imageNamed: "lose")
            loseElement.position = CGPoint(x: 0, y: 0)
            loseElement.setScale(0.5)
            loseElement.name = "loseElement"
            loseElement.zPosition = 39
            camera!.addChild(loseElement)
            exitDelegate?.stopMusic()
            // play sound
            let audioFileLocationURL1 = Bundle.main.url(forResource: "PlayerLoss", withExtension: "mp3")
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: audioFileLocationURL1!)
                audioPlayer.play()
            }catch{
                print(error.localizedDescription)
            }
            //exitToMenu()
            
        }
        // case: player win
        else if(robot.health <= 0){
            let winElement = SKSpriteNode(imageNamed: "win")
            winElement.position = CGPoint(x: 0, y: 0)
            winElement.setScale(0.5)
            winElement.name = "winElement"
            winElement.zPosition = 39
            camera!.addChild(winElement)
            exitDelegate?.stopMusic()
            // play sound
            let audioFileLocationURL1 = Bundle.main.url(forResource: "PlayerWin", withExtension: "mp3")
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: audioFileLocationURL1!)
                audioPlayer.play()
            }catch{
                print(error.localizedDescription)
            }
            //exitToMenu()
        }
        else if(timeLeft <= 0){
            let drawElement = SKSpriteNode(imageNamed: "draw")
            drawElement.position = CGPoint(x: 0, y: 0)
            drawElement.setScale(0.5)
            drawElement.name = "drawElement"
            drawElement.zPosition = 39
            camera!.addChild(drawElement)
            exitDelegate?.stopMusic()
            // play sound
            let audioFileLocationURL1 = Bundle.main.url(forResource: "GameDraw", withExtension: "mp3")
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: audioFileLocationURL1!)
                audioPlayer.play()
            }catch{
                print(error.localizedDescription)
            }
            //exitToMenu()
        }
    }
    
    func exitToMenu(){
        exitDelegate?.stopMusic()
        scene?.view?.isPaused = true
        exitDelegate?.exitToMenu()
    }
    ////////////////////////////////////////////////////////////////////////////////////////
}

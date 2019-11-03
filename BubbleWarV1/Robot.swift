//
//  Robot.swift
//  BubbleWarV1
//
//  Created by CHANGLI HUANG on 4/28/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Robot: SKSpriteNode{
    
    //////////////////////////////////// Basic Robot Arrtibutes //////////////////////////////////
    var moveSpeed : CGFloat = 4
    var hSpeed : CGFloat = 0
    var vSpeed : CGFloat = 0
    
    let max_speed_level : CGFloat = 3.0
    var speed_level : CGFloat = 1.0
    
    var health : Int = 3
    var power : Int = 1
    var bubble_number : Int = 1
    var max_bubble_number : Int = 1
    var shield : Bool = false
    var fire : Int = 0
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////// Map and Player Attributes //////////////////////////////////
    var obstaclesTileMap:SKTileMapNode!
    var player:Player = Player();
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    ///////////////////////////// Auxiliary Functions //////////////////////////////////
    // return my row and column
    func getMyColRow()->Array<Int>{
        let position = self.position;
        let column = obstaclesTileMap.tileColumnIndex(fromPosition: position)
        let row = obstaclesTileMap.tileRowIndex(fromPosition: position)
        return [row,column]
    }
    
    // get the distance from player
    func DistanceFromPlayer()->CGFloat{
        let pPos = player.position
        let rPos = self.position
        return pow(pow(pPos.x - rPos.x,2)+pow(pPos.y - rPos.y,2),0.5)
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    /*
     * check surrounding tiles / pick up tools/ destroy blocks
     */
    func lookAround(){
        // get my current position on tile map
        let arr = getMyColRow();
        let row = arr[0]
        let col = arr[1]
        print ("my position: ", row, " ", col)
        
        // get information of tiles around robot
        let leftTile = obstaclesTileMap.tileDefinition(atColumn: col-1, row: row)
        let rightTile = obstaclesTileMap.tileDefinition(atColumn: col+1, row: row)
        let upTile = obstaclesTileMap.tileDefinition(atColumn: col, row: row+1)
        let downTile = obstaclesTileMap.tileDefinition(atColumn: col, row: row-1)
        let upLeft = obstaclesTileMap.tileDefinition(atColumn: col-1, row: row+1)
        let upRight = obstaclesTileMap.tileDefinition(atColumn: col+1, row: row+1)
        let downLeft = obstaclesTileMap.tileDefinition(atColumn: col-1, row: row-1)
        let downRight = obstaclesTileMap.tileDefinition(atColumn: col+1, row: row-1)
        
        // flag that determines if robot already moved
        var moved = 0;
        
        // move if there is tools to collect
        if(leftTile != nil){
            if(leftTile!.name == "bubble_add" || leftTile!.name == "fast" || leftTile!.name == "fire" || leftTile!.name == "power" || leftTile!.name == "shield"){
                move(direction: Direction.Left)
                print ("try to collect left")
                moved = 1
            }
        }
        if(rightTile != nil && moved == 0){
            if(rightTile!.name == "bubble_add" || rightTile!.name == "fast" || rightTile!.name == "fire" || rightTile!.name == "power" || rightTile!.name == "shield"){
                move(direction: Direction.Right)
                print ("try to collect right")
                moved = 1
            }
        }
        if(upTile != nil && moved == 0){
            if(upTile!.name == "bubble_add" || upTile!.name == "fast" || upTile!.name == "fire" || upTile!.name == "power" || upTile!.name == "shield"){
                move(direction: Direction.Up)
                print ("try to collect up")
                moved = 1
            }
        }
        if(downTile != nil && moved  == 0){
            if(downTile!.name == "bubble_add" || downTile!.name == "fast" || downTile!.name == "fire" || downTile!.name == "power" || downTile!.name == "shield"){
                move(direction: Direction.Down)
                print ("try to collect down")
                moved = 1
            }
        }
        if(upLeft != nil && moved  == 0){
            if (upTile == nil){
                if(upLeft!.name == "bubble_add" || upLeft!.name == "fast" || upLeft!.name == "fire" || upLeft!.name == "power" || upLeft!.name == "shield"){
                    move(direction: Direction.Up)
                    print ("try to collect upleft, up")
                    moved = 1
                }
            }
            else if (leftTile == nil){
                if(upLeft!.name == "bubble_add" || upLeft!.name == "fast" || upLeft!.name == "fire" || upLeft!.name == "power" || upLeft!.name == "shield"){
                    move(direction: Direction.Left)
                    print ("try to collect upleft, left")
                    moved = 1
                }
            }
        }
        if(upRight != nil && moved  == 0){
            if (upTile == nil){
                if(upRight!.name == "bubble_add" || upRight!.name == "fast" || upRight!.name == "fire" || upRight!.name == "power" || upRight!.name == "shield"){
                    move(direction: Direction.Up)
                    print ("try to collect upright, up")
                    moved = 1
                }
            }
            else if (rightTile == nil){
                if(upRight!.name == "bubble_add" || upRight!.name == "fast" || upRight!.name == "fire" || upRight!.name == "power" || upRight!.name == "shield"){
                    move(direction: Direction.Right)
                    print ("try to collect upright, right")
                    moved = 1
                }
            }
        }
        if(downLeft != nil && moved  == 0){
            if (downTile == nil){
                if(downLeft!.name == "bubble_add" || downLeft!.name == "fast" || downLeft!.name == "fire" || downLeft!.name == "power" || downLeft!.name == "shield"){
                    move(direction: Direction.Down)
                    print ("try to collect downleft, down")
                    moved = 1
                }
            }
            else if (leftTile == nil){
                if(downLeft!.name == "bubble_add" || downLeft!.name == "fast" || downLeft!.name == "fire" || downLeft!.name == "power" || downLeft!.name == "shield"){
                    move(direction: Direction.Left)
                    print ("try to collect downleft, left")
                    moved = 1
                }
            }
        }
        if(downRight != nil && moved  == 0){
            if (downTile == nil){
                if(downRight!.name == "bubble_add" || downRight!.name == "fast" || downRight!.name == "fire" || downRight!.name == "power" || downRight!.name == "shield"){
                    move(direction: Direction.Down)
                    print ("try to collect downright, down")
                    moved = 1
                }
            }
            else if (rightTile == nil){
                if(downRight!.name == "bubble_add" || downRight!.name == "fast" || downRight!.name == "fire" || downRight!.name == "power" || downRight!.name == "shield"){
                    move(direction: Direction.Right)
                    print ("try to collect downright, right")
                    moved = 1
                }
            }
        }
        
        // if no collectable items found nearby, would like to go blast destructable blocks if found any
        if(moved == 0){
            print("no collected items")
            
            // flag that keeps track of whether robot drops any bubbles
            var dropped = 0;
            
            // go blast destructable blocks
            if(leftTile != nil){
                if(leftTile!.name == "block"){
                    print("blast the block to the left")
                    dropBubble()
                    dropped = 1
                }
            }
            if(rightTile != nil && dropped == 0){
                if(rightTile!.name == "block"){
                    print("blast the block to the right")
                    dropBubble()
                    dropped = 1
                }
            }
            if(upTile != nil && dropped == 0){
                if(upTile!.name == "block"){
                    print("blast the block to the up")
                    dropBubble()
                    dropped = 1
                }
            }
            if(downTile != nil && dropped == 0){
                if(downTile!.name == "block"){
                    print("blast the block to the down")
                    dropBubble()
                    dropped = 1
                }
            }
            
            // if no up, down, left or right blocks found, move to diagonal blocks if they exist
            var moved1 = 0
            if(dropped == 0){
                print("no up, down, left, right blocks found, looking for diagonal blocks")
                if(upLeft != nil){
                    if(upLeft!.name == "block"){
                        if(upTile == nil){
                            move(direction: Direction.Up)
                            print("found upleft block, moving up")
                            moved1 = 1
                        }
                        else if(leftTile == nil){
                            move(direction: Direction.Left)
                            print("found upleft block, moving left")
                            moved1 = 1
                        }
                    }
                }
                if(upRight != nil && moved1 == 0){
                    if(upRight!.name == "block"){
                        if(upTile == nil){
                            move(direction: Direction.Up)
                            print("found upright block, moving up")
                            moved1 = 1
                        }
                        else if(rightTile == nil){
                            move(direction: Direction.Right)
                            print("found upright block, moving right")
                            moved1 = 1
                        }
                    }
                }
                if(downLeft != nil && moved1 == 0){
                    if(downLeft!.name == "block"){
                        if(downTile == nil){
                            move(direction: Direction.Down)
                            print("found downleft block, moving down")
                            moved1 = 1
                        }
                        else if(leftTile == nil){
                            move(direction: Direction.Left)
                            print("found downleft block, moving left")
                            moved1 = 1
                        }
                    }
                }
                if(downRight != nil && moved1 == 0){
                    if(downRight!.name == "block"){
                        if(downTile == nil){
                            move(direction: Direction.Down)
                            print("found downright block, moving down")
                            moved1 = 1
                        }
                        else if(rightTile == nil){
                            move(direction: Direction.Right)
                            print("found downright block, moving right")
                            moved1 = 1
                        }
                    }
                }
                
                //neither tools nor block found 8 tiles around, move toward player
                if(moved1 == 0){
                    print("neither tools nor block found 8 tiles around, 从lookaround里进movetoplayer")
                    moveTowardPlayer()
                }
            }
        }
    }
    
    /*
     * determines if robot can dodge blast after dropping bubble
     * returns true if there exists diagonal spot to hide
     */
    func canDodgeDiagonally(array:[Int])->Bool{
        
        // get robot's current position on the tile map
        let myRow = array[0]
        let myCol = array[1]
        
        // get robot's surrounding tiles information
        let up  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+1)
        let down = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-1)
        let left = obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow)
        let right = obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow)
        let upLeft = obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow+1)
        let upRight = obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow+1)
        let downLeft = obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow-1)
        let downRight = obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow-1)
        
        // check if robot can dodge to any diagonal directions
        if(upLeft == nil && up == nil){
            return true
        }
        else if(upLeft == nil && left == nil){
            return true
        }
        else if(upRight == nil && up == nil){
            return true
        }
        else if(upRight == nil && right == nil){
            return true
        }
        else if(downLeft == nil && down == nil){
            return true
        }
        else if(downLeft == nil && left == nil){
            return true
        }
        else if(downRight == nil && down == nil){
            return true
        }
        else if(downRight == nil && right == nil){
            return true
        }
        else{
            print("cannnot hide diagonal")
            return false
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////
    // return true if can escape the power range of the bubble horizontally or vertically
    // takes care of the corner case where no diagonal sport found for robot to hide
    func canDodgeAlign(array:[Int])->Bool {
        // robot's current row and column on the tile map
        let myRow = array[0]
        let myCol = array[1]
     
        // determines if robot can dodge horizontal/vertically based on its bubble power
        if(dodgeLeft(array: [myRow,myCol]) == true){
            return true
        }
        else if(dodgeRight(array: [myRow,myCol]) == true){
            return true
        }
        else if(dodgeUp(array: [myRow,myCol]) == true){
            return true
        }
        else if(dodgeDown(array: [myRow,myCol]) == true){
            return true
        }
        return false
    }

    func dodgeUp(array:[Int])->Bool{
        let myRow = array[0]
        let myCol = array[1]
        for i in 1...self.power+1{
            let tile = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+i)
            if(tile != nil){
                return false
            }
        }
        return true
    }
    func dodgeLeft(array:[Int])->Bool{
        let myRow = array[0]
        let myCol = array[1]
        for i in 1...self.power+1{
            let tile = obstaclesTileMap.tileDefinition(atColumn: myCol-i, row: myRow)
            if(tile != nil){
                return false
            }
        }
        return true
    }
    func dodgeRight(array:[Int])->Bool{
        let myRow = array[0]
        let myCol = array[1]
        for i in 1...self.power+1{
            let tile = obstaclesTileMap.tileDefinition(atColumn: myCol+i, row: myRow)
            if(tile != nil){
                return false
            }
        }
        return true
    }
    func dodgeDown(array:[Int])->Bool{
        let myRow = array[0]
        let myCol = array[1]
        for i in 1...self.power+1{
            let tile = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-i)
            if(tile != nil){
                return false
            }
        }
        return true
    }
    /////////////////////////////////////////////////////////////////////////////////////////////
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////
    
    /////////////// check if there eixts bubble above robot that can hurt robot /////////////////
    func checkUpBubble(arr:[Int])->Int{
        //let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        for i in 1...self.power+1{
            let tile = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+i)
            if(tile?.name == "bubble" || tile?.name == "fire_bubble"){
                return i
            }
        }
        return 0
    }
    /////////////// check if there eixts bubble left to robot that can hurt robot /////////////////
    func checkLeftBubble(arr:[Int])->Int{
        //let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        for i in 1...self.power+1{
            let tile = obstaclesTileMap.tileDefinition(atColumn: myCol-i, row: myRow)
            if(tile?.name == "bubble" || tile?.name == "fire_bubble"){
                return i
            }
        }
        return 0
    }
    /////////////// check if there eixts bubble right to robot that can hurt robot /////////////////
    func checkRightBubble(arr:[Int])->Int{
        //let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        for i in 1...(self.power+1){
            let tile = obstaclesTileMap.tileDefinition(atColumn: myCol+i, row: myRow)
            if(tile?.name == "bubble" || tile?.name == "fire_bubble"){
                return i
            }
        }
        return 0
    }
    /////////////// check if there eixts bubble down robot that can hurt robot /////////////////
    func checkDownBubble(arr:[Int])->Int{
        //let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        for i in 1...self.power+1{
            let tile = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-i)
            if(tile?.name == "bubble" || tile?.name == "fire_bubble"){
                return i
            }
        }
        return 0
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////
    
    func dropBubble(){
        // get robot's current position on tile map
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        print("Before dropping bubble: can hide diagonal:",canDodgeDiagonally(array: getMyColRow()),", can hide align:",canDodgeAlign(array: getMyColRow()))
        
        // if robot can hide to a diagonally or vertically, then drop the bubble
        if (canDodgeDiagonally(array: getMyColRow()) || canDodgeAlign(array: getMyColRow())){
            //WARNING: undefined functionn
            deploy()
            print("Dropped at: ",myRow," ",myCol)
        }
        else{
            return
        }
        
    }

    /*
     * this function takes care of adjusting the position of robot when dodging bubbles
     */
    func ShiftDodgeDeployedBubble(imaginaryX: CGFloat, imaginaryY: CGFloat){
        print("imaginary dodging bubble")
    
        let imaginaryPosition = CGPoint(x: imaginaryX, y: imaginaryY)
        let imaginaryColumn = obstaclesTileMap.tileColumnIndex(fromPosition: imaginaryPosition)
        let imaginaryRow = obstaclesTileMap.tileRowIndex(fromPosition: imaginaryPosition)
        
        let current = obstaclesTileMap.tileDefinition(atColumn: imaginaryColumn, row: imaginaryRow)
        let up  = obstaclesTileMap.tileDefinition(atColumn: imaginaryColumn, row: imaginaryRow+1)
        let down = obstaclesTileMap.tileDefinition(atColumn: imaginaryColumn, row: imaginaryRow-1)
        let left = obstaclesTileMap.tileDefinition(atColumn: imaginaryColumn-1, row: imaginaryRow)
        let right = obstaclesTileMap.tileDefinition(atColumn: imaginaryColumn+1, row: imaginaryRow)
        let upLeft = obstaclesTileMap.tileDefinition(atColumn: imaginaryColumn-1, row: imaginaryRow+1)
        let upRight = obstaclesTileMap.tileDefinition(atColumn: imaginaryColumn+1, row: imaginaryRow+1)
        let downLeft = obstaclesTileMap.tileDefinition(atColumn: imaginaryColumn-1, row: imaginaryRow-1)
        let downRight = obstaclesTileMap.tileDefinition(atColumn: imaginaryColumn+1, row: imaginaryRow-1)
        
        // if robot just deployed a bubble and is standing on it
        if(current != nil && (current!.name == "bubble" || current!.name == "fire_bubble")){
            print("standing on it")
            if((upLeft == nil && up == nil) || (upRight == nil && up == nil)){
                move(direction: Direction.Up)
                print("imaginary dodging up")
            }
            else if((downLeft == nil && down == nil) || (downRight == nil && down == nil)){
                move(direction: Direction.Down)
                print("imaginary dodging Down")
            }
            else if((downLeft == nil && left == nil) || (upLeft == nil && left == nil)){
                move(direction: Direction.Left)
                print("imaginary dodging Left")
            }
            else if((downRight == nil && right == nil) || (upRight == nil && right == nil)){
                move(direction: Direction.Right)
                print("imaginary dodging Right")
            }
        }
        // if bubble is one tile below robot
        else if(down != nil && (down!.name == "bubble" || down!.name == "fire_bubble")){
            print("bubble below me")
            // if can go either left or right, then go to the direction where robot is closer to
            if (left == nil && right == nil){
                if (self.position.x < obstaclesTileMap.centerOfTile(atColumn: imaginaryColumn, row: imaginaryRow).x){
                    move(direction: Direction.Left)
                }
                else{
                    move(direction: Direction.Right)
                }
            }
            // if can only go left, then go left
            if(left == nil){
                move(direction: Direction.Left)
            }
            // if can only go right, then go right
            else if(right == nil){
                move(direction: Direction.Right)
            }
        }
        // if bubble is one tile above robot
        else if(up != nil && (up!.name == "bubble" || up!.name == "fire_bubble")){
            print("bubble above me")
            // if can go either left or right, then go to the direction where robot is closer to
            if (left == nil && right == nil){
                if (self.position.x < obstaclesTileMap.centerOfTile(atColumn: imaginaryColumn, row: imaginaryRow).x){
                    move(direction: Direction.Left)
                }
                else{
                    move(direction: Direction.Right)
                }
            }
            // if can only go left, then go left
            else if(left == nil){
                print("going left")
                move(direction: Direction.Left)
            }
            // if can only go right, then go right
            else if(right == nil){
                print("going right")
                move(direction: Direction.Right)
            }
        }
        // if bubble is one tile right of robot
        else if(right != nil && (right!.name == "bubble" || right!.name == "fire_bubble")){
            print("bubble right me")
            // if can go either up or down, then go to the direction where robot is closer to
            if (up == nil && down == nil){
                if (self.position.y < obstaclesTileMap.centerOfTile(atColumn: imaginaryColumn, row: imaginaryRow).y){
                    move(direction: Direction.Down)
                }
                else{
                    move(direction: Direction.Up)
                }
            }
            // if can only go up, then go up
            else if(up == nil){
                move(direction: Direction.Up)
            }
            // if can only go down, then go down
            else if(down == nil){
                move(direction: Direction.Down)
            }
        }
        // if bubble is one tile left of robot
        else if(left != nil && (left!.name == "bubble" || left!.name == "fire_bubble")){
            print("bubble left me")
            // if can go either up or down, then go to the direction where robot is closer to
            if (up == nil && down == nil){
                if (self.position.y < obstaclesTileMap.centerOfTile(atColumn: imaginaryColumn, row: imaginaryRow).y){
                    move(direction: Direction.Down)
                }
                else{
                    move(direction: Direction.Up)
                }
            }
            // if can only go up, then go up
            else if(up == nil){
                move(direction: Direction.Up)
            }
            // if can only go down, then go down
            else if(down == nil){
                move(direction: Direction.Down)
            }
        }
    }
    
    /*
     * Check if there are bubbles found on the four nearby diagonals to robot
     */
    func foundAnyBubbleOnFourNearbyDiagonal() -> Bool {
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        // get information of tiles surrounding robot
        let upLeft = obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow+1)
        let upRight = obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow+1)
        let downLeft = obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow-1)
        let downRight = obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow-1)
        
        if((upLeft != nil && upLeft!.name == "bubble") || (upRight != nil && upRight!.name == "bubble") || (downLeft != nil && downLeft!.name == "bubble") || (downRight != nil && downRight!.name == "bubble") || (upLeft != nil && upLeft!.name == "fire_bubble") || (upRight != nil && upRight!.name == "fire_bubble") || (downLeft != nil && downLeft!.name == "fire_bubble") || (downRight != nil && downRight!.name == "fire_bubble")){
            return true
        }
        else{
            return false
        }
    }
    
    /*
     * Check if more than one bubble found around the robot
     */
    func moreThanOneBubbleFoundAround() -> Bool {
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        var num_of_bubbles_around = 0
        
        // get information of tiles surrounding robot
        let current = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow)
        let up  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+1)
        let down = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-1)
        let left = obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow)
        let right = obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow)
        let upLeft = obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow+1)
        let upRight = obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow+1)
        let downLeft = obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow-1)
        let downRight = obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow-1)
        
        if((current != nil && (current!.name == "bubble" || current!.name == "fire_bubble"))){
            num_of_bubbles_around = num_of_bubbles_around + 1
        }
        if((up != nil && (up!.name == "bubble" || up!.name == "fire_bubble"))){
            num_of_bubbles_around = num_of_bubbles_around + 1
        }
        if((down != nil && (down!.name == "bubble" || down!.name == "fire_bubble"))){
            num_of_bubbles_around = num_of_bubbles_around + 1
        }
        if((left != nil && (left!.name == "bubble" || left!.name == "fire_bubble"))){
            num_of_bubbles_around = num_of_bubbles_around + 1
        }
        if((right != nil && (right!.name == "bubble" || right!.name == "fire_bubble"))){
            num_of_bubbles_around = num_of_bubbles_around + 1
        }
        if((upLeft != nil && (upLeft!.name == "bubble" || upLeft!.name == "fire_bubble"))){
            num_of_bubbles_around = num_of_bubbles_around + 1
        }
        if((upRight != nil && (upRight!.name == "bubble" || upRight!.name == "fire_bubble"))){
            num_of_bubbles_around = num_of_bubbles_around + 1
        }
        if((downLeft != nil && (downLeft!.name == "bubble" || downLeft!.name == "fire_bubble"))){
            num_of_bubbles_around = num_of_bubbles_around + 1
        }
        if((downRight != nil && (downRight!.name == "bubble" || downRight!.name == "fire_bubble"))){
            num_of_bubbles_around = num_of_bubbles_around + 1
        }
        
        if (num_of_bubbles_around > 1){
            return true
        }
        else{
            return false
        }
    }
    
    /*
     * Check if there bubbles found around AI
     */
    func foundAnyBubbleStandingOnOrHorizontallyOrVertically() -> Bool {
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        // get information of tiles surrounding robot
        let current = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow)
        
        
        if((current != nil && (current!.name == "bubble" || current!.name == "fire_bubble"))){
            return true
        }
        else if((checkUpBubble(arr: arr)>0)||(checkDownBubble(arr: arr)>0)||(checkLeftBubble(arr: arr)>0)||(checkRightBubble(arr: arr)>0)){
            return true
        }
        else {
            return false
        }
    }
    
    func dodgeDiagonally() -> Bool{
        print("dodging diagonally")
        
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        // get information of tiles surrounding robot
        let current = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow)
        let up  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+1)
        let down = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-1)
        let left = obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow)
        let right = obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow)
        let upLeft = obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow+1)
        let upRight = obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow+1)
        let downLeft = obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow-1)
        let downRight = obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow-1)
        
        let threatOnLeftUp = checkUpBubble(arr: [myRow,myCol-1]) != 0
        let threatOnLeftDown = checkDownBubble(arr: [myRow,myCol-1]) != 0
        let threatOnRightUp = checkUpBubble(arr: [myRow,myCol+1]) != 0
        let threatOnRightDown = checkDownBubble(arr: [myRow,myCol+1]) != 0
        let threatOnUpLeft = checkLeftBubble(arr: [myRow+1,myCol]) != 0
        let threatOnUpRight = checkRightBubble(arr: [myRow+1,myCol]) != 0
        let threatOnDownLeft = checkLeftBubble(arr: [myRow-1,myCol]) != 0
        let threatOnDownRight = checkRightBubble(arr: [myRow-1,myCol]) != 0
        
        // just deployed a bubble / standing on it
        if(current != nil && (current!.name == "bubble" || current!.name == "fire_bubble")){
            print("standing on it")
            if(((upLeft == nil && up == nil) || (upRight == nil && up == nil)) && checkBoundaries(position: CGPoint(x: self.position.x, y: self.position.y + 45))){
                move(direction: Direction.Up)
                print("Dodging up")
                return true
            }
            else if( ((downLeft == nil && down == nil) || (downRight == nil && down == nil)) && checkBoundaries(position: CGPoint(x: self.position.x, y: self.position.y - 45)) ){
                move(direction: Direction.Down)
                print("Dodging Down")
                return true
            }
            else if( ((downLeft == nil && left == nil) || (upLeft == nil && left == nil)) && checkBoundaries(position: CGPoint(x: self.position.x - 45, y: self.position.y)) ){
                move(direction: Direction.Left)
                print("Dodging Left")
                return true
            }
            else if(((downRight == nil && right == nil) || (upRight == nil && right == nil)) && checkBoundaries(position: CGPoint(x: self.position.x + 45, y: self.position.y))){
                move(direction: Direction.Right)
                print("Dodging Right")
                return true
            }
            else{
                return false
            }
        }
        // bubble is one tile below robot
        else if(down != nil && (down!.name == "bubble" || down!.name == "fire_bubble")){
            print("bubble below me")
            if (left == nil && right == nil){
                if ( (!threatOnLeftUp && !threatOnLeftDown)  &&  (!threatOnRightUp && !threatOnRightDown) ){
                    if (self.position.x < obstaclesTileMap.centerOfTile(atColumn: myCol, row: myRow).x){
                        move(direction: Direction.Left)
                        return true
                    }
                    else{
                        move(direction: Direction.Right)
                        return true
                    }
                }
                else if(!threatOnLeftUp && !threatOnLeftDown){
                    move(direction: Direction.Left)
                    return true
                }
                else if(!threatOnRightUp && !threatOnRightDown){
                    move(direction: Direction.Right)
                    return true
                }
                else{
                    return false
                }
            }
            else if(left == nil && (!threatOnLeftDown && !threatOnLeftUp)){
                move(direction: Direction.Left)
                return true
            }
            else if(right == nil && (!threatOnRightDown && !threatOnRightUp)){
                move(direction: Direction.Right)
                return true
            }
            else{
                return false
            }
        }
        // bubble is one tile above robot
        else if(up != nil && (up!.name == "bubble" || up!.name == "fire_bubble")){
            print("bubble above me")
            if (left == nil && right == nil){
                if ( (!threatOnLeftUp && !threatOnLeftDown)  &&  (!threatOnRightUp && !threatOnRightDown) ){
                    if (self.position.x < obstaclesTileMap.centerOfTile(atColumn: myCol, row: myRow).x){
                        move(direction: Direction.Left)
                        return true
                    }
                    else{
                        move(direction: Direction.Right)
                        return true
                    }
                }
                else if(!threatOnLeftUp && !threatOnLeftDown){
                    move(direction: Direction.Left)
                    return true
                }
                else if(!threatOnRightUp && !threatOnRightDown){
                    move(direction: Direction.Right)
                    return true
                }
                else{
                    return false
                }
            }
            else if(left == nil && (!threatOnLeftDown && !threatOnLeftUp) ){
                move(direction: Direction.Left)
                return true
            }
            else if(right == nil && (!threatOnRightDown && !threatOnRightUp)){
                move(direction: Direction.Right)
                return true
            }
            else{
                return false
            }
        }
        // bubble is one tile right of robot
        else if(right != nil && (right!.name == "bubble" || right!.name == "fire_bubble")){
            print("bubble right me")
            if (up == nil && down == nil){
                if ( (!threatOnUpRight && !threatOnUpLeft) && (!threatOnDownLeft && !threatOnDownRight) ){
                    if (self.position.y < obstaclesTileMap.centerOfTile(atColumn: myCol, row: myRow).y){
                        move(direction: Direction.Down)
                        return true
                    }
                    else{
                        move(direction: Direction.Up)
                        return true
                    }
                }
                else if(!threatOnUpRight && !threatOnUpLeft){
                    move(direction: Direction.Up)
                    return true
                }
                else if(!threatOnDownLeft && !threatOnDownRight){
                    move(direction: Direction.Down)
                    return true
                }
                else{
                    return false
                }
            }
            else if(up == nil && (!threatOnUpLeft && !threatOnUpRight) ){
                move(direction: Direction.Up)
                return true
            }
            else if(down == nil && (!threatOnDownLeft && !threatOnDownRight) ){
                move(direction: Direction.Down)
                return true
            }
            else{
                return false
            }
        }
        // bubble is one tile left of robot
        else if(left != nil && (left!.name == "bubble" || left!.name == "fire_bubble")){
            print("bubble left me")
            if (up == nil && down == nil){
                if ( (!threatOnUpRight && !threatOnUpLeft) && (!threatOnDownLeft && !threatOnDownRight) ){
                    if (self.position.y < obstaclesTileMap.centerOfTile(atColumn: myCol, row: myRow).y){
                        move(direction: Direction.Down)
                        return true
                    }
                    else{
                        move(direction: Direction.Up)
                        return true
                    }
                }
                else if(!threatOnUpRight && !threatOnUpLeft){
                    move(direction: Direction.Up)
                    return true
                }
                else if(!threatOnDownLeft && !threatOnDownRight){
                    move(direction: Direction.Down)
                    return true
                }
                else{
                    return false
                }
            }
            else if(up == nil && (!threatOnUpLeft && !threatOnUpRight)){
                move(direction: Direction.Up)
                return true
            }
            else if(down == nil && (!threatOnDownLeft && !threatOnDownRight)){
                move(direction: Direction.Down)
                return true
            }
            else{
                return false
            }
        }
        else{
            return false
        }
    }
    
    /*
     * Enable robot to dodge the bubbles on the map
     */
    func DodgeDeployedBubble(){
        print("dodging bubble")
        
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        let current = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow)
        /*
        // get robot's current coordinate position
        let robot_x = self.position.x
        let robot_y = self.position.y
        
        // get information of tiles surrounding robot
        let current = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow)
        let up  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+1)
        let down = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-1)
        let left = obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow)
        let right = obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow)
        let upLeft = obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow+1)
        let upRight = obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow+1)
        let downLeft = obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow-1)
        let downRight = obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow-1)
        */
        print(myRow," ",myCol)
        
        if (dodgeDiagonally()==false){
            print("cannot dodge diagonally, then dodge align")
            
            if(current != nil && (current!.name == "bubble" || current!.name == "fire_bubble")){
                print("standing on it")
                if(dodgeUp(array: [myRow,myCol]) == true){
                    move(direction: Direction.Up)
                    print("align dodging up")
                }
                else if(dodgeDown(array: [myRow,myCol]) == true){
                    move(direction: Direction.Down)
                    print("align dodging down")
                }
                else if(dodgeLeft(array: [myRow,myCol]) == true){
                    move(direction: Direction.Left)
                    print("align dodging left")
                }
                else if(dodgeRight(array: [myRow,myCol]) == true){
                    move(direction: Direction.Right)
                    print("align dodging right")
                }
            }
            // bubble is below robot
            else if(checkDownBubble(arr: arr)>0){
                move(direction: Direction.Up)
                print("bubble below me, align dodging up")
            }
                // bubble is above robot
            else if(checkUpBubble(arr: arr)>0){
                move(direction: Direction.Down)
                print("bubble above me, align dodging down")
            }
                // bubble is on the right of robot
            else if(checkRightBubble(arr: arr)>0){
                move(direction: Direction.Left)
                print("bubble right of me, align dodging left")
            }
                // bubble is on the left of robot
            else if(checkLeftBubble(arr: arr)>0){
                move(direction: Direction.Right)
                print("bubble left me, align dodging right")
            }
        }
        ////////////////////////////////////////////////////////////////////////////////////////////////
    }
    
    /////////////////////////////////////// Auxiliary Movement Functions /////////////////////////////////////////////////////////
    func obstaclesExistBothLeftAndDown(row: Int, col: Int) -> Bool{
        let down = obstaclesTileMap.tileDefinition(atColumn: col, row: row-1)
        let left = obstaclesTileMap.tileDefinition(atColumn: col-1, row: row)
        if((left != nil && left!.name == "obstacle") && (down != nil && down!.name == "obstacle")){
            return true
        }
        return false
    }
    func obstaclesExistBothLeftAndUp (row: Int, col: Int) -> Bool{
        let up  = obstaclesTileMap.tileDefinition(atColumn: col, row: row+1)
        let left = obstaclesTileMap.tileDefinition(atColumn: col-1, row: row)
        if((left != nil && left!.name == "obstacle") && (up != nil && up!.name == "obstacle")){
            return true
        }
        return false
    }
    func obstaclesExistBothRightAndDown (row: Int, col: Int) -> Bool{
        let down = obstaclesTileMap.tileDefinition(atColumn: col, row: row-1)
        let right = obstaclesTileMap.tileDefinition(atColumn: col+1, row: row)
        if((right != nil && right!.name == "obstacle") && (down != nil && down!.name == "obstacle")){
            return true
        }
        return false
    }
    func obstaclesExistBothRightAndUp (row: Int, col: Int) -> Bool{
        let up  = obstaclesTileMap.tileDefinition(atColumn: col, row: row+1)
        let right = obstaclesTileMap.tileDefinition(atColumn: col+1, row: row)
        if((right != nil && right!.name == "obstacle") && (up != nil && up!.name == "obstacle")){
            return true
        }
        return false
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //robot moves toward player by one
    func moveTowardPlayer(){
        let position = self.position;
        let myCol = obstaclesTileMap.tileColumnIndex(fromPosition: position)
        let myRow = obstaclesTileMap.tileRowIndex(fromPosition: position)
        
        let pPos = player.position
        let pCol = obstaclesTileMap.tileColumnIndex(fromPosition: pPos)
        let pRow = obstaclesTileMap.tileRowIndex(fromPosition: pPos)
        
        // ------------------------------------------- Move to Player Logic ---------------------------------------------- //
        // player on robot's upper left
        if(myCol>pCol && myRow<pRow){
            print("player on robot's upper left")
            // if can move left, then move left
            if (obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow)==nil && !obstaclesExistBothLeftAndUp(row: myRow, col: myCol-1)){
                print("if can move left, then move left")
                move(direction: Direction.Left)
            }
            // if cannot move left, but can move up, then move up
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+1)==nil && !obstaclesExistBothLeftAndUp(row: myRow+1, col: myCol)){
                print("if cannot move left, but can move up, then move up")
                move(direction: Direction.Up)
            }
            // if cannot move left or up, but can move down, then move down
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-1)==nil && !obstaclesExistBothLeftAndUp(row: myRow-1, col: myCol)){
                print("if cannot move left or up, but can move down, then move down")
                move(direction: Direction.Down)
            }
            // if cannot move left or up or down, but can move right, then move right
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow)==nil && !obstaclesExistBothLeftAndUp(row: myRow, col: myCol+1)){
                print("if cannot move left or up or down, but can move right, then move right")
                move(direction: Direction.Right)
            }
        }
        // player on robot's upper right
        else if(myCol<pCol && myRow<pRow){
            print("player on robot's upper right")
            // if can move right, then move right
            if (obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow)==nil && obstaclesExistBothRightAndUp(row: myRow, col: myCol+1)){
                print("if can move right, then move right")
                move(direction: Direction.Right)
            }
            // if cannot move right, but can move up, then move up
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+1)==nil && obstaclesExistBothRightAndUp(row: myRow+1, col: myCol)){
                print("if cannot move right, but can move up, then move up")
                move(direction: Direction.Up)
            }
            // if cannot move right or up, but can move down, then move down
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-1)==nil && obstaclesExistBothRightAndUp(row: myRow-1, col: myCol)){
                print("if cannot move right or up, but can move down, then move down")
                move(direction: Direction.Down)
            }
            // if cannot move right or up or down, but can move left, then move left
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow)==nil && !obstaclesExistBothLeftAndUp(row: myRow, col: myCol-1)){
                print("if cannot move right or up or down, but can move left, then move left")
                move(direction: Direction.Left)
            }
        }
        // player on robot's lower left
        else if(myCol>pCol && myRow>pRow){
            print("player on robot's lower left")
            // if can move left, then move left
            if (obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow)==nil && !obstaclesExistBothLeftAndDown(row: myRow, col: myCol-1)){
                print("if can move left, then move left")
                move(direction: Direction.Left)
            }
            // if cannot move left, but can move down, then move down
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-1)==nil && !obstaclesExistBothLeftAndDown(row: myRow-1, col: myCol)){
                print("if cannot move left, but can move down, then move down")
                move(direction: Direction.Down)
            }
            // if cannot move left or down, but can move up, then move up
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+1)==nil && !obstaclesExistBothLeftAndDown(row: myRow+1, col: myCol)){
                print("if cannot move left or down, but can move up, then move up")
                move(direction: Direction.Up)
            }
            // if cannot move left or up or down, but can move right, then move right
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow)==nil && !obstaclesExistBothLeftAndDown(row: myRow, col: myCol+1)){
                print("if cannot move left or up or down, but can move right, then move right")
                move(direction: Direction.Right)
            }
        }
        // player on robot's lower right
        else if(myCol<pCol && myRow>pRow){
            print("player on robot's lower right")
            // if can move right, then move right
            if (obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow)==nil && !obstaclesExistBothRightAndDown(row: myRow, col: myCol+1)){
                print("if can move right, then move right")
                move(direction: Direction.Right)
            }
            // if cannot move right, but can move down, then move down
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-1)==nil && !obstaclesExistBothRightAndDown(row: myRow-1, col: myCol)){
                print("if cannot move right, but can move down, then move down")
                move(direction: Direction.Down)
            }
            // if cannot move right or down, but can move up, then move up
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+1)==nil && !obstaclesExistBothRightAndDown(row: myRow+1, col: myCol)){
                print("if cannot move right or down, but can move up, then move up")
                move(direction: Direction.Up)
            }
            // if cannot move right or up or down, but can move left, then move left
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow)==nil && !obstaclesExistBothRightAndDown(row: myRow, col: myCol-1)){
                print("if cannot move right or up or down, but can move left, then move left")
                move(direction: Direction.Left)
            }
        }
        // if robot on the same vertical line as player
        else if(myCol==pCol){
            // player on robot's down
            if (myRow>pRow){
                if(obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-1)==nil){
                    print("if can move down, then move down")
                    move(direction: Direction.Down)
                }
            }
            // player on robot's up
            else if(myRow<pRow){
                if(obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+1)==nil){
                    print("if can move up, then move down")
                    move(direction: Direction.Up)
                }
            }
        }
        // if robot on the same horizontal line as player
        else if(myRow==pRow){
            // player on robot's left
            if (myCol>pCol){
                if(obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow)==nil){
                    print("if can move left, then move left")
                    move(direction: Direction.Left)
                }
            }
            // player on robot's right
            else if(myCol<pCol){
                if(obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow)==nil){
                    print("if can move right, then move right")
                    move(direction: Direction.Right)
                }
            }
        }
        // ------------------------------------------------------------------------------------------------------------ //
    }
    
    /*
     * Peace State of Robot
     */
    func peaceMode(){
       
        let robot_x = self.position.x
        let robot_y = self.position.y
        // first check if there are bubbles around, if there are, then dodge
        if foundAnyBubbleOnFourNearbyDiagonal(){
            ShiftDodgeDeployedBubble(imaginaryX: CGFloat(robot_x+20), imaginaryY: robot_y)
            ShiftDodgeDeployedBubble(imaginaryX: CGFloat(robot_x-20), imaginaryY: robot_y)
            ShiftDodgeDeployedBubble(imaginaryX: robot_x, imaginaryY: CGFloat(robot_y+20))
            ShiftDodgeDeployedBubble(imaginaryX: robot_x, imaginaryY: CGFloat(robot_y-20))
            return
        }
        else if foundAnyBubbleStandingOnOrHorizontallyOrVertically(){
            print("found bubble standing on / horizontally / vertically")
            DodgeDeployedBubble()
        }
        else if (self.bubble_number == self.max_bubble_number){
            print("looking around")
            lookAround()
        }
    }
    
    /*
     * Attack State of Robot
     */
    func attackMode(){
        
        let position = self.position;
        let myCol = obstaclesTileMap.tileColumnIndex(fromPosition: position)
        let myRow = obstaclesTileMap.tileRowIndex(fromPosition: position)
        
        let pPos = player.position
        let pCol = obstaclesTileMap.tileColumnIndex(fromPosition: pPos)
        let pRow = obstaclesTileMap.tileRowIndex(fromPosition: pPos)
        print("myColRow: ",myRow," ",myCol," P: ",pRow," ",pCol)
        
        if (moreThanOneBubbleFoundAround()){
            DodgeDeployedBubble()
        }
        else{
            if(myCol == pCol || myRow == pRow){
                // dropBubble()
                print("calling deploy")
                deploy()
            }
            else{
                moveTowardPlayer()
                // lookAround()
            }
        }
    }
    
    /*
     * Called every frame in GameScene's update function
     */
    func autoPlay(){
        print("------------------------------------------")
        print("Player Health: ",player.health,"| Robot Health: ",self.health)
        // player or the robot survives
        if(player.health>0 && self.health>0){
            
            // obtain the current tile that the robot is standing on at each frame
            let position = self.position
            let column = obstaclesTileMap.tileColumnIndex(fromPosition: position)
            let row = obstaclesTileMap.tileRowIndex(fromPosition: position)
            let tile = obstaclesTileMap.tileDefinition(atColumn: column, row: row)
            
            // check if there exits tools to collect on robot's current standing tile
            if (tile?.name == "bubble_add" || tile?.name == "fast" || tile?.name == "fire" || tile?.name == "power" || tile?.name == "shield"){
                self.acquireTools(toolTileColumn: column, toolTileRow: row, tileName: (tile?.name)!)
            }
            
            if (moreThanOneBubbleFoundAround()){
                print("attack")
                attackMode()
            }
            else if(DistanceFromPlayer()>70){
                print("peace")
                peaceMode()

            }
            else{
                print("attack")
                attackMode()
            }
        }
    }
    
    

    //////////////////////////////////// Auxiliary Functions ///////////////////////////////////////////
    let fadeOut = SKAction.fadeOut(withDuration: 0.1)
    let fadeIn = SKAction.fadeIn(withDuration: 0.1)
    
    func deploy() {
        let tileSet = SKTileSet(named: "Classic Map Tile Set")
        
        let position = self.position
        let column = obstaclesTileMap.tileColumnIndex(fromPosition: position)
        let row = obstaclesTileMap.tileRowIndex(fromPosition: position)
        let tile = obstaclesTileMap.tileDefinition(atColumn: column, row: row)
        if tile == nil {
            if (self.bubble_number > 0){
                
                /////////////////////////// if robot can deploy fire bubble ///////////////////////////
                if (self.fire > 0){
                    // deploy the fire bubble
                    print("robot deploy fire, robot fire #:",self.fire)
                    obstaclesTileMap.setTileGroup(tileSet?.tileGroups[53], forColumn: column, row: row)
                    
                    // decrease the robot's bubble capacity by 1
                    self.bubble_number = self.bubble_number - 1
                    
                    // decrease the robot's fire capacity by 1
                    self.fire = self.fire - 1
                    
                    // after 2 seconds, the bubble blasts
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                        self.blast(bubblePosition: position,fire: true)
                    })
                }
                /////////////////////////// if robot cannot deploy fire bubble ///////////////////////////
                else{
                    print("robot deploy bubble, robot fire #:",self.fire)
                    // deploy the bubble
                    obstaclesTileMap.setTileGroup(tileSet?.tileGroups[3], forColumn: column, row: row)
                    
                    // decrease the robot's bubble capacity by 1
                    self.bubble_number = self.bubble_number - 1
                    
                    // after 2 seconds, the bubble blasts
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                        self.blast(bubblePosition: position,fire: false)
                    })
                }
            }
        }
    }
    
    func blast(bubblePosition:CGPoint, fire:Bool){
        // create the action when a player is hurted by the bubble
        let fadeOutAndIn = SKAction.sequence([fadeOut,fadeIn])
        let playerHurtedAction = SKAction.repeat(fadeOutAndIn, count: 3)
        
        // get the tile that the player currently on
        let robotPosition = self.position
        let robotColumn = obstaclesTileMap.tileColumnIndex(fromPosition: robotPosition)
        let robotRow = obstaclesTileMap.tileRowIndex(fromPosition: robotPosition)
        
        let playerPosition = player.position
        let playerColumn = obstaclesTileMap.tileColumnIndex(fromPosition: playerPosition)
        let playerRow = obstaclesTileMap.tileRowIndex(fromPosition: playerPosition)
        
        let tileSet = SKTileSet(named: "Classic Map Tile Set")
        
        let column = obstaclesTileMap.tileColumnIndex(fromPosition: bubblePosition)
        let row = obstaclesTileMap.tileRowIndex(fromPosition: bubblePosition)
        
        //////////////////////////////////////// if the bubble is fire ////////////////////////////////////////
        if (fire){
            // blast in the center (i.e. the position where the bubble was deployed)
            let tileContentBeforeBlast = obstaclesTileMap.tileDefinition(atColumn: column, row: row)?.name
            // tileGroups[54] -> fire_blast
            obstaclesTileMap.setTileGroup(tileSet?.tileGroups[54], forColumn: column, row: row)
            // determine if player is affected by the blast of bubble
            if (robotColumn == column && robotRow == row){
                if (self.shield){
                    self.shield = false
                }else{
                    self.health = self.health - 2
                }
                self.run(playerHurtedAction)
            }
            if (playerColumn == column && playerRow == row){
                if (player.shield){
                    player.shield = false
                }else{
                    player.health = player.health - 2
                }
                player.run(playerHurtedAction)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.afterBlastTileTransform(blastedTileColumn: column, blastedTileRow: row, tileContentBeforeBlast: tileContentBeforeBlast)
            })
            
            // blast in the right direction
            for rangeIndex in 1...self.power {
                if (obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "obstacle" || obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "bubble" || obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "fire_bubble"){
                    break
                }
                else {
                    let tileContentBeforeBlast = obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name
                    // tileGroups[54] -> fire_blast
                    obstaclesTileMap.setTileGroup(tileSet?.tileGroups[54], forColumn: column+rangeIndex, row: row)
                    
                    // determine if player is affected by the blast of bubble
                    if (robotColumn == column+rangeIndex && robotRow == row){
                        if (self.shield){
                            self.shield = false
                        }else{
                            self.health = self.health - 2
                        }
                        self.run(playerHurtedAction)
                    }
                    if (playerColumn == column+rangeIndex && playerRow == row){
                        if (player.shield){
                            player.shield = false
                        }else{
                            player.health = player.health - 2
                        }
                        player.run(playerHurtedAction)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        self.afterBlastTileTransform(blastedTileColumn: column+rangeIndex, blastedTileRow: row, tileContentBeforeBlast: tileContentBeforeBlast)
                    })
                    if (tileContentBeforeBlast == "block"){
                        break
                    }
                }
            }
            
            // blast in the left direction
            for rangeIndex in 1...self.power {
                if (obstaclesTileMap.tileDefinition(atColumn: column-rangeIndex, row: row)?.name == "obstacle" || obstaclesTileMap.tileDefinition(atColumn: column-rangeIndex, row: row)?.name == "bubble" || obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "fire_bubble"){
                    break
                }
                else{
                    let tileContentBeforeBlast = obstaclesTileMap.tileDefinition(atColumn: column-rangeIndex, row: row)?.name
                    // tileGroups[54] -> fire_blast
                    obstaclesTileMap.setTileGroup(tileSet?.tileGroups[54], forColumn: column-rangeIndex, row: row)
                    
                    // determine if player is affected by the blast of bubble
                    if (robotColumn == column-rangeIndex && robotRow == row){
                        if (self.shield){
                            self.shield = false
                        }else{
                            self.health = self.health - 2
                        }
                        self.run(playerHurtedAction)
                    }
                    if (playerColumn == column-rangeIndex && playerRow == row){
                        if (player.shield){
                            player.shield = false
                        }else{
                            player.health = player.health - 2
                        }
                        player.run(playerHurtedAction)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        self.afterBlastTileTransform(blastedTileColumn: column-rangeIndex, blastedTileRow: row, tileContentBeforeBlast: tileContentBeforeBlast)
                    })
                    if (tileContentBeforeBlast == "block"){
                        break
                    }
                }
            }
            
            // blast in the up direction
            for rangeIndex in 1...self.power {
                if (obstaclesTileMap.tileDefinition(atColumn: column, row: row+rangeIndex)?.name == "obstacle" || obstaclesTileMap.tileDefinition(atColumn: column, row: row+rangeIndex)?.name == "bubble" || obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "fire_bubble"){
                    break
                }
                else{
                    let tileContentBeforeBlast = obstaclesTileMap.tileDefinition(atColumn: column, row: row+rangeIndex)?.name
                    // tileGroups[54] -> fire_blast
                    obstaclesTileMap.setTileGroup(tileSet?.tileGroups[54], forColumn: column, row: row+rangeIndex)
                    
                    // determine if player is affected by the blast of bubble
                    if (robotColumn == column && robotRow == row+rangeIndex){
                        if (self.shield){
                            self.shield = false
                        }else{
                            self.health = self.health - 2
                        }
                        self.run(playerHurtedAction)
                    }
                    if (playerColumn == column && playerRow == row+rangeIndex){
                        if (player.shield){
                            player.shield = false
                        }else{
                            player.health = player.health - 2
                        }
                        player.run(playerHurtedAction)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        self.afterBlastTileTransform(blastedTileColumn: column, blastedTileRow: row+rangeIndex, tileContentBeforeBlast: tileContentBeforeBlast)
                    })
                    if (tileContentBeforeBlast == "block"){
                        break
                    }
                }
            }
            
            // blast in the down direction
            for rangeIndex in 1...self.power {
                if (obstaclesTileMap.tileDefinition(atColumn: column, row: row-rangeIndex)?.name == "obstacle" || obstaclesTileMap.tileDefinition(atColumn: column, row: row-rangeIndex)?.name == "bubble" || obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "fire_bubble"){
                    break
                }
                else{
                    let tileContentBeforeBlast = obstaclesTileMap.tileDefinition(atColumn: column, row: row-rangeIndex)?.name
                    // tileGroups[54] -> fire_blast
                    obstaclesTileMap.setTileGroup(tileSet?.tileGroups[54], forColumn: column, row: row-rangeIndex)
                    
                    // determine if player is affected by the blast of bubble
                    if (robotColumn == column && robotRow == row-rangeIndex){
                        if (self.shield){
                            self.shield = false
                        }else{
                            self.health = self.health - 2
                        }
                        self.run(playerHurtedAction)
                    }
                    if (playerColumn == column && playerRow == row-rangeIndex){
                        if (player.shield){
                            player.shield = false
                        }else{
                            player.health = player.health - 2
                        }
                        player.run(playerHurtedAction)
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
            if (robotColumn == column && robotRow == row){
                if (self.shield){
                    self.shield = false
                }else{
                    self.health = self.health - 1
                }
                self.run(playerHurtedAction)
            }
            if (playerColumn == column && playerRow == row){
                if (player.shield){
                    player.shield = false
                }else{
                    player.health = player.health - 1
                }
                player.run(playerHurtedAction)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.afterBlastTileTransform(blastedTileColumn: column, blastedTileRow: row, tileContentBeforeBlast: tileContentBeforeBlast)
            })
            
            // blast in the right direction
            for rangeIndex in 1...self.power {
                if (obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "obstacle" || obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "bubble" || obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "fire_bubble"){
                    break
                }
                else {
                    let tileContentBeforeBlast = obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name
                    // tileGroups[4] -> blast
                    obstaclesTileMap.setTileGroup(tileSet?.tileGroups[4], forColumn: column+rangeIndex, row: row)
                    
                    // determine if player is affected by the blast of bubble
                    if (robotColumn == column+rangeIndex && robotRow == row){
                        if (self.shield){
                            self.shield = false
                        }else{
                            self.health = self.health - 1
                        }
                        self.run(playerHurtedAction)
                    }
                    if (playerColumn == column+rangeIndex && playerRow == row){
                        if (player.shield){
                            player.shield = false
                        }else{
                            player.health = player.health - 1
                        }
                        player.run(playerHurtedAction)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        self.afterBlastTileTransform(blastedTileColumn: column+rangeIndex, blastedTileRow: row, tileContentBeforeBlast: tileContentBeforeBlast)
                    })
                    if (tileContentBeforeBlast == "block"){
                        break
                    }
                }
            }
            
            // blast in the left direction
            for rangeIndex in 1...self.power {
                if (obstaclesTileMap.tileDefinition(atColumn: column-rangeIndex, row: row)?.name == "obstacle" || obstaclesTileMap.tileDefinition(atColumn: column-rangeIndex, row: row)?.name == "bubble" || obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "fire_bubble"){
                    break
                }
                else{
                    let tileContentBeforeBlast = obstaclesTileMap.tileDefinition(atColumn: column-rangeIndex, row: row)?.name
                    // tileGroups[4] -> blast
                    obstaclesTileMap.setTileGroup(tileSet?.tileGroups[4], forColumn: column-rangeIndex, row: row)
                    
                    // determine if player is affected by the blast of bubble
                    if (robotColumn == column-rangeIndex && robotRow == row){
                        if (self.shield){
                            self.shield = false
                        }else{
                            self.health = self.health - 1
                        }
                        self.run(playerHurtedAction)
                    }
                    if (playerColumn == column-rangeIndex && playerRow == row){
                        if (player.shield){
                            player.shield = false
                        }else{
                            player.health = player.health - 1
                        }
                        player.run(playerHurtedAction)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        self.afterBlastTileTransform(blastedTileColumn: column-rangeIndex, blastedTileRow: row, tileContentBeforeBlast: tileContentBeforeBlast)
                    })
                    if (tileContentBeforeBlast == "block"){
                        break
                    }
                }
            }
            
            // blast in the up direction
            for rangeIndex in 1...self.power {
                if (obstaclesTileMap.tileDefinition(atColumn: column, row: row+rangeIndex)?.name == "obstacle" || obstaclesTileMap.tileDefinition(atColumn: column, row: row+rangeIndex)?.name == "bubble" || obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "fire_bubble"){
                    break
                }
                else{
                    let tileContentBeforeBlast = obstaclesTileMap.tileDefinition(atColumn: column, row: row+rangeIndex)?.name
                    // tileGroups[4] -> blast
                    obstaclesTileMap.setTileGroup(tileSet?.tileGroups[4], forColumn: column, row: row+rangeIndex)
                    
                    // determine if player is affected by the blast of bubble
                    if (robotColumn == column && robotRow == row+rangeIndex){
                        if (self.shield){
                            self.shield = false
                        }else{
                            self.health = self.health - 1
                        }
                        self.run(playerHurtedAction)
                    }
                    if (playerColumn == column && playerRow == row+rangeIndex){
                        if (player.shield){
                            player.shield = false
                        }else{
                            player.health = player.health - 1
                        }
                        player.run(playerHurtedAction)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        self.afterBlastTileTransform(blastedTileColumn: column, blastedTileRow: row+rangeIndex, tileContentBeforeBlast: tileContentBeforeBlast)
                    })
                    if (tileContentBeforeBlast == "block"){
                        break
                    }
                }
            }
            
            // blast in the down direction
            for rangeIndex in 1...self.power {
                if (obstaclesTileMap.tileDefinition(atColumn: column, row: row-rangeIndex)?.name == "obstacle" || obstaclesTileMap.tileDefinition(atColumn: column, row: row-rangeIndex)?.name == "bubble" || obstaclesTileMap.tileDefinition(atColumn: column+rangeIndex, row: row)?.name == "fire_bubble"){
                    break
                }
                else{
                    let tileContentBeforeBlast = obstaclesTileMap.tileDefinition(atColumn: column, row: row-rangeIndex)?.name
                    // tileGroups[4] -> blast
                    obstaclesTileMap.setTileGroup(tileSet?.tileGroups[4], forColumn: column, row: row-rangeIndex)
                    
                    // determine if player is affected by the blast of bubble
                    if (robotColumn == column && robotRow == row-rangeIndex){
                        if (self.shield){
                            self.shield = false
                        }else{
                            self.health = self.health - 1
                        }
                        self.run(playerHurtedAction)
                    }
                    if (playerColumn == column && playerRow == row-rangeIndex){
                        if (player.shield){
                            player.shield = false
                        }else{
                            player.health = player.health - 1
                        }
                        player.run(playerHurtedAction)
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

        // add back the robot's bubble capacity by 1
        self.bubble_number = self.bubble_number + 1
        // print("health:",self.health)
    }
    
    func afterBlastTileTransform(blastedTileColumn:Int, blastedTileRow:Int, tileContentBeforeBlast:String?){
        let tileSet = SKTileSet(named: "Classic Map Tile Set")
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
    
    func move(direction: Direction) {
        switch(direction){
        case .Left:
            let robot_texture = SKTexture(imageNamed: "robot_left")
            self.texture = robot_texture
            self.hSpeed = -self.moveSpeed
            self.vSpeed = 0
            print("Left")
            // check if the new position the player will be moving to is accessible
            let newPosition1 = CGPoint(x: self.position.x - 45, y: self.position.y - 20)
            let newPosition2 = CGPoint(x: self.position.x - 45, y: self.position.y + 20)
            if checkBoundaries(position: newPosition1) && checkBoundaries(position: newPosition2){
                print("左")
                self.position.x = self.position.x + self.hSpeed * CGFloat(self.speed_level) * 0.5
            }
            else if !checkBoundaries(position: newPosition1) && checkBoundaries(position: newPosition2){
                print("往上挪然后左")
                let robot_texture = SKTexture(imageNamed: "robot_up")
                self.texture = robot_texture
                self.position.y = self.position.y + 1
            }
            else if checkBoundaries(position: newPosition1) && !checkBoundaries(position: newPosition2){
                print("往下挪然后左")
                let robot_texture = SKTexture(imageNamed: "robot_down")
                self.texture = robot_texture
                self.position.y = self.position.y - 1
            }
        case .Right:
            let robot_texture = SKTexture(imageNamed: "robot_right")
            self.texture = robot_texture
            self.hSpeed = self.moveSpeed
            self.vSpeed = 0
            print("Right")
            // check if the new position the player will be moving to is accessible
            let newPosition1 = CGPoint(x: self.position.x + 45, y: self.position.y - 20)
            let newPosition2 = CGPoint(x: self.position.x + 45, y: self.position.y + 20)
            if checkBoundaries(position: newPosition1) && checkBoundaries(position: newPosition2){
                print("右")
                self.position.x = self.position.x + self.hSpeed * CGFloat(self.speed_level) * 0.5
            }
            else if !checkBoundaries(position: newPosition1) && checkBoundaries(position: newPosition2){
                print("往上挪然后右")
                let robot_texture = SKTexture(imageNamed: "robot_up")
                self.texture = robot_texture
                self.position.y = self.position.y + 1
                
            }
            else if checkBoundaries(position: newPosition1) && !checkBoundaries(position: newPosition2){
                print("往下挪然后左")
                let robot_texture = SKTexture(imageNamed: "robot_down")
                self.texture = robot_texture
                self.position.y = self.position.y - 1
            }
        case .Up:
            let robot_texture = SKTexture(imageNamed: "robot_up")
            self.texture = robot_texture
            self.hSpeed = 0
            self.vSpeed = self.moveSpeed
            print("Up")
            // check if the new position the player will be moving to is accessible
            let newPosition1 = CGPoint(x: self.position.x + 20, y: self.position.y + 45)
            let newPosition2 = CGPoint(x: self.position.x - 20, y: self.position.y + 45)
            if checkBoundaries(position: newPosition1) && checkBoundaries(position: newPosition2){
                print("上")
                self.position.y = self.position.y + self.vSpeed * CGFloat(self.speed_level) * 0.5
            }
            else if !checkBoundaries(position: newPosition1) && checkBoundaries(position: newPosition2){
                print("往左挪然后上")
                let robot_texture = SKTexture(imageNamed: "robot_left")
                self.texture = robot_texture
                self.position.x = self.position.x - 1
            }
            else if checkBoundaries(position: newPosition1) && !checkBoundaries(position: newPosition2){
                print("往右挪然后上")
                let robot_texture = SKTexture(imageNamed: "robot_right")
                self.texture = robot_texture
                self.position.x = self.position.x + 1
            }
        case .Down:
            let robot_texture = SKTexture(imageNamed: "robot_down")
            self.texture = robot_texture
            self.hSpeed = 0
            self.vSpeed = -self.moveSpeed
            print("Down")
            // check if the new position the player will be moving to is accessible
            let newPosition1 = CGPoint(x: self.position.x - 20, y: self.position.y - 45)
            let newPosition2 = CGPoint(x: self.position.x + 20, y: self.position.y - 45)
            if checkBoundaries(position: newPosition1) && checkBoundaries(position: newPosition2){
                print("下")
                self.position.y = self.position.y + self.vSpeed * CGFloat(self.speed_level) * 0.5
            }
            else if !checkBoundaries(position: newPosition1) && checkBoundaries(position: newPosition2){
                print("往右挪然后下")
                let robot_texture = SKTexture(imageNamed: "robot_right")
                self.texture = robot_texture
                self.position.x = self.position.x + 1
            }
            else if checkBoundaries(position: newPosition1) && !checkBoundaries(position: newPosition2){
                print("往左挪然后下")
                let robot_texture = SKTexture(imageNamed: "robot_left")
                self.texture = robot_texture
                self.position.x = self.position.x - 1
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
    
    ////////////////////////////////////// Acquire Tools //////////////////////////////////////////
    func acquireTools (toolTileColumn:Int, toolTileRow:Int, tileName: String){
        switch(tileName){
        case "bubble_add":
            self.bubble_number = self.bubble_number + 1
            self.max_bubble_number = self.max_bubble_number + 1
            obstaclesTileMap.setTileGroup(nil, forColumn: toolTileColumn, row: toolTileRow)
        case "fast":
            let s = self.speed_level + 0.5
            self.speed_level = CGFloat.minimum(self.max_speed_level, s)
            obstaclesTileMap.setTileGroup(nil, forColumn: toolTileColumn, row: toolTileRow)
        case "fire":
            self.fire = self.fire + 1
            obstaclesTileMap.setTileGroup(nil, forColumn: toolTileColumn, row: toolTileRow)
        case "power":
            self.power = self.power + 1
            obstaclesTileMap.setTileGroup(nil, forColumn: toolTileColumn, row: toolTileRow)
        case "shield":
            self.shield = true
            obstaclesTileMap.setTileGroup(nil, forColumn: toolTileColumn, row: toolTileRow)
        default:
            break
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
}

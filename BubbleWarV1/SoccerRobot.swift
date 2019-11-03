//
//  Robot.swift
//  BubbleWarV1
//
//  Created by Junzhang Wang on 5/11/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class SoccerRobot: SKSpriteNode{
    
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
     * check surrounding tiles / pick up tools if found any
     */
    func collectItems(){
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
    }
    
    /*
     * check if there exists any bubble up or down at a position
     */
    func bubbleExistUpOrDown(imaginaryX: CGFloat, imaginaryY: CGFloat) -> Bool{
        let imaginaryPosition = CGPoint(x: imaginaryX, y: imaginaryY)
        let imaginaryColumn = obstaclesTileMap.tileColumnIndex(fromPosition: imaginaryPosition)
        let imaginaryRow = obstaclesTileMap.tileRowIndex(fromPosition: imaginaryPosition)
        
        let up  = obstaclesTileMap.tileDefinition(atColumn: imaginaryColumn, row: imaginaryRow+1)
        let down = obstaclesTileMap.tileDefinition(atColumn: imaginaryColumn, row: imaginaryRow-1)
        
        if(up != nil && (up!.name == "bubble")){
            return true
        }
        if(down != nil && (down!.name == "bubble")){
            return true
        }
        return false
    }
    
    /*
     * check if there exists any bubble left or right to a given position
     */
    func bubbleExistLeftOrRight(imaginaryX: CGFloat, imaginaryY: CGFloat) -> Bool{
        let imaginaryPosition = CGPoint(x: imaginaryX, y: imaginaryY)
        let imaginaryColumn = obstaclesTileMap.tileColumnIndex(fromPosition: imaginaryPosition)
        let imaginaryRow = obstaclesTileMap.tileRowIndex(fromPosition: imaginaryPosition)
        
        let left = obstaclesTileMap.tileDefinition(atColumn: imaginaryColumn-1, row: imaginaryRow)
        let right = obstaclesTileMap.tileDefinition(atColumn: imaginaryColumn+1, row: imaginaryRow)
        
        if(left != nil && (left!.name == "bubble")){
            return true
        }
        if(right != nil && (right!.name == "bubble")){
            return true
        }
        return false
    }
    
    //////////////////////////////////////// Auxiliary Functions //////////////////////////////////////////////
    func threatFromCurrentDirection()->Bool{
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        let current = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow)
        
        if(current != nil && current!.name == "bubble"){
            return true
        }
        else{
            return false
        }
        
    }
    func threatFromUpDirection()->Bool{
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        let up  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+1)
        
        if(up != nil && up!.name == "bubble"){
            return true
        }
        else{
            return false
        }
    }
    func threatFromUpDirectionAt(myCol:Int, myRow:Int)->Bool{
        let up  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+1)
        
        if(up != nil && up!.name == "bubble"){
            return true
        }
        else{
            return false
        }
    }
    func threatFromUpDirectionFrom(position: CGPoint)->Bool{
        let myCol = obstaclesTileMap.tileColumnIndex(fromPosition: position)
        let myRow = obstaclesTileMap.tileRowIndex(fromPosition: position)
        let up  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+1)
        
        if(up != nil && up!.name == "bubble"){
            return true
        }
        else{
            return false
        }
    }
    func canMoveUp()->Bool{
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        let up  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+1)
        
        if(up == nil){
            return true
        }
        else{
            return false
        }
    }
    func canMoveUpTwice()->Bool{
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        let up  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+1)
        let upTwo  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+2)
        
        if(up == nil && upTwo == nil){
            return true
        }
        else{
            return false
        }
    }
    func canKickUp()->Bool{
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
    
        let upTwo  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+2)
        
        if(upTwo == nil){
            return true
        }
        else{
            return false
        }
    }
    func canKickUpAt(myCol:Int, myRow:Int)->Bool{
        
        let upTwo  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+2)
        
        if(upTwo == nil){
            return true
        }
        else{
            return false
        }
    }
    func canKickUpFrom(position: CGPoint)->Bool{
        let myCol = obstaclesTileMap.tileColumnIndex(fromPosition: position)
        let myRow = obstaclesTileMap.tileRowIndex(fromPosition: position)
        let upTwo  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+2)
        
        if(upTwo == nil){
            return true
        }
        else{
            return false
        }
    }
    func threatFromDownirection()->Bool{
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        let down  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-1)

        if(down != nil && down!.name == "bubble"){
            return true
        }
        else{
            return false
        }
    }
    func threatFromDownirectionAt(myCol:Int, myRow:Int)->Bool{
        
        let down  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-1)
        
        if(down != nil && down!.name == "bubble"){
            return true
        }
        else{
            return false
        }
    }
    func threatFromDownirectionFrom(position:CGPoint)->Bool{
        let myCol = obstaclesTileMap.tileColumnIndex(fromPosition: position)
        let myRow = obstaclesTileMap.tileRowIndex(fromPosition: position)
        let down  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-1)
        
        if(down != nil && down!.name == "bubble"){
            return true
        }
        else{
            return false
        }
    }
    func canMoveDown()->Bool{
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        let down  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-1)
        
        if(down == nil){
            return true
        }
        else{
            return false
        }
    }
    func canMoveDownTwice()->Bool{
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        let down  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-1)
        let downTwo  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-2)
        if(down == nil && downTwo == nil){
            return true
        }
        else{
            return false
        }
    }
    func canKickDown()->Bool{
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        let downTwo  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-2)
        
        if(downTwo == nil){
            return true
        }
        else{
            return false
        }
    }
    func canKickDownAt(myCol:Int, myRow:Int)->Bool{
        
        let downTwo  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-2)
        
        if(downTwo == nil){
            return true
        }
        else{
            return false
        }
    }
    func canKickDownFrom(position: CGPoint)->Bool{
        let myCol = obstaclesTileMap.tileColumnIndex(fromPosition: position)
        let myRow = obstaclesTileMap.tileRowIndex(fromPosition: position)
        let downTwo  = obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-2)
        
        if(downTwo == nil){
            return true
        }
        else{
            return false
        }
    }
    func threatFromLeftDirection()->Bool{
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        let left  = obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow)
        
        if(left != nil && left!.name == "bubble"){
            return true
        }
        else{
            return false
        }
    }
    func threatFromLeftDirectionAt(myCol:Int, myRow:Int)->Bool{
        
        let left  = obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow)
        
        if(left != nil && left!.name == "bubble"){
            return true
        }
        else{
            return false
        }
    }
    func threatFromLeftDirectionFrom(position:CGPoint)->Bool{
        let myCol = obstaclesTileMap.tileColumnIndex(fromPosition: position)
        let myRow = obstaclesTileMap.tileRowIndex(fromPosition: position)
        let left  = obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow)
        
        if(left != nil && left!.name == "bubble"){
            return true
        }
        else{
            return false
        }
    }
    func canMoveLeft()->Bool{
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        let left  = obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow)
        
        if(left == nil){
            return true
        }
        else{
            return false
        }
    }
    func canMoveLeftTwice()->Bool{
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        let left  = obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow)
        let leftTwo  = obstaclesTileMap.tileDefinition(atColumn: myCol-2, row: myRow)
        
        if(left == nil && leftTwo == nil){
            return true
        }
        else{
            return false
        }
    }
    func canKickLeft()->Bool{
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        let leftTwo  = obstaclesTileMap.tileDefinition(atColumn: myCol-2, row: myRow)
        
        if(leftTwo == nil){
            return true
        }
        else{
            return false
        }
    }
    func canKickLeftAt(myCol:Int, myRow:Int)->Bool{
        
        let leftTwo  = obstaclesTileMap.tileDefinition(atColumn: myCol-2, row: myRow)
        
        if(leftTwo == nil){
            return true
        }
        else{
            return false
        }
    }
    func canKickLeftFrom(position: CGPoint)->Bool{
        let myCol = obstaclesTileMap.tileColumnIndex(fromPosition: position)
        let myRow = obstaclesTileMap.tileRowIndex(fromPosition: position)
        let leftTwo  = obstaclesTileMap.tileDefinition(atColumn: myCol-2, row: myRow)
        
        if(leftTwo == nil){
            return true
        }
        else{
            return false
        }
    }
    func threatFromRightDirection()->Bool{
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        let right  = obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow)
    
        if(right != nil && right!.name == "bubble"){
            return true
        }
        else{
            return false
        }
    }
    func threatFromRightDirectionAt(myCol:Int, myRow:Int)->Bool{
        
        let right  = obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow)
        
        if(right != nil && right!.name == "bubble"){
            return true
        }
        else{
            return false
        }
    }
    func threatFromRightDirectionFrom(position: CGPoint)->Bool{
        let myCol = obstaclesTileMap.tileColumnIndex(fromPosition: position)
        let myRow = obstaclesTileMap.tileRowIndex(fromPosition: position)
        let right  = obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow)
        
        if(right != nil && right!.name == "bubble"){
            return true
        }
        else{
            return false
        }
    }
    func canMoveRight()->Bool{
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        let right  = obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow)
        
        if(right == nil){
            return true
        }
        else{
            return false
        }
    }
    func canMoveRightTwice()->Bool{
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        let right  = obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow)
        let rightTwo  = obstaclesTileMap.tileDefinition(atColumn: myCol+2, row: myRow)
        
        if(right == nil && rightTwo == nil){
            return true
        }
        else{
            return false
        }
    }
    func canKickRight()->Bool{
        // get robot's current tile map position
        let arr = getMyColRow();
        let myRow = arr[0]
        let myCol = arr[1]
        
        let rightTwo  = obstaclesTileMap.tileDefinition(atColumn: myCol+2, row: myRow)
        
        if(rightTwo == nil){
            return true
        }
        else{
            return false
        }
    }
    func canKickRightAt(myCol:Int, myRow:Int)->Bool{

        let rightTwo  = obstaclesTileMap.tileDefinition(atColumn: myCol+2, row: myRow)
        
        if(rightTwo == nil){
            return true
        }
        else{
            return false
        }
    }
    func canKickRightFrom(position: CGPoint)->Bool{
        let myCol = obstaclesTileMap.tileColumnIndex(fromPosition: position)
        let myRow = obstaclesTileMap.tileRowIndex(fromPosition: position)
        let rightTwo  = obstaclesTileMap.tileDefinition(atColumn: myCol+2, row: myRow)
        
        if(rightTwo == nil){
            return true
        }
        else{
            return false
        }
    }
    
    /*
     * check if robot is safe currently
     */
    func safe()->Bool{
        if ( (!threatFromCurrentDirection()) && (!threatFromDownirection()) && (!threatFromLeftDirection()) && (!threatFromRightDirection()) && (!threatFromUpDirection()) ){
            return true
        }
        else{
            return false
        }
    }
    /*
     * check if robot will be safe at a particular location on the tile map
     */
    func safeAt(col:Int, row:Int)->Bool{
        if ((!threatFromDownirectionAt(myCol: col, myRow: row)) && (!threatFromUpDirectionAt(myCol: col, myRow: row)) && (!threatFromLeftDirectionAt(myCol: col, myRow: row)) && (!threatFromRightDirectionAt(myCol: col, myRow: row))){
            return true
        }
        else{
            return false
        }
    }
    
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
            if (obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow)==nil){
                print("if can move left, then move left")
                move(direction: Direction.Left)
            }
            // if cannot move left, but can move up, then move up
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+1)==nil){
                print("if cannot move left, but can move up, then move up")
                move(direction: Direction.Up)
            }
            // if cannot move left or up, but can move down, then move down
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-1)==nil){
                print("if cannot move left or up, but can move down, then move down")
                move(direction: Direction.Down)
            }
            // if cannot move left or up or down, but can move right, then move right
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow)==nil){
                print("if cannot move left or up or down, but can move right, then move right")
                move(direction: Direction.Right)
            }
        }
        // player on robot's upper right
        else if(myCol<pCol && myRow<pRow){
            print("player on robot's upper right")
            // if can move right, then move right
            if (obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow)==nil){
                print("if can move right, then move right")
                move(direction: Direction.Right)
            }
            // if cannot move right, but can move up, then move up
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+1)==nil){
                print("if cannot move right, but can move up, then move up")
                move(direction: Direction.Up)
            }
            // if cannot move right or up, but can move down, then move down
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-1)==nil){
                print("if cannot move right or up, but can move down, then move down")
                move(direction: Direction.Down)
            }
            // if cannot move right or up or down, but can move left, then move left
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow)==nil){
                print("if cannot move right or up or down, but can move left, then move left")
                move(direction: Direction.Left)
            }
        }
        // player on robot's lower left
        else if(myCol>pCol && myRow>pRow){
            print("player on robot's lower left")
            // if can move left, then move left
            if (obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow)==nil){
                print("if can move left, then move left")
                move(direction: Direction.Left)
            }
            // if cannot move left, but can move down, then move down
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-1)==nil){
                print("if cannot move left, but can move down, then move down")
                move(direction: Direction.Down)
            }
            // if cannot move left or down, but can move up, then move up
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+1)==nil){
                print("if cannot move left or down, but can move up, then move up")
                move(direction: Direction.Up)
            }
            // if cannot move left or up or down, but can move right, then move right
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow)==nil){
                print("if cannot move left or up or down, but can move right, then move right")
                move(direction: Direction.Right)
            }
        }
        // player on robot's lower right
        else if(myCol<pCol && myRow>pRow){
            print("player on robot's lower right")
            // if can move right, then move right
            if (obstaclesTileMap.tileDefinition(atColumn: myCol+1, row: myRow)==nil){
                print("if can move right, then move right")
                move(direction: Direction.Right)
            }
            // if cannot move right, but can move down, then move down
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow-1)==nil){
                print("if cannot move right, but can move down, then move down")
                move(direction: Direction.Down)
            }
            // if cannot move right or down, but can move up, then move up
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol, row: myRow+1)==nil){
                print("if cannot move right or down, but can move up, then move up")
                move(direction: Direction.Up)
            }
            // if cannot move right or up or down, but can move left, then move left
            else if(obstaclesTileMap.tileDefinition(atColumn: myCol-1, row: myRow)==nil){
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
     * Called every frame in GameScene's update function
     */
    func autoPlay(){
        print("------------------------------------------")
        print("Player Health: ",player.health,"| Robot Health: ",self.health)
        // player or the robot survives
        if(player.health>0 && self.health>0){
            
            // obtain the current tile that the robot is standing on at each frame
            let position = self.position
            let robotColumn = obstaclesTileMap.tileColumnIndex(fromPosition: position)
            let robotRow = obstaclesTileMap.tileRowIndex(fromPosition: position)
            let tile = obstaclesTileMap.tileDefinition(atColumn: robotColumn, row: robotRow)
            
            // obtain the current position of the robot
            let robot_x = self.position.x
            let robot_y = self.position.y
            
            // collect items if found nearby
            collectItems()
            if (tile?.name == "bubble_add" || tile?.name == "fast" || tile?.name == "fire" || tile?.name == "power" || tile?.name == "shield"){
                print("acuiqring tool")
                self.acquireTools(toolTileColumn: robotColumn, toolTileRow: robotRow, tileName: (tile?.name)!)
            }
            
            // if robot is safe, perform the following actions
            if (self.safe()){
                print("safe")
                if (DistanceFromPlayer() > 150){
                    moveTowardPlayer()
                    print("move to player")
                }
                
                if bubbleExistUpOrDown(imaginaryX: CGFloat(robot_x+20), imaginaryY: robot_y){
                    move(direction: Direction.Left)
                    print("adjust to left")
                }
                if bubbleExistUpOrDown(imaginaryX: CGFloat(robot_x-20), imaginaryY: robot_y){
                    move(direction: Direction.Right)
                    print("adjust to right")
                }
                if bubbleExistLeftOrRight(imaginaryX: robot_x, imaginaryY: CGFloat(robot_y+20)){
                    move(direction: Direction.Down)
                    print("adjust to down")
                }
                if bubbleExistLeftOrRight(imaginaryX: robot_x, imaginaryY: CGFloat(robot_y-20)){
                    move(direction: Direction.Up)
                    print("adjust to up")
                }
            }
            // if the robot is not safe, perform the following actions
            else{
                if ((threatFromUpDirection() && canKickUp()) || (threatFromDownirection() && canKickDown()) || (threatFromRightDirection() && canKickRight()) || (threatFromLeftDirection() && canKickLeft())){
                    if(threatFromUpDirection() && canKickUp()){
                        move(direction: Direction.Up)
                        print("kick up")
                    }
                    if(threatFromDownirection() && canKickDown()){
                        move(direction: Direction.Down)
                        print("kick down")
                    }
                    if(threatFromRightDirection() && canKickRight()){
                        move(direction: Direction.Right)
                        print("kick right")
                    }
                    if(threatFromLeftDirection() && canKickLeft()){
                        move(direction: Direction.Left)
                        print("kick left")
                    }
                }
                else{
                    if canMoveUpTwice() && safeAt(col: robotColumn, row: robotRow+2){
                        move(direction: Direction.Up)
                        print("move up twice")
                    }
                    else if canMoveLeftTwice() && safeAt(col: robotColumn-2, row: robotRow){
                        move(direction: Direction.Left)
                        print("move left twice")
                    }
                    else if canMoveDownTwice() && safeAt(col: robotColumn, row: robotRow-2){
                        move(direction: Direction.Down)
                        print("move down twice")
                    }
                    else if canMoveRightTwice() && safeAt(col: robotColumn+2, row: robotRow){
                        move(direction: Direction.Right)
                        print("move right twice")
                    }
                    else if canMoveUp() && safeAt(col: robotColumn, row: robotRow+1){// && !canKickDown()
                        move(direction: Direction.Up)
                        print("move up")
                    }
                    else if canMoveDown() && safeAt(col: robotColumn, row: robotRow-1){//&& !canKickUp()
                        move(direction: Direction.Down)
                        print("move down")
                    }
                    else if canMoveRight() && safeAt(col: robotColumn+1, row: robotRow){//&& !canKickLeft()
                        move(direction: Direction.Right)
                        print("move right")
                    }
                    else if canMoveLeft() && safeAt(col: robotColumn-1, row: robotRow) {//&& !canKickRight()
                        move(direction: Direction.Left)
                        print("move left")
                    }
                }
            }
        }
    }
    
    

    //////////////////////////////////////////////////// Auxiliary Functions //////////////////////////////////////////////////
    let fadeOut = SKAction.fadeOut(withDuration: 0.1)
    let fadeIn = SKAction.fadeIn(withDuration: 0.1)
    
    //////////////////////////////////////////////// Kick Bubble Functions /////////////////////////////////////////////////
    func bubbleKickedUp (bubbleCol: Int, bubbleRow: Int){
        let tileSet = SKTileSet(named: "Classic Map Tile Set")
        if(obstaclesTileMap.tileDefinition(atColumn: bubbleCol, row: bubbleRow+1) != nil){
            return
        }
        if(obstaclesTileMap.tileDefinition(atColumn: bubbleCol, row: bubbleRow+1) == nil){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.04, execute: {
                self.obstaclesTileMap.setTileGroup(nil, forColumn: bubbleCol, row: bubbleRow)
                self.obstaclesTileMap.setTileGroup(tileSet?.tileGroups[3], forColumn: bubbleCol, row: bubbleRow+1)
            })
        }
        if(obstaclesTileMap.tileDefinition(atColumn: bubbleCol, row: bubbleRow+2) != nil){
            return
        }
        if(obstaclesTileMap.tileDefinition(atColumn: bubbleCol, row: bubbleRow+2) == nil){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08, execute: {
                self.obstaclesTileMap.setTileGroup(nil, forColumn: bubbleCol, row: bubbleRow+1)
                self.obstaclesTileMap.setTileGroup(tileSet?.tileGroups[3], forColumn: bubbleCol, row: bubbleRow+2)
            })
        }
        if(obstaclesTileMap.tileDefinition(atColumn: bubbleCol, row: bubbleRow+3) == nil){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12, execute: {
                self.obstaclesTileMap.setTileGroup(nil, forColumn: bubbleCol, row: bubbleRow+2)
                self.obstaclesTileMap.setTileGroup(tileSet?.tileGroups[3], forColumn: bubbleCol, row: bubbleRow+3)
            })
        }
    }
    
    func bubbleKickedDown (bubbleCol: Int, bubbleRow: Int){
        let tileSet = SKTileSet(named: "Classic Map Tile Set")
        if(obstaclesTileMap.tileDefinition(atColumn: bubbleCol, row: bubbleRow-1) != nil){
            return
        }
        if(obstaclesTileMap.tileDefinition(atColumn: bubbleCol, row: bubbleRow-1) == nil){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.04, execute: {
                self.obstaclesTileMap.setTileGroup(nil, forColumn: bubbleCol, row: bubbleRow)
                self.obstaclesTileMap.setTileGroup(tileSet?.tileGroups[3], forColumn: bubbleCol, row: bubbleRow-1)
            })
        }
        if(obstaclesTileMap.tileDefinition(atColumn: bubbleCol, row: bubbleRow-2) != nil){
            return
        }
        if(obstaclesTileMap.tileDefinition(atColumn: bubbleCol, row: bubbleRow-2) == nil){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08, execute: {
                self.obstaclesTileMap.setTileGroup(nil, forColumn: bubbleCol, row: bubbleRow-1)
                self.obstaclesTileMap.setTileGroup(tileSet?.tileGroups[3], forColumn: bubbleCol, row: bubbleRow-2)
            })
        }
        
        if(obstaclesTileMap.tileDefinition(atColumn: bubbleCol, row: bubbleRow-3) == nil){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12, execute: {
                self.obstaclesTileMap.setTileGroup(nil, forColumn: bubbleCol, row: bubbleRow-2)
                self.obstaclesTileMap.setTileGroup(tileSet?.tileGroups[3], forColumn: bubbleCol, row: bubbleRow-3)
            })
        }
    }
    
    func bubbleKickedLeft (bubbleCol: Int, bubbleRow: Int){
        let tileSet = SKTileSet(named: "Classic Map Tile Set")
        if(obstaclesTileMap.tileDefinition(atColumn: bubbleCol-1, row: bubbleRow) != nil){
            return
        }
        if(obstaclesTileMap.tileDefinition(atColumn: bubbleCol-1, row: bubbleRow) == nil){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.04, execute: {
                self.obstaclesTileMap.setTileGroup(nil, forColumn: bubbleCol, row: bubbleRow)
                self.obstaclesTileMap.setTileGroup(tileSet?.tileGroups[3], forColumn: bubbleCol-1, row: bubbleRow)
            })
        }
        if(obstaclesTileMap.tileDefinition(atColumn: bubbleCol-2, row: bubbleRow) != nil){
            return
        }
        if(obstaclesTileMap.tileDefinition(atColumn: bubbleCol-2, row: bubbleRow) == nil){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08, execute: {
                self.obstaclesTileMap.setTileGroup(nil, forColumn: bubbleCol-1, row: bubbleRow)
                self.obstaclesTileMap.setTileGroup(tileSet?.tileGroups[3], forColumn: bubbleCol-2, row: bubbleRow)
            })
        }
        
        if(obstaclesTileMap.tileDefinition(atColumn: bubbleCol-3, row: bubbleRow) == nil){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12, execute: {
                self.obstaclesTileMap.setTileGroup(nil, forColumn: bubbleCol-2, row: bubbleRow)
                self.obstaclesTileMap.setTileGroup(tileSet?.tileGroups[3], forColumn: bubbleCol-3, row: bubbleRow)
            })
        }
    }
    
    func bubbleKickedRight (bubbleCol: Int, bubbleRow: Int){
        let tileSet = SKTileSet(named: "Classic Map Tile Set")
        if(obstaclesTileMap.tileDefinition(atColumn: bubbleCol+1, row: bubbleRow) != nil){
            return
        }
        if(obstaclesTileMap.tileDefinition(atColumn: bubbleCol+1, row: bubbleRow) == nil){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.04, execute: {
                self.obstaclesTileMap.setTileGroup(nil, forColumn: bubbleCol, row: bubbleRow)
                self.obstaclesTileMap.setTileGroup(tileSet?.tileGroups[3], forColumn: bubbleCol+1, row: bubbleRow)
            })
        }
        if(obstaclesTileMap.tileDefinition(atColumn: bubbleCol+2, row: bubbleRow) != nil){
            return
        }
        if(obstaclesTileMap.tileDefinition(atColumn: bubbleCol+2, row: bubbleRow) == nil){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08, execute: {
                self.obstaclesTileMap.setTileGroup(nil, forColumn: bubbleCol+1, row: bubbleRow)
                self.obstaclesTileMap.setTileGroup(tileSet?.tileGroups[3], forColumn: bubbleCol+2, row: bubbleRow)
            })
        }
        
        if(obstaclesTileMap.tileDefinition(atColumn: bubbleCol+3, row: bubbleRow) == nil){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12, execute: {
                self.obstaclesTileMap.setTileGroup(nil, forColumn: bubbleCol+2, row: bubbleRow)
                self.obstaclesTileMap.setTileGroup(tileSet?.tileGroups[3], forColumn: bubbleCol+3, row: bubbleRow)
            })
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    func move(direction: Direction) {
        switch(direction){
        case .Left:
            let robot_texture = SKTexture(imageNamed: "robot_left")
            self.texture = robot_texture
            self.hSpeed = -self.moveSpeed
            self.vSpeed = 0
            
            let robotCol = obstaclesTileMap.tileColumnIndex(fromPosition: self.position)
            let robotRow = obstaclesTileMap.tileRowIndex(fromPosition: self.position)
            
            print("Left")
            // check if the new position the player will be moving to is accessible
            let newPosition1 = CGPoint(x: self.position.x - 45, y: self.position.y - 20)
            let newPosition2 = CGPoint(x: self.position.x - 45, y: self.position.y + 20)
            let positionBitDown = CGPoint(x: self.position.x, y: self.position.y - 25)
            let positionBitUp = CGPoint(x: self.position.x, y: self.position.y + 25)
            if checkBoundaries(position: newPosition1) && checkBoundaries(position: newPosition2){
                print("左")
                self.position.x = self.position.x + self.hSpeed * CGFloat(self.speed_level) * 0.5
            }
            /*
            else if threatFromLeftDirectionFrom(position: positionBitDown) && canKickLeftFrom(position: positionBitDown){
                print("往下挪然后左踢")
                let robot_texture = SKTexture(imageNamed: "robot_down")
                self.texture = robot_texture
                self.position.y = self.position.y - 1
            }
            else if threatFromLeftDirectionFrom(position: positionBitUp) && canKickLeftFrom(position: positionBitUp){
                print("往上挪然后左踢")
                let robot_texture = SKTexture(imageNamed: "robot_up")
                self.texture = robot_texture
                self.position.y = self.position.y + 1
            }
            */
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
            else if checkExistsBubble(position: newPosition1) || checkExistsBubble(position: newPosition2){
                bubbleKickedLeft(bubbleCol: robotCol-1, bubbleRow: robotRow)
            }
        case .Right:
            let robot_texture = SKTexture(imageNamed: "robot_right")
            self.texture = robot_texture
            self.hSpeed = self.moveSpeed
            self.vSpeed = 0
            
            let robotCol = obstaclesTileMap.tileColumnIndex(fromPosition: self.position)
            let robotRow = obstaclesTileMap.tileRowIndex(fromPosition: self.position)
            
            print("Right")
            // check if the new position the player will be moving to is accessible
            let newPosition1 = CGPoint(x: self.position.x + 45, y: self.position.y - 20)
            let newPosition2 = CGPoint(x: self.position.x + 45, y: self.position.y + 20)
            let positionBitDown = CGPoint(x: self.position.x, y: self.position.y - 20)
            let positionBitUp = CGPoint(x: self.position.x, y: self.position.y + 20)
            
            if checkBoundaries(position: newPosition1) && checkBoundaries(position: newPosition2){
                print("右")
                self.position.x = self.position.x + self.hSpeed * CGFloat(self.speed_level) * 0.5
            }
            /*
            else if threatFromRightDirectionFrom(position: positionBitDown) && canKickRightFrom(position: positionBitDown){
                print("往下挪然后右踢")
                let robot_texture = SKTexture(imageNamed: "robot_down")
                self.texture = robot_texture
                self.position.y = self.position.y - 1
            }
            else if threatFromRightDirectionFrom(position: positionBitUp) && canKickRightFrom(position: positionBitUp){
                print("往上挪然后右踢")
                let robot_texture = SKTexture(imageNamed: "robot_up")
                self.texture = robot_texture
                self.position.y = self.position.y + 1
            }
            */
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
            else if checkExistsBubble(position: newPosition1) || checkExistsBubble(position: newPosition2){
                
                bubbleKickedRight(bubbleCol: robotCol+1, bubbleRow: robotRow)
            }
            
        case .Up:
            let robot_texture = SKTexture(imageNamed: "robot_up")
            self.texture = robot_texture
            self.hSpeed = 0
            self.vSpeed = self.moveSpeed
            
            let robotCol = obstaclesTileMap.tileColumnIndex(fromPosition: self.position)
            let robotRow = obstaclesTileMap.tileRowIndex(fromPosition: self.position)
            
            print("Up")
            // check if the new position the player will be moving to is accessible
            let newPosition1 = CGPoint(x: self.position.x + 20, y: self.position.y + 45)
            let newPosition2 = CGPoint(x: self.position.x - 20, y: self.position.y + 45)
            let positionBitRight = CGPoint(x: self.position.x + 20, y: self.position.y)
            let positionBitLeft = CGPoint(x: self.position.x - 20, y: self.position.y)
            if checkBoundaries(position: newPosition1) && checkBoundaries(position: newPosition2){
                print("上")
                self.position.y = self.position.y + self.vSpeed * CGFloat(self.speed_level) * 0.5
            }
            /*
            else if threatFromUpDirectionFrom(position: positionBitRight) && canKickUpFrom(position: positionBitRight){
                print("往右挪然后上踢")
                let robot_texture = SKTexture(imageNamed: "robot_right")
                self.texture = robot_texture
                self.position.x = self.position.x + 1
            }
            else if threatFromUpDirectionFrom(position: positionBitLeft) && canKickUpFrom(position: positionBitLeft){
                print("往左挪然后上踢")
                let robot_texture = SKTexture(imageNamed: "robot_left")
                self.texture = robot_texture
                self.position.x = self.position.x - 1
            }
            */
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
            else if checkExistsBubble(position: newPosition1) || checkExistsBubble(position: newPosition2){
                
                bubbleKickedUp(bubbleCol: robotCol, bubbleRow: robotRow+1)
            }
            
        case .Down:
            let robot_texture = SKTexture(imageNamed: "robot_down")
            self.texture = robot_texture
            self.hSpeed = 0
            self.vSpeed = -self.moveSpeed
            
            let robotCol = obstaclesTileMap.tileColumnIndex(fromPosition: self.position)
            let robotRow = obstaclesTileMap.tileRowIndex(fromPosition: self.position)
            
            print("Down")
            // check if the new position the player will be moving to is accessible
            let newPosition1 = CGPoint(x: self.position.x - 20, y: self.position.y - 45)
            let newPosition2 = CGPoint(x: self.position.x + 20, y: self.position.y - 45)
            let positionBitLeft = CGPoint(x: self.position.x - 20, y: self.position.y)
            let positionBitRight = CGPoint(x: self.position.x + 20, y: self.position.y)
            
            if checkBoundaries(position: newPosition1) && checkBoundaries(position: newPosition2){
                print("下")
                self.position.y = self.position.y + self.vSpeed * CGFloat(self.speed_level) * 0.5
            }
            /*
            else if threatFromDownirectionFrom(position: positionBitLeft) && canKickDownFrom(position: positionBitLeft){
                print("往左挪然后下踢")
                let robot_texture = SKTexture(imageNamed: "robot_left")
                self.texture = robot_texture
                self.position.x = self.position.x - 1
            }
            else if threatFromDownirectionFrom(position: positionBitRight) && canKickDownFrom(position: positionBitRight){
                print("往右挪然后下踢")
                let robot_texture = SKTexture(imageNamed: "robot_right")
                self.texture = robot_texture
                self.position.x = self.position.x + 1
            }
            */
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
            else if checkExistsBubble(position: newPosition1) || checkExistsBubble(position: newPosition2){
                bubbleKickedDown(bubbleCol: robotCol, bubbleRow: robotRow-1)
            }
            
        default:
            break
        }
    }
    
    func checkExistsBubble(position:CGPoint) -> Bool{
        let column = obstaclesTileMap.tileColumnIndex(fromPosition: position)
        let row = obstaclesTileMap.tileRowIndex(fromPosition: position)
        let tile = obstaclesTileMap.tileDefinition(atColumn: column, row: row)
        if tile?.name == "bubble" {
            return true
        }
        else {
            return false
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
}

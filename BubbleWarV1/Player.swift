//
//  Player.swift
//  BubbleWarV1
//
//  Created by Junzhang Wang on 4/16/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import GameplayKit
import SpriteKit

class Player: SKSpriteNode{
    
    // move speed is the basic speed of the player
    var moveSpeed : CGFloat = 4
    var hSpeed : CGFloat = 0 
    var vSpeed : CGFloat = 0
    
    // speed level is used when calculating the displacement of the player on the map
    var speed_level : CGFloat = 1.0
    let max_speed_level: CGFloat = 3.0
    
    // basic initial attributes of the player
    var health : Int = 3
    var power : Int = 1
    var bubble_number : Int = 1
    var shield : Bool = false
    var fire : Int = 0
}

//
//  ControlInputHandler.swift
//  BubbleWarV1
//
//  Created by Junzhang Wang on 4/16/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import Foundation

/*
 * Enables the controller component to handle all messages received from the Controller node
 * Extended by Controller component
 */
protocol ControlInputHandler : class {
    func follow(command: String?)
}

//
//  Stopwatch.swift
//  StopwatchDemo
//
//  Created by Jater on 2018/9/18.
//  Copyright © 2018年 Jater. All rights reserved.
//

import UIKit

class Stopwatch: NSObject {
    var counter: Double
    var timer: Timer
    
    override init() {
        counter = 0.0
        timer = Timer()
    }
}

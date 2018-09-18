//
//  ViewController.swift
//  StopwatchDemo
//
//  Created by Jater on 2018/9/18.
//  Copyright © 2018年 Jater. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Variables
    fileprivate var lapsArray: [String] = []
    fileprivate var isPlay: Bool = false
    fileprivate let mainStopwatch: Stopwatch = Stopwatch()
    fileprivate let lapStopwatch: Stopwatch = Stopwatch()
    
    //MARK: - UI
    @IBOutlet weak var secLabel: UILabel!
    @IBOutlet weak var mainSecLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initCircleButton : (UIButton) -> Void = {button in
            button.layer.cornerRadius = 40
            button.layer.borderColor = UIColor.red.cgColor
            button.layer.borderWidth = 1;
        }
        
        initCircleButton(startButton)
        initCircleButton(lapButton)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Event Response
    
    @IBAction func startTimerAction(_ sender: Any) {
        changeButton(button: startButton, title: "Stop", titleColor: UIColor.red)
        
        if !isPlay {
            mainStopwatch.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
                
            })
        }
        
    }
    
    @IBAction func lapAction(_ sender: Any) {
    }
    
    
    fileprivate func changeButton(button: UIButton, title: String, titleColor: UIColor) {
        button.setTitle(title, for: UIControlState.normal)
        button.setTitleColor(titleColor, for: UIControlState.normal)
    }
    
    
    // MARK: - UITableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
    
        if let lapNumber = cell.viewWithTag(11) as? UILabel {
            lapNumber.text = "Lap \(lapsArray.count - (indexPath as NSIndexPath).row)"
        }
        
        if let labelTimer = cell.viewWithTag(12) as? UILabel {
            labelTimer.text = lapsArray[lapsArray.count - (indexPath as NSIndexPath).row - 1]
        }
        return cell
    }
    
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }


}

// MARK: - Extension
//https://www.jianshu.com/p/783df05a9b59 对extension的语法介绍
fileprivate extension Selector {
    static let updateMainTimer = #selector(ViewController.)
}


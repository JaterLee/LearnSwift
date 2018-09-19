//
//  ViewController.swift
//  StopwatchDemo
//
//  Created by Jater on 2018/9/18.
//  Copyright © 2018年 Jater. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Variables
    fileprivate var lapsArray: [String] = []
    fileprivate var isPlay: Bool = false
    fileprivate let mainStopwatch: Stopwatch = Stopwatch()
    fileprivate let lapStopwatch: Stopwatch = Stopwatch()
    fileprivate let duration: Double = 0.035
    
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
        //点击开始按钮 更新左边lap按钮状态
        lapButton.isEnabled = true
        changeButton(lapButton, title: "Lap", titleColor: UIColor.red)
        
        //如果当前没有在播放
        if !isPlay {
            //初始化两个定时器
            mainStopwatch.timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: Selector.updateMainTimer, userInfo: nil, repeats: true)
            lapStopwatch.timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: Selector.updateLapTimer, userInfo: nil, repeats: true)
            
            RunLoop.current.add(mainStopwatch.timer, forMode: RunLoopMode.commonModes)
            RunLoop.current.add(lapStopwatch.timer, forMode: RunLoopMode.commonModes)
            
            isPlay = true
            changeButton(startButton, title: "stop", titleColor: .red)
        } else {
            //干掉两个定时器
            mainStopwatch.timer.invalidate()
            lapStopwatch.timer.invalidate()
            isPlay = false
            changeButton(startButton, title: "Start", titleColor: .blue)
            changeButton(lapButton, title: "Reset", titleColor: .black)
        }
        
    }
    
    @IBAction func lapAction(_ sender: Any) {
        if !isPlay {
            resetMainTimer()
            resetLapTimer()
            changeButton(lapButton, title: "Lap", titleColor: .lightGray)
            lapButton.isEnabled = false
        } else {
            if let timerLabelText = mainSecLabel.text {
                lapsArray.append(timerLabelText)
            }
            tableView.reloadData()
            resetLapTimer()
            lapStopwatch.timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: Selector.updateLapTimer, userInfo: nil, repeats: true);
            
            RunLoop.current.add(lapStopwatch.timer, forMode: .commonModes)
        }
    }
    

}

// MARK: - UITableView DataSource
extension ViewController: UITableViewDataSource {
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
    
    
    @objc func updateMainTimer() {
        print("main------\(Date())-----")
        updateTimer(mainStopwatch, label: mainSecLabel)
    }
    
    @objc func updateLipTimer() {
        print("lap------\(Date())-----")
        updateTimer(lapStopwatch, label: secLabel)
    }
    
}

// MARK: - UITableView Delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}



// MARK: - Extension
//https://www.jianshu.com/p/783df05a9b59 对extension的语法介绍 以及和OC的category的区别
fileprivate extension Selector {
    /*
     swift中使用 static 描述属性或者方法的类型作用域  但是所有修饰的属性或者方法都不可以被重写  也就是说static 包含了 final关键字的特性
     
     通过字符串构造 Selector 变量是一种方法，但是当在上例中 Xcode 会提示这样的警告：「Use '#selector' instead of explicitly constructing a 'Selector'」。即使用 #selector() 代替字符串明确构造 Selector。
     
     */
    static let updateMainTimer = #selector(ViewController.updateMainTimer)
    static let updateLapTimer = #selector(ViewController.updateLipTimer)
}

// MARK: - Private Helpers
fileprivate extension ViewController {
    func changeButton(_ button: UIButton, title: String, titleColor: UIColor) {
        button.setTitle(title, for: UIControlState.normal)
        button.setTitleColor(titleColor, for: UIControlState.normal)
        button.layer.borderColor = button.currentTitleColor.cgColor
    }
    
    func updateTimer(_ stopwatch: Stopwatch, label: UILabel) {
        stopwatch.counter += duration
        var mintes: String = "\((Int)(stopwatch.counter / 60))"
        if (Int)(stopwatch.counter / 60) < 10 {
            mintes = "0\((Int)(stopwatch.counter / 60))"
        }
        
        //truncatingRemainder 取余
        var seconds: String = String(format: "%.2f", (stopwatch.counter.truncatingRemainder(dividingBy: 60)))
        if stopwatch.counter.truncatingRemainder(dividingBy: 60) < 10 {
            seconds = "0" + seconds
        }
        label.text = mintes + ":" + seconds
    }
    
    func resetMainTimer() {
        resetTimer(mainStopwatch, label: mainSecLabel)
    }
    
    func resetLapTimer() {
        resetTimer(lapStopwatch, label: secLabel)
    }
    
    func resetTimer(_ stopwatch: Stopwatch, label: UILabel) {
        stopwatch.timer.invalidate()
        stopwatch.counter = 0.0
        label.text = "00:00:00"
    }
}


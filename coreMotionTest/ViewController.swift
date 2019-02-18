//
//  ViewController.swift
//  coreMotionTest
//
//  Created by Ｍ200_Macbook_Pro on 2019/2/11.
//  Copyright © 2019 ITRI. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    let motionManager = CMMotionManager()
//    let sensorRecorder = CMSensorRecorder()
    var timer: Timer!

    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var waveformView: WaveformView!
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    
    let green = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
    let red = #colorLiteral(red: 0.9774432778, green: 0, blue: 0, alpha: 1)
    var isRecord = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUI()
        
        motionManager.accelerometerUpdateInterval = 0.01
       
//        sensorRecorder.recordAccelerometer(forDuration: 0.2)
        
    }
    
    func loadUI() {
        setBtnCorner(btn: recordBtn)
    }
    
    func setBtnCorner(btn: UIButton) {
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        btn.layer.masksToBounds = false
        btn.layer.shadowRadius = 2.0
        btn.layer.shadowOpacity = 0.5
        btn.layer.cornerRadius = 20.0
    }
    
    
    @IBAction func recordAccelerData(_ sender: UIButton) {
        if isRecord {
            isRecord.toggle()
            recordBtn.setTitle("Start!", for: .normal)
            recordBtn.backgroundColor = green
            motionManager.stopDeviceMotionUpdates()
            timer.invalidate()
        } else {
            isRecord.toggle()
            recordBtn.setTitle("Recording ...", for: .normal)
            recordBtn.backgroundColor = red
            motionManager.startDeviceMotionUpdates()
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
        }
    }
    
    @objc func update() {
//        if let accelerometerData = motionManager.accelerometerData {
//            print("accelerometerData: ")
//            print(accelerometerData.acceleration)
//        }
//        if let gyroData = motionManager.gyroData {
//            print("gyroData: ")
//            print(gyroData.rotationRate)
//        }
        if let deviceMotion = motionManager.deviceMotion {
//            print("userAcceleration in deviceMotion:")
//            print(deviceMotion.userAcceleration)
            
            waveformView.pushSignal1BySliding(newValue: CGFloat(deviceMotion.userAcceleration.x))
            waveformView.pushSignal2BySliding(newValue: CGFloat(deviceMotion.userAcceleration.y))
            waveformView.pushSignal3BySliding(newValue: CGFloat(deviceMotion.userAcceleration.z))
            
            if (waveformView.signal1Index % 100 == 0) {
                xLabel.text = String(format: "X: Max: %5f , min: %5f ",
                                     waveformView.signal1Max, waveformView.signal1Min)
                yLabel.text = String(format: "Y: Max: %5f , min: %5f ",
                                     waveformView.signal2Max, waveformView.signal2Min)
                zLabel.text = String(format: "Z: Max: %5f , min: %5f ",
                                     waveformView.signal3Max, waveformView.signal3Min)
            }
        }
    }
}


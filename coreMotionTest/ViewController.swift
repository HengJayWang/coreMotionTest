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
    @IBOutlet weak var waveformView2: WaveformView!
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    
    let green = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
    let red = #colorLiteral(red: 0.9774432778, green: 0, blue: 0, alpha: 1)
    var isRecord = false
    var alpha: CGFloat = 0.0
    var one_alpha: CGFloat = 0.0
    var fs: CGFloat = 100.0
    var fc: CGFloat = 20.0
    var RC: CGFloat = 0.0
    var dT: CGFloat = 0.0
    var lastAcceleration: [CGFloat] = [0.0, 0.0, 0.0]
    var currentAcceleration: [CGFloat] = [0.0, 0.0, 0.0]
    var averageLength = 100
    
    var originalX = [CGFloat](repeating: 0.0, count: 2000)
    var originalY = [CGFloat](repeating: 0.0, count: 2000)
    var originalZ = [CGFloat](repeating: 0.0, count: 2000)
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadUI()
        setParameters()
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
    
    func setParameters() {
        dT = 1.0 / fs
        motionManager.accelerometerUpdateInterval = Double(dT)
        RC = 1.0 / (2 * CGFloat.pi * fc)
        alpha = dT / (RC + dT)
        one_alpha = 1 -  alpha
        print("Check parameter: ")
        print("fs: \(fs), fc: \(fc), update interval: \(motionManager.accelerometerUpdateInterval)")
        print("dT: \(dT), RC: \(RC)")
        print("alpha: \(alpha), one_alpha: \(one_alpha)")
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

        if let deviceMotion = motionManager.deviceMotion {
            
            originalX[index] = CGFloat(deviceMotion.userAcceleration.x)
            originalY[index] = CGFloat(deviceMotion.userAcceleration.y)
            originalZ[index] = CGFloat(deviceMotion.userAcceleration.z)
            
            waveformView2.pushSignal1BySliding(newValue: originalX[index])
            waveformView2.pushSignal2BySliding(newValue: originalY[index])
            waveformView2.pushSignal3BySliding(newValue: originalZ[index])
            
            if (index - averageLength + 1) < 0 {
                let arrayX = originalX[(originalX.count - averageLength + index + 1)...(originalX.count - 1)] + originalX[0...index]
                let arrayY = originalY[(originalY.count - averageLength + index + 1)...(originalY.count - 1)] + originalY[0...index]
                let arrayZ = originalZ[(originalZ.count - averageLength + index + 1)...(originalZ.count - 1)] + originalZ[0...index]
                waveformView.pushSignal1BySliding(newValue: arrayX.average)
                waveformView.pushSignal2BySliding(newValue: arrayY.average)
                waveformView.pushSignal3BySliding(newValue: arrayZ.average)
            } else {
                let arrayX = originalX[(index - averageLength + 1)...index]
                let arrayY = originalY[(index - averageLength + 1)...index]
                let arrayZ = originalZ[(index - averageLength + 1)...index]
                
                waveformView.pushSignal1BySliding(newValue: arrayX.average)
                waveformView.pushSignal2BySliding(newValue: arrayY.average)
                waveformView.pushSignal3BySliding(newValue: arrayZ.average)
            }

            if (waveformView.signal1Index % 100 == 0) {
                xLabel.text = String(format: "X: Max: %6f, min: %6f, scale: %6f ",
                                     waveformView.signal1Max, waveformView.signal1Min, waveformView.signal1Scale)
                yLabel.text = String(format: "Y: Max: %6f, min: %6f, scale: %6f ",
                                     waveformView.signal2Max, waveformView.signal2Min, waveformView.signal2Scale)
                zLabel.text = String(format: "Z: Max: %6f, min: %6f, scale: %6f ",
                                     waveformView.signal3Max, waveformView.signal3Min, waveformView.signal3Scale)
            }
            index = waveformView.signal1Index
        }
    }
    
    func lowpassFilter(data: CMAcceleration){
        currentAcceleration[0] = (alpha * CGFloat(data.x)) + (one_alpha * lastAcceleration[0])
        currentAcceleration[1] = (alpha * CGFloat(data.y)) + (one_alpha * lastAcceleration[1])
        currentAcceleration[2] = (alpha * CGFloat(data.z)) + (one_alpha * lastAcceleration[2])
        lastAcceleration = currentAcceleration
    }
    
}


extension Collection where Element: Numeric {
    // Returns the total sum of all elements in the array
    var total: Element { return reduce(0, +)}
}

extension Collection where Element: BinaryInteger {
    // Return the average of all elements in the array
    var average: Double {
        return isEmpty ? 0 : Double(total) / Double(count)
    }
}

extension Collection where Element: BinaryFloatingPoint {
    var average: Element {
        return isEmpty ? 0 : total / Element(count)
    }
}


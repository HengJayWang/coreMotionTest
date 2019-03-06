//
//  WaveformView.swift
//  coreMotionTest
//
//  Created by Ｍ200_Macbook_Pro on 2019/2/18.
//  Copyright © 2019 ITRI. All rights reserved.
//

import UIKit

@IBDesignable
class WaveformView: UIView {

    private struct Parameters {
        static let backgroundOutlineWidth: CGFloat = 8.0
        static let middleSeperateLineWidth: CGFloat = 2.5
        static let signalLineWidth: CGFloat = 2.0
        static let signalArrayLength = 2000
        static let indexToUpdateView = signalArrayLength / 10
    }
    
    var signal1Min: CGFloat = 0
    var signal1Max: CGFloat = 0
    var signal1Scale: CGFloat = 1
    var signal1Index: Int = 0
    
    var signal1Data = [CGFloat](repeating: 0.0, count: Parameters.signalArrayLength) {
        didSet {
            if (signal1Index + 1) % Parameters.indexToUpdateView == 0 { setNeedsDisplay() }
        }
    }
    
    
    var signal2Min: CGFloat = 0
    var signal2Max: CGFloat = 0
    var signal2Scale: CGFloat = 1
    var signal2Index: Int = 0
    
    var signal2Data = [CGFloat](repeating: 0.0, count: Parameters.signalArrayLength) {
        didSet {
            if (signal2Index + 1) % Parameters.indexToUpdateView == 0 { setNeedsDisplay() }
        }
    }
    
    var signal3Min: CGFloat = 0
    var signal3Max: CGFloat = 0
    var signal3Scale: CGFloat = 1
    var signal3Index: Int = 0
    
    var signal3Data = [CGFloat](repeating: 0.0, count: Parameters.signalArrayLength) {
        didSet {
            if (signal3Index + 1) % Parameters.indexToUpdateView == 0 { setNeedsDisplay() }
        }
    }
    
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawWaveformBackground(rect: rect)
        
        drawSignal(rect: rect)
    }
    
    func drawWaveformBackground (rect: CGRect) {
        // set black background
        let background = UIBezierPath(rect: rect)
        UIColor.black.setFill()
        background.fill()
        
        // draw gray middle seperate line
        let seperateLine1 = UIBezierPath()
        //set the path's line width to the height of the stroke
        seperateLine1.lineWidth = Parameters.middleSeperateLineWidth
        
        // move the initial point of the path
        // to the start of the horizontal stroke
        seperateLine1.move(to: CGPoint(x: 0, y: bounds.height / 3))
        
        // add a point to the path at the end of the stroke
        seperateLine1.addLine(to: CGPoint(x: bounds.width, y: bounds.height / 3))
        UIColor.gray.setStroke()
        seperateLine1.stroke()
        
        // draw gray middle seperate line
        let seperateLine2 = UIBezierPath()
        //set the path's line width to the height of the stroke
        seperateLine2.lineWidth = Parameters.middleSeperateLineWidth
        
        // move the initial point of the path
        // to the start of the horizontal stroke
        seperateLine2.move(to: CGPoint(x: 0, y: (bounds.height * 2) / 3))
        
        // add a point to the path at the end of the stroke
        seperateLine2.addLine(to: CGPoint(x: bounds.width, y: (bounds.height * 2) / 3))
        UIColor.gray.setStroke()
        seperateLine2.stroke()
        
        // draw outline of waveform area
        let outline = UIBezierPath(rect: rect)
        outline.lineWidth = Parameters.backgroundOutlineWidth
        let outlineColor = #colorLiteral(red: 1, green: 0.8820928931, blue: 0, alpha: 1)
        outlineColor.setStroke()
        outline.stroke()
        
    }
    
    func drawSignal (rect: CGRect) {
        
        let graphWidth: CGFloat = 0.9  // Graph is 90% of the width of the view
        let width = bounds.width
        let height = bounds.height
        let stepX = (width * graphWidth) / CGFloat(signal1Data.count - 1)
        
        //draw waveform of signal1
        let origin = CGPoint(x: width * (1 - graphWidth) / 2, y: height * 0.3 )
        
        let signal1 = UIBezierPath()
        signal1.lineWidth = Parameters.signalLineWidth
        signal1Min = signal1Data.min()!
        signal1Max = signal1Data.max()!
        signal1Scale = (signal1Max == signal1Min) ? 1 : (signal1Max - signal1Min)
        
        signal1.move(to: CGPoint(x: origin.x,
                                 y: origin.y - height * 0.27 * (signal1Data[0] - signal1Min) / signal1Scale))
        
        for i in 1...signal1Data.count-1 {
            signal1.addLine(to: CGPoint(x: origin.x + stepX * CGFloat(i),
                                        y: origin.y - height * 0.27 * (signal1Data[i] - signal1Min) / signal1Scale))
        }
        UIColor.red.setStroke()
        signal1.stroke()
        
        //draw waveform of signal2
        let origin2 = CGPoint(x: width * (1 - graphWidth) / 2, y: height * 0.63 )
        let signal2 = UIBezierPath()
        signal2.lineWidth = Parameters.signalLineWidth
        signal2Min = signal2Data.min()!
        signal2Max = signal2Data.max()!
        signal2Scale = (signal2Max == signal2Min) ? 1 : (signal2Max - signal2Min)
        
        signal2.move(to: CGPoint(x: origin2.x,
                                 y: origin2.y - height * 0.27 * (signal2Data[0] - signal2Min) / signal2Scale))
        
        for i in 1...signal2Data.count-1 {
            signal2.addLine(to: CGPoint(x: origin2.x + stepX * CGFloat(i),
                                        y: origin2.y - height * 0.27 * (signal2Data[i] - signal2Min) / signal2Scale))
        }
        UIColor.green.setStroke()
        signal2.stroke()
        
        //draw waveform of signal2
        let origin3 = CGPoint(x: width * (1 - graphWidth) / 2, y: height * 0.96 )
        let signal3 = UIBezierPath()
        signal3.lineWidth = Parameters.signalLineWidth
        signal3Min = signal3Data.min()!
        signal3Max = signal3Data.max()!
        signal3Scale = (signal3Max == signal3Min) ? 1 : (signal3Max - signal3Min)
        
        signal3.move(to: CGPoint(x: origin3.x,
                                 y: origin3.y - height * 0.27 * (signal3Data[0] - signal3Min) / signal3Scale))
        
        for i in 1...signal3Data.count-1 {
            signal3.addLine(to: CGPoint(x: origin3.x + stepX * CGFloat(i),
                                        y: origin3.y - height * 0.27 * (signal3Data[i] - signal3Min) / signal3Scale))
        }
        UIColor.cyan.setStroke()
        signal3.stroke()
        
    }
    
    func pushSignal1BySliding (newValue: CGFloat) {
        signal1Data[signal1Index] = newValue
        signal1Index = (signal1Index == signal1Data.count - 1) ? 0 : (signal1Index + 1)
    }
    
    func pushSignal2BySliding (newValue: CGFloat) {
        signal2Data[signal2Index] = newValue
        signal2Index = (signal2Index == signal2Data.count - 1) ? 0 : (signal2Index + 1)
    }

    func pushSignal3BySliding (newValue: CGFloat) {
        signal3Data[signal3Index] = newValue
        signal3Index = (signal3Index == signal3Data.count - 1) ? 0 : (signal3Index + 1)
    }
    
}

//
//  ViewController.swift
//  SimpleSpeedometer
//
//  Created by maxlutsky on 01/15/2022.
//  Copyright (c) 2022 maxlutsky. All rights reserved.
//

import UIKit
import SimpleSpeedometer

class ViewController: UIViewController {

    @IBOutlet weak var viewForSpeedometer: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label: UILabel!
    
    var speedometer: SpeedometerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        label.addGestureRecognizer(gestureRecognizer)
        label.text = "Set Speedometer value to \(Int(slider.value)) percent"
        
        // Setup Speedometer
        let speedometerElements = [
            GaugeElemet(color: .blue,
                        thikness: 20,
                        percents: 35),
            GaugeElemet(color: .red,
                        thikness: 20,
                        percents: 65)
        ]
        viewForSpeedometer.layoutIfNeeded()
        speedometer = SpeedometerView(frame: viewForSpeedometer.bounds, gaugeElements: speedometerElements)
        viewForSpeedometer.addSubview(speedometer ?? UIView())
    }

    @IBAction func sliderValueChanged(_ sender: Any) {
        label.text = "Set Speedometer value to \(Int(slider.value)) percent"
    }
    @objc func labelTapped() {
        speedometer?.setValue(percents: Int(slider.value))
    }
}


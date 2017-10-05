//
//  MetronomeViewController.swift
//  Metronome-Swift
//
//  Created by Adam Thompson on 12/23/15.
//  Copyright (c) 2015 Adam Thompson. All rights reserved.
//

import UIKit
import CoreFoundation
import Dispatch

class MetronomeViewController: UIViewController {
    
    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var timeSignatureButton: UIButton!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var tempoSlider: CustomHeightSlider!
    
    // The superView containing all animating Circles
    //@IBOutlet weak var beatCircleView: BeatCircleView!
    
    let metronome = Metronome()
    var containerView: BeatContainerView!
    var metronomeDisplayLink: CADisplayLink!
    
    // Colours
    let backgroundColor = UIColor.black
    let tempoLabelColor = UIColor(red: 0.14, green: 0.14, blue: 0.14, alpha: 1)
    let tempoLabelColorPressed = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
    let MinColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
    let MaxColor = UIColor(red:0.04, green: 0.04, blue: 0.04, alpha: 0.3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Lets us access the ViewController from metronome logic
        metronome.parentViewController = self
        
        let viewWidth = view.frame.width
        let viewHeight = view.frame.height
        print("Height: \(viewHeight), Width: \(viewWidth)")
        
        // Set Up Beat Circle Views
        self.containerView = BeatContainerView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
        self.containerView.center = view.center
        self.containerView.backgroundColor = UIColor.clear
        view.addSubview(self.containerView)
        view.sendSubview(toBack: self.containerView)
        
        // Set up Tap button
        tapButton.frame.size = CGSize(width: viewWidth, height: viewWidth);
        tapButton.contentEdgeInsets = UIEdgeInsetsMake(viewWidth/2, viewWidth/2, viewWidth/2, viewWidth/2);
        view.bringSubview(toFront: tapButton)
        view.backgroundColor = backgroundColor
        
        // Set up Tempo Control Buttons, Slider and Text
        tempoLabel.text = String(metronome.tempo)
        incrementButton.backgroundColor = MaxColor
        decrementButton.backgroundColor = MinColor
        tempoSlider.thumbTintColor = UIColor.clear
        tempoSlider.minimumTrackTintColor = MinColor
        tempoSlider.maximumTrackTintColor = MaxColor
        tempoSlider.setMinimumTrackImage(UIImage(named: "sliderCapMin"), for: UIControlState.normal)
        tempoSlider.setMaximumTrackImage(UIImage(named: "sliderCapMax"), for: UIControlState.normal)
        tempoSlider.maximumValue = Float(metronome.maxTempo)
        tempoSlider.minimumValue = Float(metronome.minTempo)
        tempoSlider.value = Float(metronome.tempo)
        
//        sliderIncrement.maximumValue = Float(metronome.maxTempo)
//        sliderIncrement.minimumValue = Float(metronome.minTempo)
//        tempoSlider.thumbTintColor = sliderThumbColor
//        tempoSlider.minimumTrackTintColor = sliderMinColor
//        tempoSlider.maximumTrackTintColor = sliderMaxColor
//        tempoSlider.isEnabled = true

        metronome.prepare()
        
        //self.startMetronome()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func swipeButton(_ sender: UIButton) {
        if metronome.isOn { self.stopMetronome() }
    }
    
    @IBAction func tapDown(_ sender: UIButton) {
        if metronome.isOn { metronome.logTap() }
        else { self.startMetronome() }
        
    }
    @IBAction func tapUp(_ sender: UIButton) {
        // nothing
    }
    
    @IBAction func incrementButtonPressed(_ sender: UIButton) {
        self.metronome.incrementTempo()
    }
    
    @IBAction func decrementButtonPressed(_ sender: UIButton) {
        self.metronome.decrementTempo()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        print("Slider Value: \(Int(tempoSlider.value))")
        self.metronome.setTempo(newTempo: Int(tempoSlider.value))
    }
    
    func toggleMetronome() {
        if metronome.isOn { self.stopMetronome() }
        else { self.startMetronome() }
    }
    
    func startMetronome() {
        if !metronome.isPrepared {
            metronome.prepare()
        }
        print("Tempo: \(metronome.tempo)")
        metronome.start()
        startUI()
    }
    
    func stopMetronome() {
        metronome.stop()
        stopUI()
    }
    
    func startUI() {
        //        tempoSlider.isEnabled = false
        tempoLabel.isEnabled = false
//        UIView.animate(withDuration: 0.2, animations: {() -> Void in
//            self.tempoSlider.alpha = 0.4
//        })
    }
    
    func stopUI() {
        tapButton.isEnabled = true
        tapButton.isHidden = false
        // Enable the metronome stepper.
//        tempoSlider.isEnabled = true
//        UIView.animate(withDuration: 0.2, animations: {() -> Void in
//            self.tempoSlider.alpha = 1
//        })
    }
    
    // MARK: - UIResponder
}


//
//  PlaySoundViewController.swift
//  UDA_PitchPerfect
//
//  Created by MJH_Mac on 2015. 10. 2..
//  Copyright © 2015년 MJH_Mac. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    @IBOutlet weak var stopAudio: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopAudio.enabled = false
        
        //Playing the file
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)

        //initialized
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        stopAudio.enabled = true
        playAudioWithRateAndTime(0.5, currentTime: 0.0)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        stopAudio.enabled = true
        playAudioWithRateAndTime(1.5, currentTime:  0.0)
    }

    @IBAction func playDarthvaderAudio(sender: UIButton) {
        stopAudio.enabled = true
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        stopAudio.enabled = true
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func stopPlayButton(sender: UIButton) {
        stopAudio.enabled = false
        stopAndResetAudio()
    }
    
    
    func playAudioWithVariablePitch(pitch: Float){
        stopAndResetAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    
    func playAudioWithRateAndTime(rate: Float, currentTime: Double){
        audioPlayer.stop()
        audioPlayer.enableRate = true
        audioPlayer.rate = rate
        audioPlayer.currentTime = currentTime
        audioPlayer.play()
    }
    
    func stopAndResetAudio(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

}

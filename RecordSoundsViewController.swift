//
//  RecordSoundsViewController.swift
//  UDA_PitchPerfect
//
//  Created by MJH_Mac on 2015. 9. 25..
//  Copyright © 2015년 MJH_Mac. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var record: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        showUIStopButton(false)
        showUIRecordButton(true)
    }

    @IBAction func recordAudio(sender: UIButton) {
        
        showUIRecordButton(false)
        showUIStopButton(true)
        
        //Recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "MyAudio.wav"
        
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
       
        if(flag){
            //Save the recorded audio by calling initializer
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            
            //Move to the next scene aka perform segue
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            print("Recording was not sucessful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            //access code
            let playSoundsVC:PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
        showUIStopButton(false)
        showUIRecordButton(true)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    func showUIRecordButton(enabled: Bool){
        
        if(enabled){
            //Enable/Unhide
            recordButton.enabled = true
            record.enabled = true
            record.hidden = false
        }else{
            //Disable/Hide
            recordButton.enabled = false
            record.enabled = false
            record.hidden = true
        }
    }
    
    func showUIStopButton(enabled: Bool){
        
        if(enabled){
            //Enable/Unhide
            stopButton.enabled = true
            stopButton.hidden = false
            recordingInProgress.enabled = true
            recordingInProgress.hidden = false
        }else{
            //Disable/Hide
            stopButton.enabled = false
            stopButton.hidden = true
            recordingInProgress.enabled = false
            recordingInProgress.hidden = true
        }
    }
    
}


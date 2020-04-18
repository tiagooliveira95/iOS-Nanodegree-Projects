//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Tiago Oliveira on 17/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    

    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stopRecordButton.isEnabled = false
    }

    @IBAction func recordAudio(_ sender: Any) {
        recordingLabel.text = "Recording in progress"
        recordButton.isEnabled = false
        stopRecordButton.isEnabled = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        recordingLabel.text = "Tap to Record"
        recordButton.isEnabled = true
        stopRecordButton.isEnabled = false
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinish(_ recorder: AVAudioRecorder,successfully flag: Bool){
        print("finished")
    }
    
}


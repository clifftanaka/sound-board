//
//  SoundViewController.swift
//  Sound Board
//
//  Created by Cliff Tanaka on 2017/03/13.
//  Copyright © 2017 kurifu. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var soundLabel: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var audioRecorder : AVAudioRecorder? = nil
    var audioPlayer : AVAudioPlayer? = nil
    var audioURL : URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    func setUpRecorder() {
        do {
            //create an audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //create url for the audio file
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)
            
            //create settings for audio recorder
            var settings : [String:Any] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            settings[AVSampleRateKey] = 44100.0
            settings[AVNumberOfChannelsKey] = 2
            
            //initialize audio recorder
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
        } catch let error as NSError {
            print(error)
        }
    }

    
    @IBAction func recordTapped(_ sender: Any) {
        
        if audioRecorder!.isRecording {
            //stop the recording
            audioRecorder?.stop()
            
            //change button title to record
            recordButton.setTitle("Record", for: .normal)
            
            //reneable play and add button
            playButton.isEnabled = true
            addButton.isEnabled = true
        } else {
            //start the recording
            audioRecorder?.record()
            
            //change button title to Stop
            recordButton.setTitle("Stop", for: .normal)
        }
    }
    
    @IBAction func playTapped(_ sender: Any) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        } catch {
            
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sound = Sound(context: context)
        
        sound.name = soundLabel.text
        sound.audio = NSData(contentsOf: audioURL!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    
}

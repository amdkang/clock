//
//  ViewController.swift
//  clock
//
//  Created by Amenda Kang on 1/31/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var countdownTimeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var mainButton: UIButton!

    var dateFormatter = DateFormatter()
    var countdownTimer = Timer()
    var timeLeft : Int?
    var audioPlayer: AVAudioPlayer!
    var isMusicPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setCurrentTime()
        datePicker.datePickerMode = .countDownTimer
        mainButton.setTitle("Start Timer", for: .normal)
//        countdownTimeLabel.isHidden = true
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setCurrentTime), userInfo: nil, repeats: true)
    }

    @objc func setCurrentTime() {
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
        currentTimeLabel.text = dateFormatter.string(from: Date())
        setBackground()
    }
    
    @objc func setBackground() {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 {
            background.image = UIImage(named: "am_background")
            mainButton.setTitleColor(UIColor.black, for: .normal)
            currentTimeLabel.textColor = UIColor.black
            countdownTimeLabel.textColor = UIColor.black
            datePicker.setValue(UIColor.black   , forKey: "textColor")
        } else {
            background.image = UIImage(named: "pm_background")
            mainButton.setTitleColor(UIColor.white, for: .normal)
            currentTimeLabel.textColor = UIColor.white
            countdownTimeLabel.textColor = UIColor.white
            datePicker.setValue(UIColor.white, forKey: "textColor")
        }
    }
    
    @IBAction func mainButton(_ sender: UIButton) {
        if isMusicPlaying {
            audioPlayer!.stop()
            isMusicPlaying = false
            mainButton.setTitle("Start Timer", for: .normal)
        } else {
        timeLeft = Int(datePicker.countDownDuration)
//        countdownTimeLabel.isHidden = false
        countdownTimer.invalidate()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountDown), userInfo: nil, repeats: true)
        }
    }
    
    @objc func startCountDown() {
        if timeLeft! >= 0 {
            countdownTimeLabel.text = "Time Remaining: \(formatCountDownTime(timeLeft!))"
            timeLeft! -= 1
        } else {
            countdownTimer.invalidate()
            playAudio()
            mainButton.setTitle("Stop Music", for: .normal)
        }
    }
    
    func formatCountDownTime(_ secsLeft: Int) -> String {
        let hrs = secsLeft / 3600
        let mins = (secsLeft % 3600) / 60
        let secs = secsLeft % 60
        return String(format: "%02d:%02d:%02d", hrs, mins, secs)
        }
    
    func playAudio() {
        let url = Bundle.main.url(forResource: "lazy-day", withExtension: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer!.play()
        isMusicPlaying = true
    }
}


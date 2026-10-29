//
//  ViewController.swift
//  assignment8
//
//  Created by Anuarkhan Assanbayev on 29.10.2026.
//
import AVFoundation
import UIKit

class ViewController: UIViewController {

//кнопки плей и тд
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func playTapped(_ sender: UIButton) {
        guard let player = audioPlayer else { return }

        if player.isPlaying {
            player.pause()
            timer?.invalidate()

            playButton.setImage(
                UIImage(systemName: "play.fill"),
                for: .normal
            )
        } else {
            player.play()
            startTimer()

            playButton.setImage(
                UIImage(systemName: "pause.fill"),
                for: .normal
            )
        }
    }
    @IBAction func previousTapped(_ sender: UIButton) {
        currentSong = (currentSong - 1 + songs.count) % songs.count
        loadSong()
        audioPlayer?.play()
        startTimer()

        playButton.setImage(
            UIImage(systemName: "pause.fill"),
            for: .normal
        )
    }
    @IBAction func nextTapped(_ sender: UIButton) {
        currentSong = (currentSong + 1) % songs.count
        loadSong()
        audioPlayer?.play()
        startTimer()

        playButton.setImage(
            UIImage(systemName: "pause.fill"),
            for: .normal
        )
    }
    
    func startTimer() {
        timer?.invalidate()

        timer = Timer.scheduledTimer(
            withTimeInterval: 0.5,
            repeats: true
        ) { [weak self] _ in
            guard let self = self,
                  let player = self.audioPlayer,
                  player.duration > 0 else { return }

            self.progressView.progress = Float(
                player.currentTime / player.duration
            )

            if !player.isPlaying {
                self.timer?.invalidate()
                self.playButton.setImage(
                    UIImage(systemName: "play.fill"),
                    for: .normal
                )
            }
        }
    }
    
    //фотка, прогресс и лейблы
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    


    let songs = [
        ("Britney", "OBLADAET",
         "OBLADAET - Britney", "cover1"),

        ("Моя Игра", "Баста",
         "Баста - Моя Игра", "cover2"),

        ("Про красивую жизнь", "БандЭрос",
         "БандЭрос - Про красивую жизнь", "cover3"),

        ("Mutant", "OBLADAET",
         "Obladaet - Mutant", "cover4"),

        ("Кинолента", "Баста",
         "Баста - Кинолента", "cover5"),

        ("Captain", "Miyagi",
         "Miyagi - Captain", "cover6"),

        ("Do I Wanna Know?", "Arctic Monkeys",
         "Arctic Monkeys - Do I Wanna Know", "cover7"),

        ("До-ма", "V $ X V PRiNCE & GUF",
         "V $ X V PRiNCE & GUF - До-ма", "cover8"),

        ("TV Off", "Kendrick Lamar",
         "Kendrick Lamar feat. Lefty Gunplay - TV Off", "cover9"),

        ("Банк", "ICEGERGERT & Zivert",
         "ICEGERGERT & Zivert - Банк", "cover10")
    ]

    var currentSong = 0
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    
    func loadSong() {
        let song = songs[currentSong]

        songTitleLabel.text = song.0
        artistLabel.text = song.1
        albumImageView.image = UIImage(named: song.3)

        progressView.progress = 0
        timer?.invalidate()
        audioPlayer?.stop()

        guard let url = Bundle.main.url(
            forResource: song.2,
            withExtension: "mp3"
        ) else {
            print("Song not found: \(song.2)")
            audioPlayer = nil
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        } catch {
            audioPlayer = nil
            print("Audio error: \(error)")
        }

        playButton.setImage(
            UIImage(systemName: "play.fill"),
            for: .normal
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSong()
        // Do any additional setup after loading the view.
    }


}


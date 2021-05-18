//
//  MusicPlayViewController.swift
//  flo
//
//  Created by JeongHyeon Lee on 2021/05/18.
//

import UIKit
import AVFoundation

class MusicPlayViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var currentPlayTimeLabel: UILabel!
    @IBOutlet weak var musicDurationLabel: UILabel!
    @IBOutlet weak var seekBar: UISlider!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var loopButton: UIButton!
    @IBOutlet weak var lyricsTableView: UITableView!
    
    
    var music: Music?
    var musicTableView: UITableView?
    var musicGroup: MusicGroup!
    var musicPlayer: AVAudioPlayer?
    var playImg: UIImage?
    var pauseImg: UIImage?
    var favoriteImg: UIImage?
    var noFavoriteImg: UIImage?
    var loopImg: UIImage?
    var noLoopImg: UIImage?
    var progressTime: Timer!
    var isLiked: Bool?
    var isLoop: Bool = false
    var isPaused: Bool = false
    var lyrics: Array<String>?
    var idx: Int!
    
    let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30), scale: .large)
}

extension MusicPlayViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
                
        titleLabel.text = music!.title
        artistLabel.text = music!.artist
        albumImageView.image = music!.albumCover
        
        playImg = UIImage(systemName: "play.fill", withConfiguration: config)
        pauseImg = UIImage(systemName: "pause.fill", withConfiguration: config)
        favoriteImg = UIImage(systemName: "heart.fill", withConfiguration: config)
        noFavoriteImg = UIImage(systemName: "heart", withConfiguration: config)
        loopImg = UIImage(systemName: "repeat", withConfiguration: config)
        
        if MusicHelper.musicHelper.getNowPlaying() != music!.title { // 현재 재생 중인 곡과 다른 곡을 선택했다면
            prepareSongAndSession()
        }
        
        let duration = Int((MusicHelper.musicHelper.audioPlayer!.duration - (MusicHelper.musicHelper.audioPlayer!.currentTime)))
        let durationMin = duration / 60
        let durationSec = duration - durationMin * 60
        musicDurationLabel.text = NSString(format: "%02d:%02d", durationMin, durationSec) as String
        musicDurationLabel.textColor = .systemGray
        
        seekBar.minimumValue = 0
        seekBar.maximumValue = Float(MusicHelper.musicHelper.audioPlayer!.duration)
        
        progressTime = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        
        if MusicHelper.musicHelper.audioPlayer!.isPlaying {
            playButton.setImage(pauseImg, for: .normal)
            
        } else {
            playButton.setImage(playImg, for: .normal)
        }

        isLiked = music!.favorite
        if music!.favorite == true {
            favoriteButton.setImage(favoriteImg, for: .normal)
            favoriteButton.tintColor = .red
        } else {
            favoriteButton.setImage(noFavoriteImg, for: .normal)
            favoriteButton.tintColor = .systemGray5
        }

        if let lyricsFile = Bundle.main.path(forResource: music!.title, ofType: "lrc") {
            do {
                let contents = try String(contentsOfFile: lyricsFile)
                lyrics = contents.components(separatedBy: .newlines)
                while lyrics!.contains("") {
                    lyrics!.remove(at: lyrics!.firstIndex(of: "")!)
                }
            } catch {
                print("Can't load lyrics");
            }
        }

        lyricsTableView.backgroundColor = .clear
        lyricsTableView.isScrollEnabled = false
        lyricsTableView.dataSource = self
    }
}

extension MusicPlayViewController {  // 좋아요 버튼
    @IBAction func likeButton(_ sender: UIButton) {
        if isLiked == true {
            isLiked = false
            favoriteButton.setImage(noFavoriteImg, for: .normal)
            favoriteButton.tintColor = .systemGray5
        } else {
            isLiked = true
            favoriteButton.setImage(favoriteImg, for: .normal)
            favoriteButton.tintColor = .red
        }
    }
}

extension MusicPlayViewController {  // 반복 재생 버튼
    @IBAction func loopButton(_ sender: UIButton) {
        if isLoop == false {
            isLoop = true
            loopButton.tintColor = .systemIndigo
            MusicHelper.musicHelper.audioPlayer?.numberOfLoops = -1
        } else {
            isLoop = false
            loopButton.tintColor = .systemGray5
            MusicHelper.musicHelper.audioPlayer?.numberOfLoops = 0
        }
    }
}

extension MusicPlayViewController {
    override func viewWillDisappear(_ animated: Bool) {
        if let music = music {
            music.favorite = isLiked
        }
        musicGroup.modifyMusic(music: music!, index: idx)
    }
}

extension MusicPlayViewController {  // 재생-일시정지 버튼
    @IBAction func playButton(_ sender: UIButton) {
        if musicPlayer!.isPlaying {
            isPaused = true
            musicPlayer!.pause()
            playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        } else {
            isPaused = false
            musicPlayer!.play()
            playButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: config), for: .normal)
        }
    }

}

extension MusicPlayViewController {
    func prepareSongAndSession() {
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: music!.title, ofType: "mp3")!))
            musicPlayer!.prepareToPlay()

            let currentTime = Int((musicPlayer!.currentTime))
            let currentMinutes = currentTime / 60
            let currentSeconds = currentTime - currentMinutes * 60
            currentPlayTimeLabel.text = NSString(format: "%02d:%02d", currentMinutes, currentSeconds) as String

            let duration = Int((musicPlayer!.duration - (musicPlayer!.currentTime)))
            let durationMinutes = duration / 60
            let durationSeconds = duration - durationMinutes * 60
            musicDurationLabel.text = NSString(format: "%02d:%02d", durationMinutes, durationSeconds) as String

            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.playback)
            } catch let sessionError {
                print(sessionError)
            }
        } catch let songPlayerError{
            print(songPlayerError)
        }
    }
}

extension MusicPlayViewController {
    @objc func updateProgress() {
        let currentTime = Int((MusicHelper.musicHelper.audioPlayer!.currentTime))
        let currentMin = currentTime / 60
        let currentSec = currentTime - currentMin * 60
        currentPlayTimeLabel.text = NSString(format: "%02d:%02d", currentMin, currentSec) as String
        currentPlayTimeLabel.textColor = UIColor.systemIndigo
        seekBar.value = Float(MusicHelper.musicHelper.audioPlayer!.currentTime)
    }
}

extension MusicPlayViewController {
    @IBAction func changePlayingTime(_ sender: UISlider) {
        
    }
}

extension MusicPlayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (lyrics != nil) {
            return lyrics!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "UILyricsTableViewCell")
        cell.backgroundColor = .clear
        let selectedCell = UIView()
        selectedCell.backgroundColor = .clear
        cell.selectedBackgroundView = selectedCell
        if let lyric = lyrics?[indexPath.row].dropFirst(10) {
            cell.textLabel!.text = "\(lyric)"
        }
        cell.textLabel!.textColor = .systemGray5
        cell.textLabel!.textAlignment = .center
        return cell
    }
}

extension MusicPlayViewController {
    func musicListener(action: MusicGroupWithFirestore.Action, row: Int) {
        
    }
}

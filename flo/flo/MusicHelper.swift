//
//  MusicHelper.swift
//  flo
//
//  Created by JeongHyeon Lee on 2021/05/19.
//

import Foundation
import AVFoundation

class MusicHelper {
    static let musicHelper = MusicHelper()
    var audioPlayer: AVAudioPlayer?
    var nowPlaying: String? = ""
    
    func playBackgroundMusic(title: String) {
        let music = NSURL(fileURLWithPath: Bundle.main.path(forResource: title, ofType: "mp3")!)
        nowPlaying = title
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: music as URL)
            audioPlayer!.numberOfLoops = 0  // positive: number of loops, negative: infinite loop
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch {
            
        }
    }
    
    func getNowPlaying() -> String {
        if let title = nowPlaying {
            return title
        }
        return ""
    }
}

//
//  MusicGroup.swift
//  flo
//
//  Created by JeongHyeon Lee on 2021/05/17.
//

import Foundation
import UIKit

class MusicGroup: NSObject {
    var musics = [Music]()
    
    override init() {
        super.init()
    }
    
    func testData() {
        musics.append(Music(title: "Ocean", artist: "David Davis", albumCover: UIImage(named: "Ocean")!))
        musics.append(Music(title: "Thinkin' About U", artist: "fcj", albumCover: UIImage(named: "Thinkin' About U")!))
        musics.append(Music(title: "Lie 2 You", artist: "Leonell Cassio", albumCover: UIImage(named: "Lie 2 You")!))
        musics.append(Music(title: "Glow in the Dark", artist: "RENAE", albumCover: UIImage(named: "Glow in the Dark")!))
        musics.append(Music(title: "Secrets", artist: "RYYZN", albumCover: UIImage(named: "Secrets")!))
        musics.append(Music(title: "Sorry Haha I Fell Asleep", artist: "Egg", albumCover: UIImage(named: "Sorry Haha I Fell Asleep")!))
    }
    
    func count() -> Int {
        return musics.count
    }
    
    func addMusic(music: Music) {
        musics.append(music)
    }
    
    func modifyMusic(music: Music, index: Int) {
        musics[index] = music
    }
    
    func removeMusic(index: Int) {
        musics.remove(at: index)
    }
    
    func getMusics() -> Array<Music> {
        return musics
    }
}

extension MusicGroup {
    func findIndex(artist: String) -> Int? {
        for i in 0..<musics.count {
            if musics[i].artist == artist {
                return i
            }
        }
        return nil
    }
}

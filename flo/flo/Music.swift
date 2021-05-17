//
//  Music.swift
//  flo
//
//  Created by JeongHyeon Lee on 2021/05/17.
//

import Foundation
import UIKit
import FirebaseStorage

class Music: NSObject {
    var title: String
    var artist: String
    var albumCover: UIImage?
    var favorite: Bool?
    var url: String?
    
    override init() {
        self.title = ""
        self.artist = ""
        self.albumCover = nil
        self.favorite = false
        self.url = nil
        super.init()
    }
    
    init(title: String, artist: String, albumCover: UIImage) {
        self.title = title
        self.artist = artist
        self.albumCover = albumCover
        self.favorite = false
        self.url = nil
        super.init()
    }
    
    init(title: String, artist: String, albumCover: UIImage, favorite: Bool) {
        self.title = title
        self.artist = artist
        self.albumCover = albumCover
        self.favorite = favorite
        self.url = nil
        super.init()
    }
    
    init(title: String, artist: String, favorite: Bool) {
        self.title = title
        self.artist = artist
        self.favorite = favorite
        super.init()
    }
    
    init(title: String, artist: String, albumCover: UIImage, url: String) {
        self.title = title
        self.artist = artist
        self.albumCover = albumCover
        self.favorite = false
        self.url = url
        super.init()
    }
    
    init(title: String, artist: String, url: String) {
        self.title = title
        self.artist = artist
        self.albumCover = nil
        self.favorite = false
        self.url = url
        super.init()
    }
}

extension Music {
    static func dictToMusic(dict: [String: Any]) -> Music? {
        guard let artist = dict["artist"] else { return nil }
        let music = Music()
        music.artist = artist as! String
        music.title = dict["title"] as! String
        // Cloud storage에서 앨범 아트 이미지를 가져오기
        let imageRef = Storage.storage().reference(withPath: dict["albumCover"] as! String)
        imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print(error)
            } else {
                music.albumCover = UIImage(data: data!)
            }
        }
        music.favorite = (dict["favorite"] as! Bool)
        return music
    }
    
    static func musicToDict(music: Music) -> [String: Any] {  // Music 객체 -> 딕셔너리로
        var dict = [String: Any]()
        dict["artist"] = music.artist
        dict["title"] = music.title
        dict["albumCover"] = "albumCover/\(music.title).jpeg"
        dict["favorite"] = music.favorite
        return dict
    }
}

extension Music {
    func clone() -> Music {
        let music = Music()
        music.artist = artist
        music.title = title
        music.albumCover = albumCover
        music.favorite = favorite
        
        return music
    }
}

extension Music {
    func isEqual(music: Music) -> Bool {
        if music.artist != artist { return false }
        else if music.title != title { return false }
        else if music.albumCover != albumCover { return false }
        else if music.favorite != favorite { return false }
        return true
    }
}

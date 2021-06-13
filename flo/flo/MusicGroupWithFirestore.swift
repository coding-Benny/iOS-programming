//
//  MusicGroupWithFirestore.swift
//  flo
//
//  Created by JeongHyeon Lee on 2021/06/12.
//

import Foundation
import FirebaseFirestore

class MusicGroupWithFirestore: MusicGroup {
    enum Action {
        case added; case removed; case modified; case clear
    }
    
    var firestoreRef: CollectionReference               // firestore에서 데이터베이스 위치
    var musicGroupListener: ((Action, Int) -> Void)?    // MusicGroupViewController에서 설정
    var existQuery: ListenerRegistration?               // 이미 설정한 Query의 존재 여부
    
    override init() {
        // firestore와 연결
        firestoreRef = Firestore.firestore().collection("artists")
        super.init()
    }
    
    override func addMusic(music: Music) {
        let dict = Music.musicToDict(music: music)
        firestoreRef.document(music.artist).setData(dict)  // firestore에 저장하고 리턴
        
    }
    
    override func modifyMusic(music: Music, index: Int) {
        let dict = Music.musicToDict(music: music)
        firestoreRef.document(music.artist).setData(dict)
    }
    
    override func removeMusic(index: Int) {
        firestoreRef.document(musics[index].artist).delete()
    }
}

extension MusicGroupWithFirestore {
    func setQuery(queryStr: String) {
        musics.removeAll()  // 새로운 쿼리에 맞는 데이터를 채우기 위해 기존 데이터를 전부 지움
        
        if let existQuery = existQuery { // 이미 적용 쿼리가 있으면 제거하여 중복 방지
            existQuery.remove()
        }

        let queryReference = firestoreRef.whereField("artist", isGreaterThanOrEqualTo: queryStr).whereField("artist", isLessThanOrEqualTo: queryStr + "~")
        
        existQuery = queryReference.addSnapshotListener(queryHandler)
    }
}

extension MusicGroupWithFirestore {
    func queryHandler(querySnapshot: QuerySnapshot?, error: Error?) {
        guard let querySnapshot = querySnapshot else { return }
        
        for documentChange in querySnapshot.documentChanges {
            let data = documentChange.document.data()
            guard let music = Music.dictToMusic(dict: data) else { return }
            
            if documentChange.type == .added {
                super.addMusic(music: music)
                if let musicGroupListener = musicGroupListener {
                    musicGroupListener(.added, musics.count - 1)
                }
            }
            
            // .modified 에 대해 추가
            if documentChange.type == .modified {
                guard let index = super.findIndex(artist: music.artist) else { return }
                super.modifyMusic(music: music, index: index)
                if let musicGroupListener = musicGroupListener {
                    musicGroupListener(.modified, index)
                }
            }
            
            if documentChange.type == .removed {
                guard let index = super.findIndex(artist: music.artist) else { return }
                super.removeMusic(index: index)
                if let musicGroupListener = musicGroupListener {
                    musicGroupListener(.removed, index)
                }
            }
        }
    }
}

extension MusicGroupWithFirestore {
    func setMusicGroupListener(musicGroupListener: @escaping ((Action, Int) -> Void)) {
        self.musicGroupListener = musicGroupListener
    }
}

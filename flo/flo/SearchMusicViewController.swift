//
//  SearchMusicViewController.swift
//  flo
//
//  Created by JeongHyeon Lee on 2021/05/28.
//

import UIKit
import WebKit

class SearchMusicViewController: UIViewController {
    
    
    @IBOutlet weak var videoView: WKWebView!
    
    
    var music: Music?
}

extension SearchMusicViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlStr = (music?.url)!
        let url = URL(string: urlStr)!
        let request = URLRequest(url: url)
        videoView.load(request)
    }
}

extension SearchMusicViewController {
    override func viewWillAppear(_ animated: Bool) {
        MusicHelper.musicHelper.audioPlayer?.stop()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        MusicHelper.musicHelper.audioPlayer?.play()
    }
}

extension SearchMusicViewController {
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
}


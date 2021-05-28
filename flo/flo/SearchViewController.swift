//
//  SearchViewController.swift
//  flo
//
//  Created by JeongHyeon Lee on 2021/05/28.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    let baseURLString = "https://www.googleapis.com/youtube/v3/search"
    let apiKey = "Put your API key"
    var searchMusic: Music?
}

extension SearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.placeholder = "Artist + Title"
        searchBar.autocapitalizationType = .none
        searchBar.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
}

extension SearchViewController {
    func getResult(keyword: String) {
        var urlStr = baseURLString + "?part=snippet&type=video&maxResults=1&order=viewCount&key=" + apiKey + "&q=" + keyword
        urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        let session = URLSession(configuration: .default)
        let url = URL(string: urlStr)
        let request = URLRequest(url: url!)
        
        let dataTask = session.dataTask(with: request) {
            (data, response, error) in
            guard let jsonData = data else { print(error!); return }

            let videoId = self.extractSearchData(jsonData: jsonData)
            self.searchMusic = Music(title: "", artist: "", url: "https://www.youtube.com/watch?v=\(videoId)")
            DispatchQueue.main.async {
                self.searchBar.endEditing(true)
            }
        }
        dataTask.resume()
    }
}

extension SearchViewController {
    func extractSearchData(jsonData: Data) -> String {
        let json = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
        let items = (json["items"] as! [[String: Any]])

        let id = items[0]["id"] as! NSDictionary
        let videoId = id.value(forKey: "videoId") as! String
        
        return videoId
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getResult(keyword: searchBar.text!)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
        performSegue(withIdentifier: "ShowSearchMusic", sender: self)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}

extension SearchViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let searchMusicViewController = segue.destination as! SearchMusicViewController
        searchMusicViewController.music = searchMusic
    }
}

extension SearchViewController {
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
}

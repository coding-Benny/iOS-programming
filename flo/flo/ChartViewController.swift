//
//  ChartViewController.swift
//  flo
//
//  Created by JeongHyeon Lee on 2021/05/26.
//

import UIKit
import Foundation
import Progress

class ChartViewController: UIViewController {
    @IBOutlet weak var chartTableView: UITableView!
    
    let baseURLString = "https://www.googleapis.com/youtube/v3/playlistItems"
    let apiKey = "Put your API key"
    var chartGroup: ChartGroup!
}

extension ChartViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        chartGroup = ChartGroup()
        getChart()
        
        chartTableView.backgroundColor = .clear
        chartTableView.dataSource = self
        chartTableView.delegate = self
    }
}

extension ChartViewController {
    func getChart() {
        Prog.start(in: self, .activityIndicator)
        
        let urlStr = baseURLString + "?part=snippet&playlistId=PL4fGSI1pDJn6jXS_Tv_N9B8Z0HTRVJE0m&maxResults=50&key=" + apiKey

        let session = URLSession(configuration: .default)
        let url = URL(string: urlStr)
        let request = URLRequest(url: url!)
        
        let dataTask = session.dataTask(with: request) {
            (data, response, error) in
            guard let jsonData = data else { print(error!); return }

            self.extractMusicData(jsonData: jsonData)

            DispatchQueue.main.async {
                self.chartTableView.reloadData()
                Prog.dismiss(in: self)
            }
            
        }
        dataTask.resume()
    }
}

extension ChartViewController {
    func extractMusicData(jsonData: Data) {
        let json = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
        let items = (json["items"] as! [[String: Any]])

        for item in items {
            let snippet = item["snippet"] as! NSDictionary

            let title = snippet.value(forKey: "title") as! String
            var artist = snippet.value(forKey: "videoOwnerChannelTitle") as! String
            let videoOwnerChannelTitle = artist.split(separator: "-")
            artist = videoOwnerChannelTitle[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let resourceId = snippet.value(forKey: "resourceId") as! NSDictionary
            let videoId = resourceId.value(forKey: "videoId") as! String
            let thumbnails = snippet.value(forKey: "thumbnails") as! NSDictionary
            let thumbnailInfo = thumbnails.value(forKey: "default") as! NSDictionary
            let thumbnailURL = URL(string: thumbnailInfo.value(forKey: "url") as! String)!
            let thumbnail = (try? Data(contentsOf: thumbnailURL))!

            self.updateChart(title: title, artist: artist, albumCover: UIImage(data: thumbnail)!, url: "https://www.youtube.com/watch?v=\(videoId)")
        }
    }
}

extension ChartViewController {
    func updateChart(title: String, artist: String, albumCover: UIImage, url: String) {
        chartGroup.addMusic(music: Music(title: title, artist: artist, albumCover: albumCover, url: url))
    }
}

extension ChartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chartGroup.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UIChartTableViewCell")
        cell.backgroundColor = UIColor.clear
        let selectedCell = UIView()
        selectedCell.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedCell
        let music = chartGroup.chartList[indexPath.row]
        cell.textLabel!.text = music.title
        cell.textLabel!.textColor = UIColor.systemGray3
        cell.textLabel!.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        cell.detailTextLabel!.text = music.artist
        cell.detailTextLabel!.textColor = UIColor.systemGray
        cell.detailTextLabel!.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        cell.imageView!.image = music.albumCover
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}

extension ChartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor.systemIndigo
        tableView.cellForRow(at: indexPath)?.detailTextLabel?.textColor = UIColor.systemIndigo
        performSegue(withIdentifier: "ShowChartMusic", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.textLabel!.textColor = UIColor.systemGray3
        tableView.cellForRow(at: indexPath)?.detailTextLabel!.textColor = UIColor.systemGray
    }
}

extension ChartViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let chartMusicViewController = segue.destination as! ChartMusicViewController
        if let row = chartTableView.indexPathForSelectedRow?.row {
            chartMusicViewController.music = chartGroup.chartList[row]
        }
    }
}

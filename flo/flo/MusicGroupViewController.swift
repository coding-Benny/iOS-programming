//
//  ViewController.swift
//  flo
//
//  Created by JeongHyeon Lee on 2021/05/17.
//

import UIKit
import PopMenu
import AVFoundation
import FirebaseStorage

class MusicGroupViewController: UIViewController {

    @IBOutlet weak var musicTableView: UITableView!
    
    var musicGroup: MusicGroupWithFirestore!
    var isFiltering: Bool = false
    var myMusics: Array<Music>?
    var musicClonee: Music?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let sceneDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)!.delegate as? SceneDelegate {
            musicGroup = sceneDelegate.musicGroup
            musicGroup.setMusicGroupListener(musicGroupListener: musicGroupListener)
            musicGroup.setQuery(queryStr: "")
        }
        myMusics = musicGroup.musics
        musicTableView.backgroundColor = .black
        musicTableView.dataSource = self
        musicTableView.delegate = self
        
        DispatchQueue.main.async {
            self.musicTableView.reloadData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let indexPath = musicTableView.indexPathForSelectedRow {
            guard let clonee = musicClonee else { return }
            if clonee.isEqual(music: musicGroup.musics[indexPath.row]) == false {
                musicGroup.modifyMusic(music: clonee, index: indexPath.row)
            } else if let clonee = musicClonee {
                if clonee.artist.isEmpty { return }
                musicGroup.addMusic(music: clonee)
            }
        }
    }
}

extension MusicGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicGroup.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UIMusicTableViewCell")
        
        cell.backgroundColor = .clear
        let selectedCell = UIView()
        selectedCell.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedCell
        let music = musicGroup.musics[indexPath.row]
        
        cell.textLabel!.text = music.title
        cell.textLabel!.textColor = .systemGray3
        cell.textLabel!.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        cell.detailTextLabel!.text = music.artist
        cell.detailTextLabel!.textColor = .systemGray
        cell.detailTextLabel!.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        if let albumCover = music.albumCover {
            cell.imageView!.image = albumCover
        } else {
            cell.imageView!.image = UIImage(systemName: "music.quarternote.3")
            // Cloud storage에서 앨범 아트 이미지를 가져오기
            let imageRef = Storage.storage().reference(withPath: "albumCover/\(music.title).jpeg")

            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error)
                } else {
                    DispatchQueue.main.async {
                        music.albumCover = UIImage(data: data!)
                        cell.imageView!.image = music.albumCover
                        self.musicTableView.reloadData()
                    }
                }
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension MusicGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .systemIndigo
        tableView.cellForRow(at: indexPath)?.detailTextLabel?.textColor = .systemIndigo
        performSegue(withIdentifier: "ShowMusic", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let from = musicGroup.musics[sourceIndexPath.row]
        let to = musicGroup.musics[destinationIndexPath.row]
        musicGroup.modifyMusic(music: from, index: destinationIndexPath.row)
        musicGroup.modifyMusic(music: to, index: sourceIndexPath.row)
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .systemGray3
        tableView.cellForRow(at: indexPath)?.detailTextLabel?.textColor = .systemGray
    }
    
}

extension MusicGroupViewController {  // 더보기 버튼
    @IBAction func moreButton(_ sender: UIBarButtonItem) {
        let action1 = PopMenuDefaultAction(title: "Music info", image: UIImage(systemName: "music.quarternote.3"), color: UIColor(red: CGFloat(245.0/255.0), green: CGFloat(192.0/255.0), blue: CGFloat(192.0/255.0), alpha: CGFloat(1.0)), didSelect: {action in
            self.parent?.dismiss(animated: true, completion: nil)
            let alertController = UIAlertController(title: "Musics", message: "1. Ocean by David Davis https://soundcloud.com/justdaviddavis/ocean-mix-01-davis-main-mstrd\nFree Download: https://www.jamendo.com/track/1801400/ocean\n\n2. Thinkin' About U by fcj https://soundcloud.com/fcj_ph/thinkin-about-u\nsupport / download: https://fcjph.bandcamp.com/track/thinkin-about-u-w-sarah-hemi\n\n3. Lie 2 You by Leonell Cassio https://soundcloud.com/leonellcassio/lie2you\nFree Download: https://fanlink.to/lie2you\n\n4. Glow in the Dark by RENAE\nFree Download: https://www.jamendo.com/track/1806470/glow-in-the-dark-scorpio\n\n5. Secrets by RYYZN https://soundcloud.com/ryyzn\nCreative Commons — Attribution 3.0 Unported — CC BY 3.0\nFree Download / Stream: https://bit.ly/-secrets\nMusic promoted by Audio Library https://youtu.be/Q2-WKpaHsdM\n\n6. Sorry Haha I Fell Asleep by Egg https://www.youtube.com/watch?v=1wBEC-M9Shs", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        })
        let action2 = PopMenuDefaultAction(title: "Contact us", image: UIImage(systemName: "person.crop.circle"), color: UIColor(red: CGFloat(198.0/255.0), green: CGFloat(227.0/255.0), blue: CGFloat(119.0/255.0), alpha: CGFloat(1.0)), didSelect: {action in
            self.parent?.dismiss(animated: true, completion: nil)
            let alertController = UIAlertController(title: "Contact us", message: "iOS프로그래밍 N반 이정현\nsjeonghyeonz@gmail.com", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        })
        let actions = [action1, action2]
        
        let menu = PopMenuViewController(sourceView: sender, actions: actions)
        menu.appearance.popMenuBackgroundStyle = .dimmed(color: .black, opacity: 0.4)
        menu.appearance.popMenuFont = .systemFont(ofSize: 16, weight: .semibold)
        menu.appearance.popMenuCornerRadius = 16
        menu.appearance.popMenuItemSeparator = .fill(.darkGray, height: 1)
                
        present(menu, animated: true, completion: nil)
    }
}

extension MusicGroupViewController {  // 편집-완료 버튼
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        if musicTableView.isEditing == true {
            musicTableView.isEditing = false
            sender.title = "편집"
        } else {
            musicTableView.isEditing = true
            sender.title = "완료"
        }
    }
}

extension MusicGroupViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let musicPlayViewController = segue.destination as! MusicPlayViewController
        if let row = musicTableView.indexPathForSelectedRow?.row {
            musicPlayViewController.music = musicGroup.musics[row]
            musicPlayViewController.idx = row
        }
    }
}

extension MusicGroupViewController { // 삭제 확인 알림
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let music = musicGroup.musics[indexPath.row]
            
            let title = "Delete \(music.title)"
            let message = "Are you sure you want to delete this song?"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
                (action: UIAlertAction) -> Void in
                self.musicGroup.removeMusic(index: indexPath.row)
                self.myMusics = self.musicGroup.musics
            })
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            present(alertController, animated: true, completion: nil)
        }
    }
}

extension MusicGroupViewController {  // 좋아요 목록 버튼
    @IBAction func likeGroupButton(_ sender: UIBarButtonItem) {
        if isFiltering == false {
            isFiltering = true
            sender.image = UIImage(systemName: "heart.circle.fill")
            musicGroup.musics = musicGroup.musics.filter({$0.favorite == true})
            musicTableView.reloadData()
        } else {
            isFiltering = false
            sender.image = UIImage(systemName: "heart.circle")
            musicGroup.musics = myMusics!
            musicTableView.reloadData()
        }
    }
}

extension MusicGroupViewController {
    func musicGroupListener(action: MusicGroupWithFirestore.Action, row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        
        if action == .added {
            self.musicTableView.insertRows(at: [indexPath], with: .automatic)
            if let _ = musicClonee {
                musicTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                musicTableView.cellForRow(at: indexPath)?.backgroundColor = .purple
            }
        }
        
        if action == .removed {
            self.musicTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

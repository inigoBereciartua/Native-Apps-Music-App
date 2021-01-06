//
//  SongsViewController.swift
//  Native Apps Music App
//
//  Created by Iñigo Bereciartua on 04/01/2021.
//

import UIKit
import Firebase

class SongsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var songs:[Song] = []
    
    @IBOutlet weak var songsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        db.collection("Songs").getDocuments(){(querySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }else{
                self.songs = []
                for songDocument in querySnapshot!.documents {
                    
                    let songData = songDocument.data()
                    let songPlaylists = songData["Playlists"] as! [String]
                    
                    let songId = songDocument.documentID
                    let songName: String = songData["Name"]! as! String
                    let songUrl: URL = URL(string: "www.google.com")!
                    let song: Song = Song(id: songId, name: songName, songURL: songUrl, artist: Artist(), playlists: songPlaylists)
                    self.songs.append(song)
                    
                }
               
            }
            self.songsTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Song", for: indexPath)
        let song = self.songs[indexPath.row]
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.name
        print(song.name)
        return cell
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let playerVc = (storyboard?.instantiateViewController(identifier: "Player"))! as PlayerViewController
        playerVc.index = index
        playerVc.songs = self.songs
        playerVc.image = UIImage(named: "song")!
        present(playerVc, animated: true)
    }
}

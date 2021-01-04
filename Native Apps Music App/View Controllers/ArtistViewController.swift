//
//  ArtistViewController.swift
//  Native Apps Music App
//
//  Created by Iñigo Bereciartua on 03/01/2021.
//

import UIKit
import Firebase

class ArtistViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var songsTableView: UITableView!
    
    public var artist:Artist = Artist()
    private var songs:[Song] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let db = Firestore.firestore()
        print(artist.id)
        
        
        db.collection("Songs").whereField("AuthorId", isEqualTo: artist.id).getDocuments(){(querySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }else{
                self.songs = []
                for songDocument in querySnapshot!.documents {
                    let songData = songDocument.data()
                    let songId = songDocument.documentID
                    let songName: String = songData["Name"]! as! String
                    let songUrl: URL = URL(string: "www.google.com")!
                    let song: Song = Song(id: songId, name: songName, songURL: songUrl, artist: self.artist)
                    self.songs.append(song)
                }
                print(self.songs.count)
            }
            self.songsTableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.songs.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Song", for: indexPath)
        let song = self.songs[indexPath.row]
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.name
        print(song.name)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let playerVc = (storyboard?.instantiateViewController(identifier: "Player"))! as PlayerViewController
        playerVc.index = index
        playerVc.songs = self.songs
        present(playerVc, animated: true)
    }
    
    
}

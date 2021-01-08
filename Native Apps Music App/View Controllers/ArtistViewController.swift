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
        let dataAccess = DataAccess()
        dataAccess.getSongsOfArtist(artist: self.artist){ songs in
            self.songs = songs
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
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let playerVc = (storyboard?.instantiateViewController(identifier: "Player"))! as PlayerViewController
        playerVc.index = index
        playerVc.songs = self.songs
        playerVc.image = self.artist.photo
        present(playerVc, animated: true)
    }
    
    
}

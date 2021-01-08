//
//  AddSongToPlaylistViewController.swift
//  Native Apps Music App
//
//  Created by Iñigo Bereciartua on 04/01/2021.
//

import UIKit
import Firebase
import Toast_Swift

class AddSongToPlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var playlists: [Playlist] = []
    var song: Song = Song()
    let dataAccess = DataAccess()
    @IBOutlet weak var playlistsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataAccess.getPlaylistsNotIncludeSong(songId: song.id){playlists in
            self.playlists = playlists
            self.playlistsTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playlist : Playlist = self.playlists[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Playlist", for: indexPath)
        cell.textLabel?.text = playlist.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlistId = self.playlists[indexPath.row].id
        self.dataAccess.addSongToPlaylist(songId: self.song.id, playlistId: playlistId){
            self.view.makeToast("The song has been added to the playlist successfully")
            self.playlists.remove(at: indexPath.row)
            self.playlistsTableView.reloadData()
        }
    }    

}

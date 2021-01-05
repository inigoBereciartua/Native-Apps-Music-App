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

    @IBOutlet weak var playlistsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        let songDoc = db.collection("Songs").document(song.id)
        songDoc.getDocument{(document, err)  in
            if let err = err{
                print("An error has occurred \(err)")
            }else{
                let songData = document?.data()
                let songPlaylists: [String] = songData!["Playlists"] as! [String]
                
                db.collection("Playlists").addSnapshotListener{(querySnapshot, err) in
                    self.playlists = []
                    if let err = err{
                        print("Error getting documents: \(err)")
                    }else{
                        for playlistDocument in querySnapshot!.documents{
                            let playlistId = playlistDocument.documentID
                            if(!songPlaylists.contains(playlistId)){
                                let playlistData = playlistDocument.data()
                                
                                let playlistName : String = playlistData["Name"] as! String
                                let playlist = Playlist(id: playlistId, name: playlistName)
                                self.playlists.append(playlist)
                            }
                        }
                    }
                    self.playlistsTableView.reloadData()
                }
            }
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
        let db = Firestore.firestore()
        let playlistId = self.playlists[indexPath.row].id
        let songDoc = db.collection("Songs").document(song.id)
        songDoc.getDocument{(document, err)  in
            if let err = err{
                print("An error has occurred \(err)")
                self.view.makeToast("An error occurred adding song to playlist")
            }else{
                let songData = document?.data()
                var songPlaylists: [String] = songData!["Playlists"] as! [String]
                songPlaylists.append(playlistId)
                songDoc.updateData(["Playlists": songPlaylists])
                
                
            }
        }
        let playlistDoc = db.collection("Playlists").document(playlistId)
        playlistDoc.getDocument{(document, err)  in
            if let err = err{
                print("An error has occurred \(err)")
            }else{
                let playlistData = document?.data()
                var playlistSongs: [String] = playlistData!["Songs"] as! [String]
                playlistSongs.append(self.song.id)
                playlistDoc.updateData(["Songs": playlistSongs])
                self.view.makeToast("The song has been added to the playlist successfully")
                self.playlists.remove(at: indexPath.row)
                                        
            }
        }
        self.playlistsTableView.reloadData()
        
    }
    

}

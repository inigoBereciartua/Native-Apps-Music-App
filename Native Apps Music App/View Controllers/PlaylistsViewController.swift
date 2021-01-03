//
//  PlaylistsViewController.swift
//  Native Apps Music App
//
//  Created by Iñigo Bereciartua on 07/12/2020.
//

import UIKit
import Firebase

class PlaylistsViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var newPlaylistInput: UITextField!
    
    @IBOutlet weak var playlistsTableView: UITableView!
    var playlists:[Playlist] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        db.collection("Playlists").getDocuments(){(querySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }else{
                for playlistDocument in querySnapshot!.documents{
                    let playlistData = playlistDocument.data()
                    let playlistName : String = playlistData["Name"] as! String
                    let playlist = Playlist(name: playlistName)
                    self.playlists.append(playlist)
                }
            }
            print(self.playlists.count)
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

    @IBAction func createPlaylist(_ sender: UIButton) {
        print("Click!")
        print(self.newPlaylistInput.text!)
        let newPlaylistName = newPlaylistInput.text
        if(newPlaylistName == ""){
            
        }else{
            let playlist = Playlist(name: newPlaylistName!)
            self.playlists.append(playlist)
            self.playlistsTableView.reloadData()
            self.newPlaylistInput.text = ""
            let db = Firestore.firestore()
            db.collection("Playlists").addDocument(data: [
                "Name":newPlaylistName!
            ])
            {err in
                if let err = err{
                    print("Error adding document : \(err)")
                } else {
                    print("Document added correctly" )
                }
            }
        }
        
    }
    

}

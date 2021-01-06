//
//  PlaylistsViewController.swift
//  Native Apps Music App
//
//  Created by Iñigo Bereciartua on 07/12/2020.
//

import UIKit
import Firebase
import Toast_Swift

class PlaylistsViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var newPlaylistInput: UITextField!
    
    @IBOutlet weak var playlistsTableView: UITableView!
    var playlists:[Playlist] = []
    var playlistNames: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        db.collection("Playlists").getDocuments(){(querySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }else{
                for playlistDocument in querySnapshot!.documents{
                    let playlistData = playlistDocument.data()
                    let playlistId = playlistDocument.documentID
                    let playlistName : String = playlistData["Name"] as! String
                    var playlist: Playlist = Playlist()
                    if(playlistData["Photo"] != nil){
                        let playlistPhotoUrl = URL(string: playlistData["Photo"] as! String)
                        let data = try? Data(contentsOf: playlistPhotoUrl!)
                        var photo = UIImage()
                        if(data != nil){
                            photo = UIImage(data: data!)!
                        }
                        playlist = Playlist(id: playlistId, name: playlistName, photo: photo)
                    }else{
                        playlist = Playlist(id: playlistId, name: playlistName)
                    }
                    self.playlistNames.append(playlistName)
                    self.playlists.append(playlist)
                }
            }
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
        cell.imageView?.image = playlist.photo
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = self.playlists[indexPath.row]
        
        let playlistVc = (storyboard?.instantiateViewController(identifier: "Playlist"))! as PlaylistViewController
        playlistVc.playlist = playlist
        present(playlistVc, animated: true)
    }
    

    @IBAction func createPlaylist(_ sender: UIButton) {
        
        let newPlaylistName = newPlaylistInput.text
        if(newPlaylistName == ""){
            self.view.makeToast("Playlist name can't be empty")
        }else if(self.playlistNames.contains(newPlaylistName!)){
            self.view.makeToast("That playlist name is already in use")
        }else{
             
            let db = Firestore.firestore()
            var ref: DocumentReference? = nil
            
            ref = db.collection("Playlists").addDocument(data: [
                "Name":newPlaylistName!,
                "Songs": []
            ])
            {err in
                if let err = err{
                    print("Error adding document : \(err)")
                    self.view.makeToast("An error has ocurred creating the playlist")
                } else {
                    let playlistId = ref!.documentID
                    let playlist = Playlist(id: playlistId, name: newPlaylistName!)
                    self.playlistNames.append(newPlaylistName!)
                    self.playlists.append(playlist)
                    self.playlistsTableView.reloadData()
                    self.view.makeToast("Playlist has been created successfully")
                    self.newPlaylistInput.text = ""
                }
            }
        }
        
    }
    

}

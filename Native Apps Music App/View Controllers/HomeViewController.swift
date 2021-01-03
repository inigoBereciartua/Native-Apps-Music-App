//
//  HomeViewController.swift
//  Native Apps Music App
//
//  Created by Iñigo Bereciartua on 07/12/2020.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,  UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var playlistsTableView: UITableView!
    @IBOutlet weak var artistsCollectionView: UICollectionView!
    
    var artists: [Artist] = []
    var playlists: [Playlist] = []
    var songs: [Song] = []
    var imageView: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
       
        db.collection("Artists").getDocuments(){(querySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }else{
                self.artists = []
                for artistDocument in querySnapshot!.documents {
                    let artistData = artistDocument.data()
                    let artistId:String = artistDocument.documentID
                    let artistName: String = artistData["Name"]! as! String
                    let photoUrl: URL = URL(string: artistData["Photo"]! as! String)!
                    
                    let data = try? Data(contentsOf: photoUrl)
                    var photo = UIImage()
                    if(data != nil){
                        photo = UIImage(data: data!)!
                    }
                    let artist = Artist(id: artistId, name: artistName, photo: photo)
                    self.artists.append(artist)
                }
                self.artistsCollectionView.reloadData()
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
                    self.playlistsTableView.reloadData()
                }
            }
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let artist = self.artists[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Artist", for: indexPath) as! ArtistsCollectionViewCell
        cell.artistName.text = artist.name
        cell.artistPhoto.image = artist.photo
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let artist = self.artists[indexPath.row]
        
        let artistVc = (storyboard?.instantiateViewController(identifier: "Artist"))! as ArtistViewController
        artistVc.artist = artist
        present(artistVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playlist : Playlist = self.playlists[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Playlist", for: indexPath)
        cell.textLabel?.text = playlist.name
        return cell
    }
}

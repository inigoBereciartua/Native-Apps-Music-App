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
        
        let dataAccess = DataAccess()
        dataAccess.getArtists(){artists in
            self.artists = artists
            self.artistsCollectionView.reloadData()
        }
        self.playlists = []
        dataAccess.getPlaylistsWithListener(){ playlists in
            self.playlists = playlists
            self.playlistsTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = self.playlists[indexPath.row]

        let playlistVc = (storyboard?.instantiateViewController(identifier: "Playlist"))! as PlaylistViewController
        playlistVc.playlist = playlist
        present(playlistVc, animated: true)
    }
}

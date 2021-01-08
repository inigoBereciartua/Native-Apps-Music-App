//
//  DataAccess.swift
//  Native Apps Music App
//
//  Created by Iñigo Bereciartua on 08/01/2021.
//

import Foundation
import Firebase

class DataAccess{
    let db = Firestore.firestore()
    
    func getArtists(completion: @escaping ([Artist]) -> ()){
        var artists: [Artist] = []
        db.collection("Artists").getDocuments(){(querySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }else{
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
                    artists.append(artist)
                }
            }
            completion(artists)
        }
    }
    
    
    func getPlaylistsWithListener(completion: @escaping([Playlist]) -> ()){
        var playlists: [Playlist] = []
        db.collection("Playlists").addSnapshotListener{(querySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }else{
                playlists.removeAll()
                for playlistDocument in querySnapshot!.documents{
                    let playlistData = playlistDocument.data()
                    let playlistId = playlistDocument.documentID
                    let playlistName : String = playlistData["Name"] as! String
                    let playlist : Playlist
                    
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
                    
                    
                    playlists.append(playlist)
                }
            }
            completion(playlists)
        }
    }
    
    func getPlaylists(completion: @escaping([Playlist]) -> ()){
        var playlists: [Playlist] = []
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
                    playlists.append(playlist)
                }
            }
            completion(playlists)
        }
    }
    
    func getSongs(completion:@escaping([Song]) -> ()){
        var songs: [Song] = []
        db.collection("Songs").getDocuments(){(querySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }else{
                for songDocument in querySnapshot!.documents {
                    let songData = songDocument.data()
                    let songPlaylists = songData["Playlists"] as! [String]                    
                    let songId = songDocument.documentID
                    let songName: String = songData["Name"]! as! String
                    let song: Song = Song(id: songId, name: songName, artist: Artist(), playlists: songPlaylists)
                    songs.append(song)
                }
            }
            completion(songs)
        }
    }
    
    func getSongsOfArtist(artist: Artist, completion: @escaping([Song]) -> ()){
        var songs : [Song] = []
        db.collection("Songs").whereField("AuthorId", isEqualTo: artist.id).getDocuments(){(querySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }else{
                for songDocument in querySnapshot!.documents {
                    let songData = songDocument.data()
                    let songId = songDocument.documentID
                    let songName: String = songData["Name"]! as! String
                    let song: Song = Song(id: songId, name: songName, artist: artist, playlists: [])
                    songs.append(song)
                }
            }
            completion(songs)
        }
    }
    
    func getSongsOfPlaylist(playlistId: String, completion: @escaping([Song]) -> ()){
        var songs: [Song] = []
        db.collection("Songs").getDocuments(){(querySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }else{
                for songDocument in querySnapshot!.documents {
                    let songData = songDocument.data()
                    let songPlaylists = songData["Playlists"] as! [String]
                    if(songPlaylists.contains(playlistId)){
                        let songId = songDocument.documentID
                        let songName: String = songData["Name"]! as! String
                        let song: Song = Song(id: songId, name: songName, artist: Artist(), playlists: songPlaylists)
                        songs.append(song)
                    }                    
                }
            }
            completion(songs)
        }
    }
    
    func getPlaylistsNotIncludeSong(songId: String, completion: @escaping([Playlist]) -> ()){
        var playlists: [Playlist] = []
        let songDoc = db.collection("Songs").document(songId)
        songDoc.getDocument{(document, err)  in
            if let err = err{
                print("An error has occurred \(err)")
            }else{
                let songData = document?.data()
                let songPlaylists: [String] = songData!["Playlists"] as! [String]
                
                self.db.collection("Playlists").getDocuments(){(querySnapshot, err) in
                    if let err = err{
                        print("Error getting documents: \(err)")
                    }else{
                        for playlistDocument in querySnapshot!.documents{
                            let playlistId = playlistDocument.documentID
                            if(!songPlaylists.contains(playlistId)){
                                let playlistData = playlistDocument.data()
                                let playlistName : String = playlistData["Name"] as! String
                                let playlist = Playlist(id: playlistId, name: playlistName)
                                playlists.append(playlist)
                            }
                        }
                    }
                    completion(playlists)
                }
            }
        }
    }

    func addSongToPlaylist(songId: String, playlistId: String,completion: @escaping () -> Void){
        let songDoc = db.collection("Songs").document(songId)
        songDoc.getDocument{(document, err)  in
            if let err = err{
                print("An error has occurred \(err)")
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
                playlistSongs.append(songId)
                playlistDoc.updateData(["Songs": playlistSongs])
            }
        }                
        completion()
    }



}

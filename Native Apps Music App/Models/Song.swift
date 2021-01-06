//
//  Song.swift
//  Native Apps Music App
//
//  Created by Iñigo Bereciartua on 29/12/2020.
//

import Foundation

class Song {
    var id: String
    var name: String
    var artist: Artist
    var playlists: [String]
    
    init(id: String, name: String, artist: Artist, playlists: [String]) {
        self.id = id
        self.name = name
        self.artist = artist
        self.playlists = playlists
    }
    convenience init() {
        self.init(id: "", name: "", artist: Artist(), playlists: [])
    }
    
}

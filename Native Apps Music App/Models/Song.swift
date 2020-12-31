//
//  Song.swift
//  Native Apps Music App
//
//  Created by Iñigo Bereciartua on 29/12/2020.
//

import Foundation

class Song {
    var name: String
    var songURL: URL
    var artist: Artist
    
    init(name: String, songURL: URL, artist: Artist) {
        self.name = name
        self.songURL = songURL
        self.artist = artist
    }
}

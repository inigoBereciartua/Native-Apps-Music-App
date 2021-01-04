//
//  Playlist.swift
//  Native Apps Music App
//
//  Created by Iñigo Bereciartua on 30/12/2020.
//

import Foundation

class Playlist {
    var id : String
    var name : String
    init(id: String, name : String) {
        self.id = id
        self.name = name
    }
    convenience init() {
        self.init(id: "", name: "")
    }
}

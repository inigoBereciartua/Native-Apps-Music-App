//
//  Playlist.swift
//  Native Apps Music App
//
//  Created by Iñigo Bereciartua on 30/12/2020.
//

import Foundation
import UIKit

class Playlist {
    var id : String
    var name : String
    var photo : UIImage
    init(id: String, name : String, photo: UIImage) {
        self.id = id
        self.name = name
        self.photo = photo
    }
    convenience init(id: String, name: String){
        self.init(id: id, name: name, photo: UIImage(named: "playlist")!)
    }
    convenience init() {
        self.init(id: "", name: "")
    }
}

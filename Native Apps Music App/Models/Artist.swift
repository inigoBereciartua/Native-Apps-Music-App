//
//  Artist.swift
//  Native Apps Music App
//
//  Created by Iñigo Bereciartua on 29/12/2020.
//
import UIKit
import Foundation

class Artist: Equatable{
    var id:String
    var name: String
    var photo: UIImage
    var songs: [Song]
    
    init(id:String, name: String, photo: UIImage){
        self.id = id
        self.name = name
        self.photo = photo
        self.songs = []
    }
    //SOURCE:https://stackoverflow.com/questions/40093484/what-is-the-difference-between-convenience-init-vs-init-in-swift-explicit-examp
    convenience init(){
        self.init(id: "", name: "", photo: UIImage())
    }
    
    
    var description: String {
        return "Artist(name: \(self.name) )"
    }
    static func ==(lhs: Artist, rhs:Artist)-> Bool{
        return lhs.name == rhs.name && lhs.photo == rhs.photo
    }
}

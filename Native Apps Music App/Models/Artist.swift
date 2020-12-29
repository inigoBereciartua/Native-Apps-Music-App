//
//  Artist.swift
//  Native Apps Music App
//
//  Created by Iñigo Bereciartua on 29/12/2020.
//
import UIKit
import Foundation

class Artist: Equatable{
    var name: String
    var photo: UIImage
    
    init(name: String, photo: UIImage){
        self.name = name
        self.photo = photo
    }
    
    var description: String {
        return "Artist(name: \(self.name)"
    }
    static func ==(lhs: Artist, rhs:Artist)-> Bool{
        return lhs.name == rhs.name && lhs.photo == rhs.photo
    }
}

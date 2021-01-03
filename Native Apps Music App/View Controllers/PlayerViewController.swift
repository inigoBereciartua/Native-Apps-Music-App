//
//  PlayerViewController.swift
//  Native Apps Music App
//
//  Created by Iñigo Bereciartua on 03/01/2021.
//

import UIKit

class PlayerViewController: UIViewController {
    @IBOutlet weak var songPhoto: UIImageView!
    @IBOutlet weak var songName: UILabel!
    
    @IBOutlet weak var previousSong: UIButton!
    @IBOutlet weak var nextSong: UIButton!
    @IBOutlet weak var playPause: UIButton!
    
    
    public var songs: [Song] = []
    public var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let song = songs[index]
        loadSong(song: song)
    }
    
    func loadSong(song:Song){
        songName.text = song.name
        songPhoto.image = song.artist.photo
    }
    
    
    @IBAction func previousClick(_ sender: UIButton) {
        print("PreviousClick")
        if(self.index == 0){
            self.index = self.songs.count - 1
        }else{
            self.index = self.index - 1
        }
        loadSong(song: self.songs[self.index])
    }
    
    @IBAction func playPauseClick(_ sender: UIButton) {
        print("PlayPauseClick")
    }
    
    
    @IBAction func nextClick(_ sender: UIButton) {
        print("NextClick")
        if(self.index == (self.songs.count - 1)){
            self.index = 0
        }
        self.index = self.index + 1
        loadSong(song: self.songs[self.index])
    }
    
    

}

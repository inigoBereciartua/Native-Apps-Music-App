//
//  PlayerViewController.swift
//  Native Apps Music App
//
//  Created by Iñigo Bereciartua on 03/01/2021.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    @IBOutlet weak var songPhoto: UIImageView!
    @IBOutlet weak var songName: UILabel!
    
    @IBOutlet weak var previousSong: UIButton!
    @IBOutlet weak var nextSong: UIButton!
    
    public var image : UIImage = UIImage()
    public var songs: [Song] = []
    public var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let song = songs[index]
        loadSong(song: song)
        
    }
    
    func loadSong(song:Song){
        songName.text = song.name
        songPhoto.image = self.image
    }
    
    
    @IBAction func previousClick(_ sender: UIButton) {
        if(self.index == 0){
            self.index = self.songs.count - 1
        }else{
            self.index = self.index - 1
        }
        loadSong(song: self.songs[self.index])
    }
    
    @IBAction func addToPlaylistClick(_ sender: UIButton) {
        let addToPlaylistVc = (storyboard?.instantiateViewController(identifier: "AddSongToPlaylist"))! as AddSongToPlaylistViewController
        addToPlaylistVc.song = self.songs[self.index]
        present(addToPlaylistVc, animated: true)
    }
    
    @IBAction func nextClick(_ sender: UIButton) {
        if(self.index == (self.songs.count - 1)){
            self.index = -1
        }
        self.index = self.index + 1
        loadSong(song: self.songs[self.index])
    }
    
    

}

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
    @IBOutlet weak var playPause: UIButton!
    
    
    public var songs: [Song] = []
    public var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let song = songs[index]
        loadSong(song: song)
        let songUrl = "https://firebasestorage.googleapis.com/v0/b/native-apps-ii--ios.appspot.com/o/Lionware%20-%20En%20Mi%20Oscuridad%20(666%20Videoclip).mp3?alt=media&token=941e6eb9-a4e6-4990-9ab3-775f1020b2c2"
        playSong(songUrl: songUrl)
    }
    func playSong(songUrl: String){
        guard let url = URL.init(string: songUrl) else { return }
        let playerItem = AVPlayerItem.init(url: url)
        let player = AVPlayer.init(playerItem: playerItem)
        player.play()
        
        
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
    

    
    @IBAction func addToPlaylistClick(_ sender: UIButton) {
        let addToPlaylistVc = (storyboard?.instantiateViewController(identifier: "AddSongToPlaylist"))! as AddSongToPlaylistViewController
        addToPlaylistVc.song = self.songs[self.index]
        present(addToPlaylistVc, animated: true)
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

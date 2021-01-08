//
//  SongsViewController.swift
//  Native Apps Music App
//
//  Created by Iñigo Bereciartua on 04/01/2021.
//

import UIKit
import Firebase

class SongsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var songs:[Song] = []
    
    @IBOutlet weak var songsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataAccess = DataAccess()
        dataAccess.getSongs(){ songs in
            self.songs = songs
            self.songsTableView.reloadData()
        }        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Song", for: indexPath)
        let song = self.songs[indexPath.row]
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.name        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let playerVc = (storyboard?.instantiateViewController(identifier: "Player"))! as PlayerViewController
        playerVc.index = index
        playerVc.songs = self.songs
        playerVc.image = UIImage(named: "song")!
        present(playerVc, animated: true)
    }
}

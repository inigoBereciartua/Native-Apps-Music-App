//
//  HomeViewController.swift
//  Native Apps Music App
//
//  Created by Iñigo Bereciartua on 07/12/2020.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    

    @IBOutlet weak var artistsCollectionView: UICollectionView!
    
    var artists: [Artist] = []
    var imageView: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
       
        db.collection("Artists").getDocuments(){(querySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }else{
                self.artists = []
                for artistDocument in querySnapshot!.documents {
                    let artistData = artistDocument.data()
                    let artistName: String = artistData["Name"]! as! String
                    let photoUrl: URL = URL(string: artistData["Photo"]! as! String)!
                    //SOURCE: https://www.youtube.com/watch?v=pxwJazyrhkY
                    URLSession.shared.dataTask(with: photoUrl) { data, _, error in
                        guard let data = data else{
                            return
                        }
                        DispatchQueue.main.async{
                            self.imageView = UIImage(data:data)!
                        }
                    }
                    
                    let artist = Artist(name: artistName, photo: self.imageView)
                    self.artists.append(artist)
                    self.artistsCollectionView.reloadData()
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let artist = self.artists[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Artist", for: indexPath) as! ArtistsCollectionViewCell
        
        cell.artistName.text = artist.name
        cell.artistPhoto.image = artist.photo
        print(artist.description)
        return cell
    }
    
    
}

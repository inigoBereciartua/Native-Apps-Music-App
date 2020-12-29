//
//  HomeViewController.swift
//  Native Apps Music App
//
//  Created by Iñigo Bereciartua on 07/12/2020.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        db.collection("Artists").getDocuments(){(querySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }else{
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        
    }
}

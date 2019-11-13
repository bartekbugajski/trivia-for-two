//
//  IntroViewController.swift
//  trivia for two
//
//  Created by Bartek Bugajski on 12/11/2019.
//  Copyright © 2019 BB. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class IntroViewController: UIViewController {
    
    
    @IBOutlet weak var playerOneName: UITextField!
    @IBOutlet weak var playerTwoName: UITextField!
    @IBAction func startButton(_ sender: Any) {
        createPlayer()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Main") as! ViewController
        self.present(vc, animated: true, completion: nil)
    }
    
     var players = [Player]()
        
        var player: Player? {
            didSet {
                
                playerOneName.text = player?.nickname
                playerTwoName.text = player?.nicknameTwo
                
            }
        }
    
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
           
            
        }
        
        func didAddPlayer(player: Player) {
              players.append(player)
    // let collectionViewIndexPath = IndexPath(item: newIdeas.count - 1, section: 0)
    // collectionView.insertItems(at: [collectionViewIndexPath])
            view.reloadInputViews()
          }
    
       
          
        
       func createPlayer() {
               let context = CoreDataManager.shared.persistentContainer.viewContext
               let player = NSEntityDescription.insertNewObject(forEntityName: "Player", into: context)
            player.setValue(playerOneName.text, forKey: "nickname")
            player.setValue(playerTwoName.text, forKey: "nicknameTwo")
               
               do {
                   try context.save()
                   //success
                self.didAddPlayer(player: player as! Player)
                print("Saved!!")
               } catch let saveErr {
                   print("Failed to save company.", saveErr)
               }
           }
    }
    


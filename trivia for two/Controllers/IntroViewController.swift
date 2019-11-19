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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rulesLabel: UILabel!
    @IBOutlet weak var playerOneName: UITextField!
    @IBOutlet weak var playerTwoName: UITextField!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var triviaImage: UIImageView!
    @IBOutlet weak var entertainmentLabel: UILabel!
    @IBOutlet weak var poweredBy: UILabel!
    
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
            self.navigationItem.title = "trivia for two"
            
            titleLabel.alpha = 0
            rulesLabel.alpha = 0
            playerOneName.alpha = 0
            playerTwoName.alpha = 0
            startGameButton.alpha = 0
            triviaImage.alpha = 0
            entertainmentLabel.alpha = 0
            poweredBy.alpha = 0
            showWelcome()
            showManual()
       
            
        }
    
 
        func showWelcome() {
        UIView.animate(withDuration: 1.5, animations: {
            self.entertainmentLabel.alpha = 1
            self.titleLabel.alpha = 1
            self.rulesLabel.alpha = 1
            self.poweredBy.alpha = 1
            self.triviaImage.alpha = 1
        }, completion: { (true) in
            self.showManual()
        }
        )
    }
    
        func showManual() {
        UIView.animate(withDuration: 1.5, animations: {
            self.playerOneName.alpha = 1
            self.playerTwoName.alpha = 1
            self.startGameButton.alpha = 1
        })
    }
        
  
        func didAddPlayer(player: Player) {
            players.append(player)
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
    


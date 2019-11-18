//
//  ViewController.swift
//  trivia for two
//
//  Created by Bartek Bugajski on 12/11/2019.
//  Copyright © 2019 BB. All rights reserved.
//

import UIKit
import CoreData

struct Answer {
    let title: String
    let isCorrect: Bool
}


class ViewController: UIViewController {
    
    var players = [Player]()
    var service = Service.shared
    var questions = [Question]()
    var activeAnswers = [Answer]()
    var defaultBackgroundColor: UIColor?
    var questionNumber: Int = 0
    var player: Player?
   
 
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerTwoName: UILabel!

    @IBOutlet weak var scoreLabel: UILabel!
                   var score: Int = 0
    @IBOutlet weak var secondScoreLabel: UILabel!
                   var scoreTwo: Int = 0
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var btnA: UIButton!
    @IBOutlet weak var btnB: UIButton!
    @IBOutlet weak var btnC: UIButton!
    @IBOutlet weak var btnD: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchQuestions()
        alignButtons()
        alphaZero()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1, animations: {
            self.fetchPlayers()
            self.playerName.alpha = 1
            self.playerTwoName.alpha = 1
            self.playerName.layer.backgroundColor = UIColor.green.cgColor
            self.playerName.layer.cornerRadius = 15
            self.playerTwoName.layer.cornerRadius = 15
        }) { (true) in
            self.showQuestion()
            }
        }
    
    func reloadView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let vc = storyboard.instantiateViewController(withIdentifier: "Main") as! ViewController
               self.present(vc, animated: true, completion: nil)
    }

    @IBAction func btnClicked(_ sender: UIButton) {
        questionNumber += 1
        if sender.tag == 1 {
            print("Correct Answer")
            if questionNumber <= 10 {
               score += 1
            } else if questionNumber >= 10 {
               scoreTwo += 1
            }
            assignAnswers()

            } else {
            print("Incorrect answer!")
            assignAnswers()
            }
         updateUI()
        }
    
    func restartQuizAlert() {
     let alert = UIAlertController(title: "Nice job!", message: "Time for the second player!", preferredStyle: .alert)
     let restartAction = UIAlertAction(title: "Let's go!", style: .default, handler: {action in self.updateUI()})
        alert.addAction(restartAction)
        present(alert, animated: true, completion: nil)
    }

    
    private func fetchPlayers() {
              // initialization of Core Data stack
              let context = CoreDataManager.shared.persistentContainer.viewContext
              let fetchRequest = NSFetchRequest<Player>(entityName: "Player")
          do {
              let players = try context.fetch(fetchRequest)
              players.forEach({ (player) in
                let nicknameOneIs = player.value(forKey: "nickname") as? String
                let nicknameTwoIs = player.value(forKey: "nicknameTwo") as? String
                 playerName.text = nicknameOneIs
                 playerTwoName.text = nicknameTwoIs
    
                print(player.nickname ?? "")
                print(player.nicknameTwo ?? "")
              })
                 self.players = players
              } catch let fetchErr {
                  print("Failed to save companies.", fetchErr)
              }
          }
}
        


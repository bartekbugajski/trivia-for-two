//
//  ViewController.swift
//  trivia for two
//
//  Created by Bartek Bugajski on 12/11/2019.
//  Copyright © 2019 BB. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//struct Answer {
//    let title: String
//    let isCorrect: Bool
//}

class SecondViewController: UIViewController {
    
    var service = Service.shared
    var questions = [Question]()
    var activeAnswers = [Answer]()
    var defaultBackgroundColor: UIColor?
    var score: Int = 0
    var questionNumber: Int = 0
    
    var players = [Player]()

           var player: Player?
        {
               didSet {

                playerTwoName.text = player?.nickname

               }
           }
    
    @IBOutlet weak var titleLabel: UILabel!
   // @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var playerTwoName: UILabel!
    @IBOutlet weak var btnA: UIButton!
    @IBOutlet weak var btnB: UIButton!
    @IBOutlet weak var btnC: UIButton!
    @IBOutlet weak var btnD: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchQuestions()
        fetchPlayers()
        setName()
        
      
        
        //alignButtons()
        
        titleLabel.alpha = 0
        playerTwoName.alpha = 0
        scoreLabel.alpha = 0
        questionLabel.alpha = 0
        btnA.alpha = 0
        btnB.alpha = 0
        btnC.alpha = 0
        btnD.alpha = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1, animations: {
            self.titleLabel.alpha = 1
            self.fetchPlayers()
            self.playerTwoName.alpha = 1
        }) { (true) in
            self.showQuestion()
            }
        }
    
    func setName() {
        playerTwoName.text = player?.nickname
    }
    
    func showQuestion() {
        UIView.animate(withDuration: 1, animations: {
            self.scoreLabel.alpha = 1
            self.questionLabel.alpha = 1
        }, completion: { (true) in
            self.showAnswers()
        }
        )
    }
    
    func showAnswers() {
        UIView.animate(withDuration: 1, animations: {
            self.btnA.alpha = 1
            self.btnB.alpha = 1
            self.btnC.alpha = 1
            self.btnD.alpha = 1
        })
    }

     func configureUI(){
        defaultBackgroundColor = btnD.backgroundColor
            for item in [btnA, btnB, btnC, btnD] {
                item?.isEnabled = false
            }
        setName()
        }
    
    func alignButtons() {
            btnA.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
            btnB.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
            btnC.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
            btnD.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
    }
    
    func updateUI() {
        scoreLabel.text = "Score: \(score)"
//        questionsCounter.text = "\(questionNumber + 1)/\(allQuestions.list.count)"
        //progressView.frame.size.width = (view.frame.size.width / CGFloat(questions.count)) * CGFloat(questionNumber)
    }
        
        func resetButtonTags(){
            btnA.tag = 0
            btnB.tag = 0
            btnC.tag = 0
            btnD.tag = 0
            for item in [btnA, btnB, btnC, btnD] {
                item?.backgroundColor = self.defaultBackgroundColor
            }
        }
        
        func enableButtons(){
            for item in [btnA, btnB, btnC, btnD] {
                item?.isEnabled = true
            }
        }
        
        func fetchQuestions() {
            service.fetchQuestions { (result) in
                DispatchQueue.main.async {
                    self.enableButtons()
                }
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let response):
                    self.questions = response.results
                    self.assignAnswers()
                }
            }
        }
        
        func assignAnswers(){
            if !self.questions.isEmpty {
                if let last = questions.popLast() {
                    var answers = [Answer]()
                    
                    // Adding answers
                    answers.append(Answer(title: last.correct_answer.htmlDecoded(), isCorrect: true))
                    for item in last.incorrect_answers {
                        answers.append(Answer(title: item.htmlDecoded(), isCorrect: false))
                    }
                    // Shuffle the array
                    answers.shuffle()
                    self.activeAnswers = answers
                    
                    DispatchQueue.main.async {

                        self.resetButtonTags()
                
                        self.questionLabel.text = last.question.htmlDecoded()
                        // Make sure the index is not out of range
                        self.btnA.setTitle(answers[0].title, for: .normal)
                        if answers[0].isCorrect { self.btnA.tag = 1 }
                        self.btnB.setTitle(answers[1].title, for: .normal)
                        if answers[1].isCorrect { self.btnB.tag = 1 }
                        self.btnC.setTitle(answers[2].title, for: .normal)
                        if answers[2].isCorrect { self.btnC.tag = 1 }
                        self.btnD.setTitle(answers[3].title, for: .normal)
                        if answers[3].isCorrect { self.btnD.tag = 1 }
                    }
                }
            } else {
                DispatchQueue.main.async {
                  
//                    if self.questionNumber >= self.questions.count {
//                    let alert = UIAlertController(title: "Awesome", message: "End of Quiz. Do you want to start over?", preferredStyle: .alert)
//                    let restartAction = UIAlertAction(title: "Restart", style: .default, handler: {action in self.restartQuiz()})
//                    alert.addAction(restartAction)
//                    self.present(alert, animated: true, completion: nil)
//                    print("wrong" )
//                    }
                    
                
            }
        }
    }
    
    func restartQuiz() {
        let scoreLabelInt = 0;
        scoreLabel.text = "Score: \(scoreLabelInt)"
        //score = 0
        questionNumber = 0
        configureUI()
        fetchQuestions()
    }
        
        @IBAction func btnClicked(_ sender: UIButton) {
            
            if sender.tag == 1 {
                //sender.backgroundColor = .green
                score += 1
                questionNumber += 1
                //assignAnswers()
                updateUI()
                //self.nextButton.isEnabled = true
            } else {
               // if self.questionNumber >= questions.underestimatedCount.distance(to: 11) {
//                let alert = UIAlertController(title: "Awesome", message: "End of Quiz. Do you want to start over?", preferredStyle: .alert)
//                let restartAction = UIAlertAction(title: "Restart", style: .default, handler: {action in self.restartQuiz()
//                    
//                    self.present(alert, animated: true, completion: nil)
//                })
//                    alert.addAction(restartAction)
//                  print("wrong" )
                    
                    
                }
                questionNumber += 1
                //sender.backgroundColor = .red
                assignAnswers()
            }
        
    
    
        
    
    func fetchPlayers() {
              // initialization of Core Data stack
              let context = CoreDataManager.shared.persistentContainer.viewContext
              let fetchRequest = NSFetchRequest<Player>(entityName: "Player")
          do {
              let players = try context.fetch(fetchRequest)
              players.forEach({ (player) in
                  

                  let nicknameOneIs = player.value(forKey: "nickname") as? String
                 // let nicknameTwoIs = player.value(forKey: "nicknameTwo") as? String
               
      //            player.setValue(labelPlayerOne.text, forKey: "nickname")
      //            player.setValue(labelPlayerTwo.text, forKey: "nickname2")
                playerTwoName.text = nicknameOneIs
                  print(player.nickname ?? "")
                  print(player.nicknameTwo ?? "")
                  
              })
              self.players = players
      //        self.collectionView.reloadData()
              } catch let fetchErr {
                  print("Failed to save companies.", fetchErr)
              }
          }

    
    }

        


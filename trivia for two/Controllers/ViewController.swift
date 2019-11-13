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
    
    var service = Service.shared
    var questions = [Question]()
    var activeAnswers = [Answer]()
    var defaultBackgroundColor: UIColor?
    var score: Int = 0
    var questionNumber: Int = 0
    
    var players = [Player]()
           
           var player: Player?
//           {
//               didSet {
//                   
//                playerName.text = player?.nickname
//                //scoreLabel.text = player?.highScore
//                   
//               }
//           }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var btnA: UIButton!
    @IBOutlet weak var btnB: UIButton!
    @IBOutlet weak var btnC: UIButton!
    @IBOutlet weak var btnD: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func nextPlayer(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SecondController")
              self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchQuestions()
        //alignButtons()
        
        titleLabel.alpha = 0
        playerName.alpha = 0
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
            self.playerName.alpha = 1
        }) { (true) in
            self.showQuestion()
            }
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
            self.defaultBackgroundColor = btnD.backgroundColor
            for item in [btnA, btnB, btnC, btnD] {
                item?.isEnabled = false
            }
            nextButton.isEnabled = false
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
                        self.nextButton.isEnabled = false
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
                    //self.nextButton.isEnabled = false
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
        score = 0
        questionNumber = 0
        configureUI()
        fetchQuestions()
    }
        
        @IBAction func btnClicked(_ sender: UIButton) {
            
            if sender.tag == 1 {
                //sender.backgroundColor = .green
                score += 1
                questionNumber += 1
                assignAnswers()
                updateUI()
                //self.nextButton.isEnabled = true
            } else {
                if self.questionNumber >= questions.count {
                saveScore()
                    
                print("player 1 finished")
                nextButton.isEnabled = true
                }
                questionNumber += 1
                //sender.backgroundColor = .red
                assignAnswers()
                
            }
        }
    
    func presentSecondPlayer() {
        let secondVC = SecondViewController()
        present(secondVC, animated: true)
    }
        
        @IBAction func showNext(_ sender: UIButton) {
           presentSecondPlayer()
        }
    
    func didAddPlayer(player: Player) {
        players.append(player)
          }
          
    
    
    func saveScore() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
                      let player = NSEntityDescription.insertNewObject(forEntityName: "Player", into: context)
                   player.setValue(score, forKey: "highScore")
                      
                      do {
                          try context.save()
                          //success
                        self.didAddPlayer(player: player as! Player)
                       print("Saved!!")
                      } catch let saveErr {
                          print("Failed to save company.", saveErr)
                      }
                  }
    
    
    func fetchPlayers() {
              // initialization of Core Data stack
              let context = CoreDataManager.shared.persistentContainer.viewContext
              let fetchRequest = NSFetchRequest<Player>(entityName: "Player")
          do {
              let players = try context.fetch(fetchRequest)
              players.forEach({ (player) in
                  

                  let nicknameOneIs = player.value(forKey: "nickname") as? String
                  //let nicknameTwoIs = player.value(forKey: "nickname2") as? String
               
      //            player.setValue(labelPlayerOne.text, forKey: "nickname")
      //            player.setValue(labelPlayerTwo.text, forKey: "nickname2")
                playerName.text = nicknameOneIs
            
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
        



extension String {
    func htmlDecoded()->String {

        guard (self != "") else { return self }

        var newStr = self

        let entities = [
            "&quot;"    : "\"",
            "&amp;"     : "&",
            "&apos;"    : "'",
            "&lt;"      : "<",
            "&gt;"      : ">",
            "&#039;"    : "'",
            "&oacute;"  : "o",
            "&rsquo;"   : "'",
            "&Eacute;"  : "É",
            "&ldquo"    : " '' "
            
        ]

        for (name,value) in entities {
            newStr = newStr.replacingOccurrences(of: name, with: value)
        }
        return newStr
    }
}


extension UIButton {
    @IBInspectable
        var cornerRadius: CGFloat {
            get {
                return layer.cornerRadius
            }
            set {
                layer.cornerRadius = newValue
            }
        }

        @IBInspectable
        var borderWidth: CGFloat {
            get {
                return layer.borderWidth
            }
            set {
                layer.borderWidth = newValue
            }
        }
        
        @IBInspectable
        var borderColor: UIColor? {
            get {
                if let color = layer.borderColor {
                    return UIColor(cgColor: color)
                }
                return nil
            }
            set {
                if let color = newValue {
                    layer.borderColor = color.cgColor
                } else {
                    layer.borderColor = nil
                }
            }
        }
        
        @IBInspectable
        var shadowRadius: CGFloat {
            get {
                return layer.shadowRadius
            }
            set {
                layer.shadowRadius = newValue
            }
        }
        
        @IBInspectable
        var shadowOpacity: Float {
            get {
                return layer.shadowOpacity
            }
            set {
                layer.shadowOpacity = newValue
            }
        }
        
        @IBInspectable
        var shadowOffset: CGSize {
            get {
                return layer.shadowOffset
            }
            set {
                layer.shadowOffset = newValue
            }
        }
        
        @IBInspectable
        var shadowColor: UIColor? {
            get {
                if let color = layer.shadowColor {
                    return UIColor(cgColor: color)
                }
                return nil
            }
            set {
                if let color = newValue {
                    layer.shadowColor = color.cgColor
                } else {
                    layer.shadowColor = nil
                }
            }
        }
    }


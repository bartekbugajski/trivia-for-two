//
//  ViewControllerExtension.swift
//  trivia for two
//
//  Created by Bartek Bugajski on 13/11/2019.
//  Copyright © 2019 BB. All rights reserved.
//

import UIKit

extension ViewController {
    
    func didAddPlayer(player: Player) {
    players.append(player)
      }
    
    //keeps everything invisible so it fades in nicely
    func alphaZero() {
        playerName.alpha = 0
        playerTwoName.alpha = 0
        scoreLabel.alpha = 0
        secondScoreLabel.alpha = 0
        questionLabel.alpha = 0
        btnA.alpha = 0
        btnB.alpha = 0
        btnC.alpha = 0
        btnD.alpha = 0
    }
    
    func showQuestion() {
        UIView.animate(withDuration: 1.5, animations: {
            self.scoreLabel.alpha = 1
            self.secondScoreLabel.alpha = 1
            self.questionLabel.alpha = 1
        }, completion: { (true) in
            self.showAnswers()
        }
        )
    }
    
    func showAnswers() {
         UIView.animate(withDuration: 1.5, animations: {
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
         }
    

     
     func alignButtons() {
             btnA.titleLabel?.textAlignment = NSTextAlignment.center
             btnB.titleLabel?.textAlignment = NSTextAlignment.center
             btnC.titleLabel?.textAlignment = NSTextAlignment.center
             btnD.titleLabel?.textAlignment = NSTextAlignment.center
        
            btnA.titleLabel?.numberOfLines = 3
            btnB.titleLabel?.numberOfLines = 3
            btnC.titleLabel?.numberOfLines = 3
            btnD.titleLabel?.numberOfLines = 3
     }
     
     func updateUI() {
         scoreLabel.text = "\(score)"
         secondScoreLabel.text = "\(scoreTwo)"
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
                        if self.questionNumber >= 10 {
                            self.playerName.layer.backgroundColor = UIColor.clear.cgColor
                            self.playerName.layer.cornerRadius = 15
                            self.playerTwoName.layer.backgroundColor = UIColor.pink.cgColor
                            self.playerTwoName.layer.cornerRadius = 15
                                            }
                        if self.questionNumber >= 20 {
                            print("GAME OVER!")
                            self.gameOverAlert()
                        }
                     }
                   
                 }
             }
         }
    
    func restartQuizAlert() {
     let alert = UIAlertController(title: "Nice job!", message: "Time for the second player!", preferredStyle: .alert)
     let restartAction = UIAlertAction(title: "Let's go!", style: .default, handler: {action in self.reloadView()})
        alert.addAction(restartAction)
        present(alert, animated: true, completion: nil)
    }
    
    func gameOverAlert() {
        let alert = UIAlertController(title: "Game over!", message: "Let's go again!", preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Ready", style: .default, handler: {action in self.startOver()})
           alert.addAction(restartAction)
           present(alert, animated: true, completion: nil)
    }
    
    func startOver() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let introVC = storyboard.instantiateViewController(withIdentifier: "intro") as! IntroViewController
               self.present(introVC, animated: true, completion: nil)
    }

}

extension UIColor {
    
    static let borderPurple = UIColor(red: 235/255, green: 218/255, blue: 235/255, alpha: 1)
    static let pink = UIColor(red: 215/255, green: 188/255, blue: 208/255, alpha: 1)
    static let noir = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    static let blue = UIColor(red: 74/255, green: 115/255, blue: 207/255, alpha: 1)
    static let orange = UIColor(red: 237/255, green: 150/255, blue: 54/255, alpha: 1)
    static let backgroundColor = UIColor(red: 255/255, green: 224/244, blue: 204/255, alpha: 2)
    static let tempFontColor = UIColor(red: 196/255, green: 184/255, blue: 166/255, alpha: 1)
    static let greenColor = UIColor(red: 115/255, green: 237/255, blue: 110/255, alpha: 1)
    
}

extension String {
    func htmlDecoded()-> String {

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

extension UILabel {
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

}

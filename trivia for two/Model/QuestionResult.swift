//
//  QuestionResult.swift
//  trivia for two
//
//  Created by Bartek Bugajski on 12/11/2019.
//  Copyright © 2019 BB. All rights reserved.
//

import Foundation

struct QuestionResult: Decodable {
   // let questionNumber: Int
    let results: [Question]
}

struct Question: Decodable {
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
   
}

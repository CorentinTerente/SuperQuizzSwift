//
//  Question.swift
//  SuperQuizz
//
//  Created by formation2 on 04/12/2018.
//  Copyright © 2018 formation2. All rights reserved.
//

import Foundation

class Question {
    var id: Int?
    var title: String
    var correctAnswer: Int
    var propositions: [String]?
    var userChoice: String?
    
    init(_ title: String, _ correctAnswer: Int, _ id: Int) {
        self.title = title
        self.propositions = ["rep1","rep2","rep3","rep4"]
        self.correctAnswer = correctAnswer
        self.id = id
    }
    
    init(_ title: String, _ correctAnswer: Int) {
        self.title = title
        self.correctAnswer = correctAnswer
    }
    
    
    
    func verifyAnswer() -> Bool{
        guard let validPropositions = self.propositions else {
            return false
        }
        return self.userChoice == validPropositions[correctAnswer - 1]
    }
}

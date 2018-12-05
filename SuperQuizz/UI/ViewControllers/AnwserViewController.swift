//
//  ViewController.swift
//  SuperQuizz
//
//  Created by formation2 on 04/12/2018.
//  Copyright © 2018 formation2. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {

    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    
    
    var question: Question?
    private var onQuestionAnswered: ((_ q : Question,_ isCorrectAnswer : Bool)->() )?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let question = question else {
            return
        }
        
        questionTitleLabel.text = question.title
        
        answerButton1.setTitle(question.propositions[0], for: .normal)
        answerButton2.setTitle(question.propositions[1], for: .normal)
        answerButton3.setTitle(question.propositions[2], for: .normal)
        answerButton4.setTitle(question.propositions[3], for: .normal)
        
      
    }
    
    func setOnReponseAnswered(closure : @escaping (_ question: Question,_ isCorrectAnswer :Bool)->()) {
        onQuestionAnswered = closure
    }
    
    func userDidChooseAnswer(isCorrectAnswer : Bool){
        guard let question = question else {
            return
        }
        if isCorrectAnswer {
            print("Bonne reponse")
        } else {
            print("Mauvaise reponse")
        }
        onQuestionAnswered?(question,isCorrectAnswer)
    }

    @IBAction func answerButtonTapped(_ sender: UIButton) {
        
        guard let question = question else {
            return
        }
        question.userChoice = sender.titleLabel?.text
        
        userDidChooseAnswer(isCorrectAnswer: question.verifyAnswer())
    }
    
}


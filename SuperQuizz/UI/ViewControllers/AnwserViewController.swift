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
    @IBOutlet weak var timerProgressBar: UIProgressView!
    
    
    var question: Question?
    var work: DispatchWorkItem?
    var timeRemaining: Float = 5
    var timer: Timer = Timer()
    var timerIsOn: Bool = false
    
    private var onQuestionAnswered: ((_ q : Question,_ isCorrectAnswer : Bool)->() )?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let question = question else {
            return
        }
        
        questionTitleLabel.text = question.title
        
        answerButton1.setTitle(question.propositions?[0], for: .normal)
        answerButton2.setTitle(question.propositions?[1], for: .normal)
        answerButton3.setTitle(question.propositions?[2], for: .normal)
        answerButton4.setTitle(question.propositions?[3], for: .normal)
        
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
        timerIsOn = true
       
        work = DispatchWorkItem {
        DispatchQueue.global(qos: .userInitiated).async {
            var i: Float = 0
            while self.timerIsOn {
                if self.work!.isCancelled {
                    return
                }
                
                Thread.sleep(forTimeInterval: 0.1)
                i += 0.1
                
                DispatchQueue.main.async {
                    self.timerProgressBar.setProgress(0.2*Float(i), animated: true)
                    
                }
                
            }
            DispatchQueue.main.async {
                self.userDidNotChooseAnswer()
            }
            
        }
    }
        work?.perform()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        work?.cancel()
    }
    
    @objc
    func timerRunning(){
        timeRemaining -= 0.1
        if timeRemaining <= 0 {
            timerIsOn = false
            timer.invalidate()
        }
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
    
    func userDidNotChooseAnswer(){
        guard let question = question else {
            return
        }
        question.userChoice = ""
        onQuestionAnswered?(question,false)
    }

    @IBAction func answerButtonTapped(_ sender: UIButton) {
        work?.cancel()
        
        guard let question = question else {
            return
        }
        question.userChoice = sender.titleLabel?.text
        
        userDidChooseAnswer(isCorrectAnswer: question.verifyAnswer())
    }
    
}


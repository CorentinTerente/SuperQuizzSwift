//
//  CreateOrEditQuestionViewController.swift
//  SuperQuizz
//
//  Created by formation2 on 05/12/2018.
//  Copyright © 2018 formation2. All rights reserved.
//

import UIKit

protocol CreateOrEditQuestionDelegate : AnyObject {
    func userDidEditQuestion(q : Question) -> ()
    func userDidCreateQuestion(q : Question) -> ()
}

class CreateOrEditQuestionViewController: UIViewController {
    
    @IBOutlet weak var createOrEditButtun: UIButton!
    @IBOutlet weak var questionTitleTextField: UITextField!
    @IBOutlet weak var proposition1TextField: UITextField!
    @IBOutlet weak var proposition2TextField: UITextField!
    @IBOutlet weak var proposition3TextField: UITextField!
    @IBOutlet weak var proposition4TextField: UITextField!
    @IBOutlet weak var correctAnswer1Switch: UISwitch!
    @IBOutlet weak var correctAnswer2Switch: UISwitch!
    @IBOutlet weak var correctAnswer3Switch: UISwitch!
    @IBOutlet weak var correctAnswer4Switch: UISwitch!
    
    var questionToEdit: Question?
    weak var delegate : CreateOrEditQuestionDelegate?
    var previouslySetOnSwitch: UISwitch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let question = questionToEdit {
            createOrEditButtun.setTitle("Edit", for: .normal)
            
            guard let validPropositions = question.propositions else {
                return
            }
            questionTitleTextField.text = question.title
            proposition1TextField.text = validPropositions[0]
            proposition2TextField.text = validPropositions[1]
            proposition3TextField.text = validPropositions[2]
            proposition4TextField.text = validPropositions[3]
            
            switch question.correctAnswer {
                case 0:
                    correctAnswer1Switch.setOn(true, animated: true)
                    previouslySetOnSwitch = correctAnswer1Switch
                case 1:
                    correctAnswer2Switch.setOn(true, animated: true)
                    previouslySetOnSwitch = correctAnswer2Switch
                case 2:
                    correctAnswer3Switch.setOn(true, animated: true)
                    previouslySetOnSwitch = correctAnswer3Switch
                case 3:
                    correctAnswer4Switch.setOn(true, animated: true)
                    previouslySetOnSwitch = correctAnswer4Switch
                default:
                    correctAnswer1Switch.setOn(true, animated: true)
                    previouslySetOnSwitch = correctAnswer1Switch
            }
            
        } else {
            createOrEditButtun.setTitle("Create", for: .normal)
        }
    }
    
    func createOrEditQuestion () {
        if let question = questionToEdit {
            
            question.title = questionTitleTextField.text!
            question.propositions?[0] = proposition1TextField.text!
            question.propositions?[1] = proposition2TextField.text!
            question.propositions?[2] = proposition3TextField.text!
            question.propositions?[3] = proposition4TextField.text!
            
            if correctAnswer1Switch.isOn {
                question.correctAnswer = 0
                
            } else if correctAnswer2Switch.isOn {
                question.correctAnswer = 1
                
            } else if correctAnswer3Switch.isOn {
                question.correctAnswer = 2
                
            } else if correctAnswer4Switch.isOn {
                question.correctAnswer = 3
            }
            
            delegate?.userDidEditQuestion(q: question)
        } else {
            guard let questionTitle = questionTitleTextField.text else {
                return
            }
            guard let proposition1 = proposition1TextField.text else {
                return
            }
            guard let proposition2 = proposition2TextField.text else {
                return
            }
            guard let proposition3 = proposition3TextField.text else {
                return
            }
            guard let proposition4 = proposition4TextField.text else {
                return
            }
            
            var correctAnswer: Int = 0
            
            if correctAnswer1Switch.isOn {
                correctAnswer = 1
                
            } else if correctAnswer2Switch.isOn {
                correctAnswer = 2
                
            } else if correctAnswer3Switch.isOn {
                correctAnswer = 3
                
            } else if correctAnswer4Switch.isOn {
                correctAnswer = 4
            }
            let question = Question(questionTitle, correctAnswer)
            question.propositions = [proposition1, proposition2, proposition3, proposition4]
            
            delegate?.userDidCreateQuestion(q: question)
        }
        
    }
    
    @IBAction func onSwitchTapped(_ sender: UISwitch) {
        if previouslySetOnSwitch != nil {
            previouslySetOnSwitch?.setOn(false, animated: true)
        }
        
        sender.setOn(true, animated: true)
        previouslySetOnSwitch = sender
    }
    
    @IBAction func onButtonCreateOrEditTapped(_ sender: Any) {
        self.createOrEditQuestion()
    }
    
}

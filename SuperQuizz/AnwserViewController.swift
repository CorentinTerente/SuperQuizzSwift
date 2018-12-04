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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard let question = question else {
            return
        }
        guard let validProposition = question.propositions else {
            return
        }
        questionTitleLabel.text = question.title
        
        answerButton1.setTitle(validProposition[0], for: .normal)
        answerButton2.setTitle(validProposition[1], for: .normal)
        answerButton3.setTitle(validProposition[2], for: .normal)
        answerButton4.setTitle(validProposition[3], for: .normal)
    }


}


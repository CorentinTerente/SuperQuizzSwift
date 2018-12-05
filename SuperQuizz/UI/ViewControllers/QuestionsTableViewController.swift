//
//  QuestionsTableViewController.swift
//  SuperQuizz
//
//  Created by formation2 on 04/12/2018.
//  Copyright © 2018 formation2. All rights reserved.
//

import UIKit

class QuestionsTableViewController: UITableViewController {
 var questions: [Question] = [Question("Premiere Question",0,0), Question("Deuxieme Question",3,1), Question("Troisieme Question",0,2)]
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return questions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell
        
        cell.questionTitleLabel.text = questions[indexPath.row].title
        
        if questions[indexPath.row].userChoice != nil {
            if questions[indexPath.row].verifyAnswer() {
                cell.backgroundColor = UIColor.green
            } else {
                cell.backgroundColor = UIColor.red
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexpath) in
           
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateOrEditQuestionViewController") as! CreateOrEditQuestionViewController
            controller.delegate = self
            controller.questionToEdit = self.questions[indexPath.row]
            self.present(controller, animated: true, completion: nil)
            
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexpath) in
            self.questions.remove(at: indexPath.row)
            tableView.reloadData()
        }
        return [editAction,deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AnswerViewController") as! AnswerViewController
        vc.question = questions[indexPath.row]
        
        vc.setOnReponseAnswered(closure: { (questionAnswered, result) in
            self.questions[indexPath.row] = questionAnswered
            
            self.navigationController?.popViewController(animated: true)
            self.tableView.reloadData()
    
        })
        
        self.show(vc, sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCreateOrEditViewController" {
            let controller = segue.destination as! CreateOrEditQuestionViewController
            controller.delegate = self
        }
    }
    

}
extension QuestionsTableViewController : CreateOrEditQuestionDelegate {
    func userDidEditQuestion(q: Question) {
        for question in questions {
            if question.id == q.id {
                questions.remove(at: question.id ?? 0)
                questions.append(q)
            }
        }
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
    func userDidCreateQuestion(q: Question) {
        q.id = questions.count
        questions.append(q)
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
}

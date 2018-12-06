//
//  QuestionsTableViewController.swift
//  SuperQuizz
//
//  Created by formation2 on 04/12/2018.
//  Copyright © 2018 formation2. All rights reserved.
//

import UIKit

class QuestionsTableViewController: UITableViewController {
 var questions: [Question]?
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       APIClient.instance.getAllQuestionsFromServer(onSuccess: { (serverQuestions) in
        
        DispatchQueue.main.async {
            self.questions = serverQuestions
            self.tableView.reloadData()
        }
        
            
        }) { (error) in
            
            print(error)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let questions = questions else {
            return 0
        }
        return questions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell
        
        guard let questions = questions else {
            return cell
        }
        
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
            
            guard let questions = self.questions else {
                return
            }
            
            controller.questionToEdit = questions[indexPath.row]
            self.present(controller, animated: true, completion: nil)
            
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexpath) in
            
                
                APIClient.instance.deleteQuestionsFromServer(id: self.questions![indexPath.row].id!, onSuccess: {
                    
                    DispatchQueue.main.async {
                        
                        self.questions!.remove(at: indexPath.row)
                        self.tableView.reloadData()
                    }
                    
                    
                }, onError: { (error) in
                    
                    print(error)
                })
                
            
            
            tableView.reloadData()
        }
        return [editAction,deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AnswerViewController") as! AnswerViewController
        if var questions = questions {
            vc.question = questions[indexPath.row]
            
            vc.setOnReponseAnswered(closure: { (questionAnswered, result) in
                questions[indexPath.row] = questionAnswered
                
                self.navigationController?.popViewController(animated: true)
                self.tableView.reloadData()
        
            })
        }
        
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
        
        if var questions = questions {
            APIClient.instance.updateQuestionToServer(newQuestion: q, onSuccess: { (updatedQuestion) in
                
                DispatchQueue.main.async {
                    for i in 0...questions.count {
                        if questions[i].id == updatedQuestion.id {
                            questions.remove(at: i)
                            questions.append(updatedQuestion)
                            break
                        }
                    }
                    q.userChoice = nil
                    self.tableView.reloadData()
                }
                
            }) { (error) in
                
                print(error)
            }
           
        }
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
    func userDidCreateQuestion(q: Question) {
        if var  questions = questions {
            
            APIClient.instance.addQuestionToServer(newQuestion: q, onSuccess: { (question) in
                DispatchQueue.main.async {
                    
                    questions.append(question)
                    self.tableView.reloadData()
                }
                
                
            }) { (error) in
                
                print(error)
            }
            
        }
        
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
}

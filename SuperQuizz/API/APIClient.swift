//
//  AppDelegate.swift
//  SuperQuizz
//
//  Created by formation2 on 06/12/2018.
//  Copyright © 2018 formation2. All rights reserved.
//

import Foundation


class APIClient {
    
    static let instance = APIClient()
    
    private let urlServer = "http://192.168.10.213:3000"
    private let keyCorrectAnswer = "correct_answer"
    private let keyId = "id"
    private let keyAnswer1 = "answer_1"
    private let keyAnswer2 = "answer_2"
    private let keyAnswer3 = "answer_3"
    private let keyAnswer4 = "answer_4"
    private let keyTitle = "title"
    private init () {}
    
    
    //Recuperer toutes les questions
    @discardableResult
    func getAllQuestionsFromServer(onSuccess:@escaping ([Question])->(), onError:@escaping (Error)->())-> URLSessionTask {
        
        //préparation de la requete
        var request = URLRequest(url: URL(string: "\(urlServer)/questions")! )
        request.httpMethod = "GET"
        
        // preparation de la tache de telechargezmebnt des données
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // si j'ai de la donnée
            if let data = data {
                
                // Je la transforme en Array
                let dataArray = try! JSONSerialization.jsonObject(with: data, options: []) as! [Any]
                var questionsToreturn = [Question]()
                // pour chaque objet d'ans l'array
                for object in dataArray {
                    
                    let objectDictionary = object as! [String:Any]
                    var q: Question?
                    
                    q = Question(objectDictionary[self.keyTitle] as! String, objectDictionary[self.keyCorrectAnswer] as! Int)
                    q?.propositions = [objectDictionary[self.keyAnswer1] as! String, objectDictionary[self.keyAnswer2] as! String, objectDictionary[self.keyAnswer3] as! String, objectDictionary[self.keyAnswer4] as! String]
                    q?.id = objectDictionary[self.keyId] as? Int
                    
                    guard let question = q else {
                        return
                    }
                    questionsToreturn.append(question)
                }
                onSuccess(questionsToreturn)
                
            } else  {
                onError(error!)
            }
        }
        // lance la tache
        task.resume()
        
        // revoie la tache pour pouvoir l'annuler
        return task
    }
    @discardableResult
    func deleteQuestionsFromServer(id:Int, onSuccess:@escaping ()->(), onError:@escaping (Error)->())-> URLSessionTask {
        
        //préparation de la requete
        var request = URLRequest(url: URL(string: "\(urlServer)/questions/" + String(id))! )
        request.httpMethod = "DELETE"
        
        // preparation de la tache de telechargezmebnt des données
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // si j'ai de la reposnse
            if response != nil {
                onSuccess()
                
            } else  {
                onError(error!)
            }
        }
        // lance la tache
        task.resume()
        
        // revoie la tache pour pouvoir l'annuler
        return task
    }
    @discardableResult
    func addQuestionToServer(newQuestion: Question, onSuccess:@escaping (Question)->(), onError:@escaping (Error)->())-> URLSessionTask {
        
        let parameters = [keyTitle: newQuestion.title, keyAnswer1: newQuestion.propositions![0], keyAnswer2: newQuestion.propositions![1], keyAnswer3: newQuestion.propositions![2], keyAnswer4: newQuestion.propositions![3], keyCorrectAnswer: newQuestion.correctAnswer] as [String : Any]
        
        var request = URLRequest(url: URL(string: "\(urlServer)/questions/")!)
        request.httpMethod = "POST"
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) {(data,response,error) in
            
            if let data = data {
                
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                var questionToreturn: Question?
               
    
                questionToreturn = Question(dataDictionary[self.keyTitle] as! String, dataDictionary[self.keyCorrectAnswer] as! Int)
                questionToreturn?.propositions = [dataDictionary[self.keyAnswer1] as! String, dataDictionary[self.keyAnswer2] as! String, dataDictionary[self.keyAnswer3] as! String, dataDictionary[self.keyAnswer4] as! String]
                questionToreturn?.id = dataDictionary[self.keyId] as? Int
                
                onSuccess(questionToreturn!)
            } else {
                
                onError(error!)
            }
            
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func updateQuestionToServer(newQuestion: Question, onSuccess:@escaping (Question)->(), onError:@escaping (Error)->())-> URLSessionTask {
        
        let parameters = [keyTitle: newQuestion.title, keyAnswer1: newQuestion.propositions![0], keyAnswer2: newQuestion.propositions![1], keyAnswer3: newQuestion.propositions![2], keyAnswer4: newQuestion.propositions![3], keyCorrectAnswer: newQuestion.correctAnswer, keyId: newQuestion.id!] as [String : Any]
        
        var request = URLRequest(url: URL(string: "\(urlServer)/questions/" + String(newQuestion.id!))!)
        request.httpMethod = "PUT"
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) {(data,response,error) in
            
            if let data = data {
                
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                var questionToreturn: Question?
                
                
                questionToreturn = Question(dataDictionary[self.keyTitle] as! String, dataDictionary[self.keyCorrectAnswer] as! Int)
                questionToreturn?.propositions = [dataDictionary[self.keyAnswer1] as! String, dataDictionary[self.keyAnswer2] as! String, dataDictionary[self.keyAnswer3] as! String, dataDictionary[self.keyAnswer4] as! String]
                questionToreturn?.id = dataDictionary[self.keyId] as? Int
                
                onSuccess(questionToreturn!)
            } else {
                
                onError(error!)
            }
            
        }
        
        task.resume()
        return task
    }
    
    
    
}

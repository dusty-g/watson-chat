//
//  ViewController.swift
//  watson
//
//  Created by Dustin Galindo on 5/18/17.
//  Copyright © 2017 Dustin Galindo. All rights reserved.
//

import UIKit
import ConversationV1
import RestKit

class ViewController: UIViewController {
    let username = "3727e5c7-af42-4a2e-9b6b-469e995aad28"
    let password = "8704S6GPogEq"
    let version = "2017-05-19" // use today's date for the most recent version
    let workspaceID = "cb5e5efb-6153-4218-a037-f9affe94fbc4"
    let failure = { (error: Error) in print(error) }
    var context: Context? // save context to continue conversation
    var conversation: Conversation?
    var convoWithWatson = [String]()
    
    //@IBOutlet weak var watsonConvoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // on submit button pressed
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        //
        guard let text = inputLabel.text else {
            return
        }
        
        //
        let failure = { (error: Error) in print(error) }
        
        //
        let request = MessageRequest(text: text, context: context)
        
        //
        conversation!.message(withWorkspace: workspaceID, request: request, failure: failure) {
            response in
            self.context = response.context
            DispatchQueue.main.async {
                self.convoWithWatson.append(String(response.output.text[0]))
                    self.tableView.reloadData()
            }
            //print(response.output.text)
            print(self.convoWithWatson)
        }
        inputLabel.text = ""
        
        
        //        conversation!.message(withWorkspace: workspaceID, request: request, failure: failure){
        //            response in
        //            let pokemonList = response.context.json["pokemon_list"] as! [String]
        //            print(pokemonList)
        //        }
        
    }
    
    @IBOutlet weak var inputLabel: UITextField!
    @IBOutlet weak var responseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        conversation = Conversation(username: username, password: password, version: version)
        conversation!.message(withWorkspace: workspaceID, failure: failure) { response in
            DispatchQueue.main.async {
                //self.responseLabel.text = String(describing: response.output.text[0])
                self.convoWithWatson.append(String(describing: response.output.text[0]))
            }
            //print(response.output.text[0])
            self.context = response.context
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return convoWithWatson.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        
        cell.textLabel?.text = convoWithWatson[indexPath.row]
        print(indexPath.row)
        return cell
        
    }
}



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
    let username = "077db431-7c82-499a-a0aa-e6290c1b9872"
    let password = "7rBdObraiydN"
    let version = "2017-05-18" // use today's date for the most recent version
    let workspaceID = "d8fefb98-6301-4769-ac80-891a855bc8f3"
    let failure = { (error: Error) in print(error) }
    var context: Context? // save context to continue conversation
    var conversation: Conversation?
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        guard let text = inputLabel.text else {
            return
        }
        
        let failure = { (error: Error) in print(error) }
        let request = MessageRequest(text: text, context: context)
        conversation!.message(withWorkspace: workspaceID, request: request, failure: failure) {
            response in
            print(response.output.text)
            self.context = response.context
            DispatchQueue.main.async {
                self.responseLabel.text = String(response.output.text[0])
            }
        }
        inputLabel.text = ""
        
    }
    
    @IBOutlet weak var inputLabel: UITextField!
    @IBOutlet weak var responseLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        conversation = Conversation(username: username, password: password, version: version)
        

        conversation!.message(withWorkspace: workspaceID, failure: failure) { response in
            DispatchQueue.main.async {
                self.responseLabel.text = String(describing: response.output.text[0])
            }
            self.responseLabel.text = String(describing: response.output.text[0])
            print(response.output.text[0])
            self.context = response.context
        }
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



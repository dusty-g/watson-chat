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
    let version = "2017-05-18" // use today's date for the most recent version
    let workspaceID = "48a704fe-2518-4b1e-82e4-4e2007b2f1cb"
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



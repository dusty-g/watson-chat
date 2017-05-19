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
    let password = "*******"
    let version = "2017-05-18" // use today's date for the most recent version
    let workspaceID = "17b0951c-eb03-4806-b0eb-85c7d8e5cf7b"
    let failure = { (error: Error) in print(error) }
    var context: Context? // save context to continue conversation
    var conversation: Conversation?
    var imageSource = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        self.imageView.isHidden = true
        guard let text = inputLabel.text else {
            return
        }
        
        let failure = { (error: Error) in print(error) }
        let request = MessageRequest(text: text, context: context)
        conversation!.message(withWorkspace: workspaceID, request: request, failure: failure) {
            response in
            
            self.context = response.context
            DispatchQueue.main.async {
                self.responseLabel.text = String(response.output.text[0])
                
                let pokemonID = response.output.json["pokemonID"]
                if pokemonID != nil {
                    print(pokemonID!)
                    self.imageView.downloadedFrom(link: self.imageSource + String(describing: pokemonID!) + ".png")
                    print(self.imageSource + String(describing: pokemonID!) + ".png")
                    self.imageView.isHidden = false
                }

            }
            
        }
        inputLabel.text = ""
        
    }
    
    @IBOutlet weak var inputLabel: UITextField!
    @IBOutlet weak var responseLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        responseLabel.isHidden = true
        conversation = Conversation(username: username, password: password, version: version)
        

        conversation!.message(withWorkspace: workspaceID, failure: failure) { response in
            DispatchQueue.main.async {
                self.responseLabel.text = String(describing: response.output.text[0])
                self.responseLabel.isHidden = false
            }
            self.responseLabel.text = String(describing: response.output.text[0])
            
            self.context = response.context
            
            
        }
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}


//
//  ViewController.swift
//  iOS Laravel
//
//  Created by Suebtas on 10/8/2559 BE.
//  Copyright © 2559 Suebtas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var textFieldUsername: UITextField!
    var tokenValue:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func VerifyMethod(_ sender: AnyObject) {
        let username = textFieldUsername.text!
        let password = textFieldPassword.text!
        //if(isStringEmpty(username) || isStringEmpty(password)){
        //    return
        //}
        textFieldUsername.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        // Send HTTP GET Request
        
        // Define server side script URL
        let myUrl = URL(string:"http://172.17.1.224:8000/api/auth/login")
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"// Compose a query string
        
        let postString = "password=\(password)&email=\(username)"
        //print(postString);
        request.httpBody = postString.data(using: .utf8);
        
        let task = URLSession.shared.dataTask(with:request) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
            
            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                    
                    // Get value by key
                    if let tokenValue = convertedJsonIntoDict["token"] as? String{
                        print(tokenValue)
                        
                        //self.tokenValue = tokenValue
                        //self.tokenLabel.text = tokenValue
                        
                        self.performSelector(onMainThread: #selector(ViewController.updateTokenLabel(_:)),
                                             with: tokenValue, waitUntilDone: false)
                        

                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
    }
    func updateTokenLabel(_ text: String) {
        
        self.tokenLabel.text = "Your Token is " + text
        self.performSegue(withIdentifier: "show", sender: self);
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isStringEmpty(_ stringValue:String) -> Bool
    {
        var stringValue = stringValue
        var returnValue = false
        
        if stringValue.isEmpty  == true
        {
            returnValue = true
            return returnValue
        }
        
        // Make sure user did not submit number of empty spaces
        stringValue = stringValue.trimmingCharacters(in: .whitespaces)
        
        if(stringValue.isEmpty == true)
        {
            returnValue = true
            return returnValue
            
        }
        
        return returnValue
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            
        }
    }
}


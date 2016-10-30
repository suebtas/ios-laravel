//
//  ViewController.swift
//  iOS Laravel
//
//  Created by Suebtas on 10/8/2559 BE.
//  Copyright © 2559 Suebtas. All rights reserved.
//

import UIKit

class VersifyViewController: UIViewController {
    
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
        
        let baseURL = "http://172.17.1.224:8000/" //เช่น http://172.17.1.224:8000/
        let path = "api/auth/login"
        let urlString = "\(baseURL)\(path)"
        let postString = "password=\(password)&email=\(username)"

        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "Post"
        urlRequest.httpBody = postString.data(using: .utf8)
        
        
        let networkProcessing = NetworkProcessing(request: urlRequest)
        
        networkProcessing.downloadJSON { (json, httpResponse, error) in
            if let dictionary = json {
                if let tokenValue = dictionary["token"] as? String {
                    LocalStore.saveToken(tokenValue)
                    self.performSelector(onMainThread: #selector(VersifyViewController.updateTokenLabel(_:)),
                                         with: tokenValue, waitUntilDone: false)
                }
            }
        }
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


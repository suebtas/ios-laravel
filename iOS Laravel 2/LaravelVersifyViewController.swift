//
//  ViewController.swift
//  iOS Laravel
//
//  Created by Suebtas on 10/8/2559 BE.
//  Copyright © 2559 Suebtas. All rights reserved.
//

import UIKit

class LaravelVersifyViewController: UIViewController {
    
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var textFieldUsername: UITextField!
    var tokenValue:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    var laravelClient: LaravelClient!
    
    @IBAction func VerifyMethod(_ sender: AnyObject) {
        let username = textFieldUsername.text!
        let password = textFieldPassword.text!

        laravelClient = LaravelClient(clientID: "", clientSecret: "")
        
        laravelClient.makeAuth(username, password, completion: { (result) in
            switch result {
            case .success(let tokenValue):
                self.tokenValue = tokenValue

                self.performSelector(onMainThread: #selector(LaravelVersifyViewController.updateTokenLabel(_:)),
                                     with: tokenValue, waitUntilDone: false)
                //self.updateTokenLabel(tokenValue)
                //self.refreshControl?.endRefreshing()
            case .failure(let error):
                // CHALLENGE: display an alert view to show error. error.localizedDescription
                print(error.localizedDescription)
            }
        })
        
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

